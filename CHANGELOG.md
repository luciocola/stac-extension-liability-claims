# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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
