# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added - ISO TC211 Official Schema Alignment (In Progress)

- **ISO 19157 TC211 Alignment** (Hybrid approach - backward compatible with v1.1.0)
  - Schema updated to align with official ISO TC211 JSON schemas: https://github.com/ISO-TC211/XML
  - Support both v1.1.0 style (`category`, `resultType`) and ISO TC211 style (`type` discriminators)
  - Accept both inline citations and structured CI_Citation references
  - ConformanceResult accepts both `"type": "ConformanceResult"` (ISO) and `"resultType": "conformance"` (v1.1.0)
  - Quality elements support optional `type` field (e.g., `"type": "AbsolutePositionalAccuracy"`) alongside existing `category`
  - Full backward compatibility: all v1.1.0 items validate without changes
  - Migration guide: [ISO-TC211-ALIGNMENT.md](./ISO-TC211-ALIGNMENT.md)

### Added - Schema Formalization & Semantic Lifting

- **Queryable ARD Quality Fields** (OGC T21-DQ4IPT Schema Formalization requirement)
  - Added 10 new top-level `ard:*` fields for simple API queries without navigating nested ISO 19157 structures
  - `ard:geometric_accuracy`, `ard:geometric_accuracy_unit`, `ard:geometric_accuracy_type` - Flattened positional accuracy metrics
  - `ard:radiometric_accuracy`, `ard:radiometric_accuracy_unit` - Flattened radiometric/thematic accuracy metrics
  - `ard:cloud_coverage` (optical sensors), `ard:data_mask_coverage` (radar sensors) - Sensor-specific coverage metrics
  - `ard:specification_compliance`, `ard:pfs_threshold_compliance`, `ard:pfs_target_compliance` - Multi-dimensional CEOS-ARD PFS compliance tracking
  - Enables CQL2 queries like `ard:geometric_accuracy <= 10 AND ard:cloud_coverage < 20`
  - Fields mirror values from authoritative ISO 19157 reports in `liability:quality.report[]` (no duplication, read-only derivations)
  
- **Semantic Lifting Workflow** (OGC T21-DQ4IPT Semantic Lifting requirement)
  - Enhanced `context.jsonld` with CEOS-ARD ontology namespace (`ceosard: https://ceos.org/ard/ontology#`)
  - Enhanced `context.jsonld` with ISO 19157-3 ontology namespace (`iso19157: https://def.isotc211.org/iso19157/-3/dqm/1.0/`)
  - All `ard:*` fields mapped to formal ontology concepts for automatic JSON→RDF conversion
  - Geometric accuracy → `iso19157:DQ_AbsoluteExternalPositionalAccuracy`
  - Radiometric accuracy → `iso19157:DQ_ThematicClassificationCorrectness`
  - Compliance metrics → `ceosard:conformsToSpecification`, `ceosard:thresholdRequirementsStatus`, `ceosard:targetRequirementsAchievement`
  - Enables semantic web interoperability and SPARQL queries across distributed catalogs
  
- **New Semantic Example**
  - `examples/semantic-lifting-example.ttl`: RDF/Turtle representation of Sentinel-2 ARD with complete ontology mappings
  - Demonstrates automatic JSON-LD to RDF conversion using enhanced context
  - Includes 4 SPARQL query examples (geometric accuracy filtering, cloud coverage + compliance, metaquality confidence, provenance chain)
  - Shows integration of CEOS-ARD, ISO 19157, W3C DQV, and W3C PROV ontologies
  
- **Documentation Enhancements**
  - Added "Schema Formalization: Queryable ARD Quality Fields" section to README.md
  - Detailed table of all `ard:*` fields with types, descriptions, and examples
  - CQL2 JSON and CQL2 Text query examples for common use cases
  - STAC API search request examples with curl commands
  - Comparison of nested vs flattened query approaches (demonstrates queryability improvement)
  - JSON Schema documentation for all `ard:*` fields in `json-schema/schema.json`

### Changed

- **Extension Maturity**: Advancing toward STAC Extension "Candidate" status
  - Addresses OGC T21-DQ4IPT #1 priority gap (CEOS-ARD formalization)
  - Implements Schema Formalization requirement (explicit metric mappings for API queries)
  - Implements Semantic Lifting requirement (JSON-LD ontology mappings for RDF conversion)
  - Enhances discoverability through queryable quality fields
  - Enables semantic interoperability through formal ontology integration

### Backward Compatibility

- **100% Backward Compatible**: All new `ard:*` fields are optional
- All existing v1.2.0 items validate unchanged
- ISO 19157 quality report structure unchanged (authoritative source maintained)
- W3C PROV provenance structure unchanged
- CEOS-ARD certification fields unchanged

## [1.2.0] - 2025-12-22

### Added - CEOS-ARD Integration

- **CEOS Analysis Ready Data Extension Integration**
  - Optional integration with [CEOS-ARD STAC Extension v0.2.0](https://github.com/stac-extensions/ceos-ard)
  - Supports both **optical sensors** (Surface Reflectance SR, Surface Temperature ST, Aquatic Reflectance AR, Nighttime Lights NLSR)
  - Supports **radar sensors** (Normalized Radar Backscatter NRB, Polarimetric Radar POL, Ocean Radar Backscatter ORB, Geocoded Single-Look Complex GSLC)
  - Addresses OGC T21-DQ4IPT Engineering Report (OGC 26-999) priority gap for ARD formalization
  - Enables Analysis Ready Data certification workflows with quality metadata
  
- **Quality Framework Alignment**
  - CEOS-ARD geometric accuracy requirements (Req 1.8, 1.7.11) mapped to ISO 19157 `positionalAccuracy`
  - CEOS-ARD radiometric uncertainty requirements (Req 1.12, 1.7.8) mapped to ISO 19157 `thematicAccuracy`
  - CEOS-ARD per-pixel quality masks (Req 2.x, 1.7.13) mapped to ISO 19157 `completeness`
  - CEOS-ARD compliance assessment mapped to ISO 19157 `usability` conformance results
  - Documented quality mapping in [INTEGRATION-PLAN.md](./INTEGRATION-PLAN.md)
  
- **New Examples**
  - `examples/item-with-ceos-ard-optical.json`: Sentinel-2 Surface Reflectance ARD (SR v5.0.1) with full ISO 19157 quality report
  - `examples/item-with-ceos-ard-radar.json`: Sentinel-1 Normalized Radar Backscatter ARD (NRB v1.2) with full ISO 19157 quality report
  - Both examples demonstrate parallel extension usage (liability-claims + CEOS-ARD coexist)
  - Complete asset role mappings (cloud, cloud-shadow, saturation, data-mask, metadata)
  
- **Integration Documentation** (`INTEGRATION-PLAN.md`)
  - Comprehensive CEOS-ARD integration roadmap
  - Backward compatibility analysis (100% compatible)
  - Quality mapping tables (CEOS-ARD requirements → ISO 19157 categories)
  - Testing strategy and implementation checklist
  - Future enhancement roadmap (semantic lifting, ML quality measures, real-time monitoring)

### Changed

- **Schema version** bumped from v1.1.0 to v1.2.0 (minor version, **zero breaking changes**)
- **Schema description** updated to document optional CEOS-ARD integration capability
- **Extension architecture** supports parallel extension usage:
  - `liability:*` namespace for liability and ISO 19157 quality fields
  - `ceosard:*` namespace for CEOS-ARD certification fields
  - No namespace conflicts, clean separation of concerns

### Backward Compatibility

- **100% backward compatible** with v1.1.0
- All existing items validate unchanged (CEOS-ARD fields optional)
- No modifications required to existing implementations
- Parallel extension architecture ensures zero impact on existing workflows
- Migration path: zero changes for existing items, opt-in for ARD certification

### Added - ISO 19157-1:2023 Data Quality Support (2025-12-21)

- **ISO 19157-1:2023 Integration** (`json-schema/iso19157-quality.json`)
  - Comprehensive data quality framework aligned with ISO 19157-1:2023 standard
  - Support for all ISO 19157 quality categories: completeness, logical consistency, positional accuracy, temporal quality, thematic quality, metaquality, and usability
  - Standardized quality measures with official ISO 19157 register codes
  - Structured evaluation methods (directInternal, directExternal, indirect)
  - Multiple result types: quantitative, conformance, descriptive, and coverage results
  - Enhanced lineage documentation inherited from ISO 19115
  - **Full backward compatibility** with existing ISO 19115/19115-4 quality reports
  
- **New Quality Categories**
  - **Metaquality**: Quality of quality information (confidence, representativity, homogeneity)
  - **Usability**: Fitness for purpose assessment with detailed use case evaluation
  - **Temporal Quality**: Enhanced temporal accuracy with consistency and validity checks
  
- **Integration Documentation** (`ISO19157-INTEGRATION.md`)
  - Comprehensive migration guide from ISO 19115 to ISO 19157
  - Best practices for ISO 19157 implementation
  - Mapping tables between ISO 19115 and ISO 19157 elements
  - Examples demonstrating identity and provenance compatibility
  
- **New Example** (`examples/item-with-iso19157-quality.json`)
  - Complete demonstration of ISO 19157-1:2023 quality report
  - Shows all major quality categories and result types
  - Includes metaquality (confidence) and usability assessments
  - Full W3C PROV provenance integration demonstrating identity preservation
  - Documents evaluation methods with standardized ISO 19157 measures

### Changed

- **liability:quality field** now supports both:
  - ISO 19157-1:2023 (RECOMMENDED) for comprehensive quality framework
  - ISO 19115/19115-4 (backward compatibility) for existing implementations
- Enhanced README with ISO 19157 documentation and migration guidance
- Updated schema descriptions to emphasize ISO 19157 as recommended approach
- Improved provenance compatibility documentation across all quality frameworks

### Backward Compatibility

- **100% backward compatible** with existing ISO 19115/19115-4 quality reports
- All existing `liability:quality` field content remains valid
- No breaking changes to API or schema structure
- Organizations can migrate to ISO 19157 at their own pace
- W3C PROV integration unchanged - full identity and provenance compatibility maintained

## [Unreleased] - Previous Changes

### Added - SHACL Validation and CI/CD Pipeline (2025-12-13)

- **SHACL Validation Rules** (`shacl/liability-claims-shapes.ttl`)
  - Comprehensive SHACL shapes for semantic validation of provenance graphs
  - Validates PROV entities, activities, agents with complete constraints
  - Temporal consistency checks (activity start/end times, derivation ordering)
  - Graph completeness validation (referenced entities/agents existence)
  - Quality metadata validation (ISO 19115/DQV measurements)
  - Support for complex provenance chains and delegation relationships
- **SHACL Documentation** (`shacl/README.md`)
  - Complete usage guide with pyshacl, Node.js, and Apache Jena examples
  - Validation workflow documentation
  - SPARQL query examples for complex constraints
- **GitHub Actions CI/CD Pipeline** (`.github/workflows/validate.yml`)
  - Multi-version JSON Schema validation (Python 3.9-3.12)
  - SHACL semantic validation with pyshacl and Apache Jena
  - OGC Building Blocks compliance verification
  - Security scanning with Trivy vulnerability scanner
  - Documentation completeness checks
  - Automated test suite with coverage reporting
  - Artifact generation (SHACL reports, OGC submission package)
- **Markdownlint Configuration** (`.markdownlint.json`)

### Changed

- Enhanced README.md with comprehensive validation section
  - Added SHACL validation examples and workflows
  - Documented CI/CD pipeline capabilities
  - Highlighted semantic validation features

### Added - OGC Building Blocks Alignment (2025-12-13)

- **JSON-LD Context** (`context.jsonld`) for semantic web interoperability and RDF uplift
  - Mappings to Schema.org, W3C Legal, FIBO, DQV, and PROV ontologies
  - Enables SPARQL queries and Linked Data integration
- **External PROV Schema Reference** (`json-schema/prov-ref.json`)
  - References `ogc.ogc-utils.prov` building block for consistency
  - Maintains backward compatibility with embedded PROV definitions
- **Validation Test Suite** (`tests/` directory)
  - 4 valid test examples (basic, PROV, quality, collection)
  - 4 invalid test examples demonstrating validation errors
  - Comprehensive testing documentation and CI/CD examples
- **OGC Compliance Documentation** (`OGC-COMPLIANCE-ACTIONS.md`)
  - Detailed alignment with OGC Building Blocks standards
  - Implementation summary and next steps

### Changed

- Updated `liability:prov` field to support both embedded and external schemas via `oneOf`
- Enhanced README with OGC Building Blocks section and validation instructions
- Improved interoperability score from 4/5 to 4.5/5

### Added - W3C PROV Support (2025-12-06)

- **W3C PROV Support**: New `liability:prov` field for W3C PROV-JSON provenance information
  - Full PROV-JSON schema definitions for entities, activities, agents, and all PROV relations
  - Support for complete PROV-DM model including wasGeneratedBy, used, wasDerivedFrom, wasAttributedTo, etc.
  - Enables semantic web integration and interoperability with W3C PROV tools
  - Complements existing ISO 19115 lineage support
- New example `examples/item-with-prov.json` demonstrating complete PROV provenance tracking
- Comprehensive mapping document `PROV-ISO19115-MAPPING.md` explaining relationship between PROV and ISO 19115 lineage
- Detailed PROV documentation in README with usage guidelines and references
- Snow coverage quality element (`snowCoverage`) for DGIWG metadata compliance
  - Follows same pattern as cloud coverage with percentage and assessment method
  - Aligns with DGIWG Metadata Foundation requirements for imagery quality assessment
  - Added schema definition in `json-schema/iso19115-quality.json`
  - Added example in `examples/item-with-imagery-quality.json`

## [1.1.0] - 2024-12-04

### Added
- `liability:required_roles` field for specifying roles required to access assets (enforced at API level)
- Comprehensive OpenAPI 3.0 example (`examples/stac-api-openapi.yaml`) demonstrating API-level security
- New example file `examples/item-with-security-v1.1.json` showing recommended v1.1.0 security approach
- STAC API compatibility assessment document (`STAC-API-COMPATIBILITY.md`)
- Migration guide in README for transitioning from v1.0.0 to v1.1.0

### Changed
- **BREAKING (deprecation)**: Separated security classification metadata from API authentication
- Updated extension identifier to `v1.1.0`
- Improved documentation emphasizing API-level security over item-level authentication
- Updated all examples to use `v1.1.0` extension URI
- Enhanced README with clearer distinction between data metadata and API authentication

### Deprecated
- `liability:access_control` field - Use OpenAPI `securitySchemes` at API level instead (will be removed in v2.0.0)
- `liability:alternate` field - Use standard STAC `assets` with different hrefs or `links` with `rel="alternate"` instead (will be removed in v2.0.0)

### Removed
- Detailed authentication scheme definitions from JSON schema asset fields
- Complex nested authentication objects that duplicated OpenAPI functionality

### Fixed
- Alignment with STAC and OGC API best practices for authentication and authorization
- Separation of concerns between data metadata (STAC) and API implementation (OpenAPI)

### Security
- Improved security model by moving authentication to API layer where it belongs
- Better alignment with OpenAPI 3.0 security schemes
- Clearer role-based access control (RBAC) implementation guidance

## [1.0.0] - 2024-11-25

### Added
- Initial release of STAC Liability and Claims Extension
- JSON Schema for liability and claims metadata
- Core fields for claim tracking:
  - `liability:claim_id` - Unique claim identifier
  - `liability:claim_status` - Current status of claim
  - `liability:claim_type` - Type/category of claim
  - `liability:responsible_party` - Responsible party identification
- Financial tracking fields:
  - `liability:damages_estimated` - Estimated damages value
  - `liability:damages_currency` - Currency code (ISO 4217)
- Legal and insurance fields:
  - `liability:legal_jurisdiction` - Legal jurisdiction
  - `liability:insurance_provider` - Insurance provider name
  - `liability:policy_number` - Policy number
- Temporal tracking:
  - `liability:incident_date` - When incident occurred
  - `liability:claim_date` - When claim was filed
  - `liability:resolution_date` - When claim was resolved
- Geospatial field:
  - `liability:coverage_area` - Geographic area affected by claim
- Supporting fields:
  - `liability:affected_parties` - List of affected parties
  - `liability:evidence_refs` - References to evidence
  - `liability:notes` - Additional comments
- Comprehensive README with documentation
- Example STAC items demonstrating extension usage
- Python validation script
- Shell script for batch validation

[Unreleased]: https://github.com/yourusername/stac-extension-liability-claims/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/stac-extension-liability-claims/releases/tag/v1.0.0
