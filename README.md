# Liability and Claims Extension Specification

- **Title:** Liability and Claims
- **Identifier:** <https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json>
- **Field Name Prefix:** liability
- **Scope:** Item, Collection, Assets, Item Assets, Summaries
- **Extension [Maturity Classification](https://github.com/radiantearth/stac-spec/tree/master/extensions/README.md#extension-maturity):** Proposal
- **Owner**: @luciocola Https://secure-dimensions.de
- **Version**: 1.1.0
- **JSON-LD Context:** [context.jsonld](./context.jsonld)
- **OGC Compliance:** Aligned with OGC Building Blocks standards (see [OGC-COMPLIANCE-ACTIONS.md](./OGC-COMPLIANCE-ACTIONS.md))
- **T21-DQ4IPT Compatibility:** Fully compatible with OGC Testbed-21 Data Quality Extension (see [T21-DQ4IPT-COMPATIBILITY-REPORT.md](./T21-DQ4IPT-COMPATIBILITY-REPORT.md))

This extension provides fields for documenting liability information and claims associated with geospatial data. It is designed to track incidents, damages, legal proceedings, and insurance information related to spatial data assets.

## Compatibility with OGC T21-DQ4IPT

This extension is **fully compatible** with the [OGC Testbed-21 Data Quality for Identity, Provenance, and Trust (T21-DQ4IPT)](https://github.com/xxx/dq) extension. Both extensions can be used together in the same STAC Items and Collections for comprehensive metadata:

- **T21-DQ4IPT (`dq:quality`)** - Technical ISO 19157 data quality reporting
- **Liability-Claims (`liability:quality`)** - Legal/regulatory quality + ISO 19115 backward compatibility
- **Liability-Claims (`liability:prov`)** - W3C PROV provenance (complements T21-DQ4IPT's quality tracking)
- **Liability-Claims security fields** - Classification and access control

**Compatibility Rating:** 4.5/5 stars - See [T21-DQ4IPT-COMPATIBILITY-REPORT.md](./T21-DQ4IPT-COMPATIBILITY-REPORT.md) for detailed analysis and [examples/dual-extension-item.json](./examples/dual-extension-item.json) for working example.

## Use Cases

This extension supports several important use cases:

1. **Environmental Liability Tracking**: Document environmental incidents, affected areas, and associated claims
2. **Insurance Claims Management**: Link geospatial data with insurance claims and coverage information
3. **Legal Compliance**: Track legal jurisdictions, responsible parties, and resolution status
4. **Damage Assessment**: Record estimated damages and affected geographic areas
5. **Evidence Management**: Reference supporting documentation and evidence for claims

## Data Quality Support

This extension includes comprehensive support for data quality reporting based on international standards:

- **ISO 19157-1:2023** (RECOMMENDED) - Comprehensive data quality framework with metaquality, usability, and standardized evaluation methods. Provides registered quality measures with unique identifiers for consistent reporting across organizations.
- **ISO 19115** - Core data quality elements (completeness, logical consistency, positional accuracy, temporal accuracy, thematic accuracy, attribute accuracy, topological consistency, lineage) - maintained for backward compatibility
- **ISO 19115-4** - Imagery and gridded data quality extensions (radiometric accuracy, sensor quality, cloud coverage, snow coverage, processing level, usability assessment) - maintained for backward compatibility. **NEW**: Now integrated with HEIF/HEIC imagery processing for automatic metadata extraction from modern image formats.
- **DGIWG** - Defence Geospatial Information Working Group quality elements (absolute/relative positional accuracy, gridded data accuracy, quantitative/non-quantitative attribute correctness, format/domain consistency, temporal validity)

**Migration**: Existing ISO 19115/19115-4 quality reports are fully supported. Organizations can migrate to ISO 19157-1:2023 for enhanced capabilities including metaquality (quality of quality), usability assessment, and standardized measure identifiers. See [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) for detailed migration guide.

Quality information can be attached to Items and Collections using the `liability:quality` field, which accepts both ISO 19157-1:2023 and ISO 19115-compliant quality reports. Standalone JSON Schemas are provided:
- `json-schema/iso19157-quality.json` (ISO 19157-1:2023 - RECOMMENDED)
- `json-schema/iso19115-quality.json` (ISO 19115/19115-4 - backward compatibility)

### Enhanced Lineage Support (ISO 19115-4 Aligned)

The `liability:quality` field now includes full support for **ISO 19115-4 lineage management**, following the official JSON schema structure from [ISO-TC211/XML](https://github.com/ISO-TC211/XML/tree/master/schemas.isotc211.org/json/19115/-4).

**Lineage capabilities include:**

- **Statement**: General explanation of data producer's knowledge about dataset lineage
- **Process Steps**: Detailed event/transformation documentation including:
  - Description, rationale, and timestamp of each step
  - Processor identification (person/organization) with contact info
  - Processing information: software, algorithms, parameters, documentation
  - References to methodology papers and technical documentation
- **Source Information**: Complete source data provenance including:
  - Source citations with identifiers and URLs
  - Source reference systems (CRS/EPSG codes)
  - Source metadata references
  - Spatial and temporal extents of source data
- **Additional Documentation**: Links to processing specifications, QA reports, and technical documents

**Example use case**: Document satellite imagery processing from raw L1C → atmospherically corrected → geometrically corrected → classified land cover, with full traceability of software, algorithms, parameters, and source datasets at each step.

See `examples/item-with-iso19115-lineage.json` for a complete example showing multi-stage processing lineage.

### W3C PROV Provenance Support

**NEW in v1.1.0:** The extension now supports W3C PROV (Provenance) model alongside ISO 19115 lineage through the `liability:prov` field. This enables:

- **Semantic Web Integration**: Full compatibility with W3C PROV tools, SPARQL queries, and Linked Data platforms
- **Explicit Attribution**: Clear tracking of responsibility chains using PROV agents and delegation
- **Complex Provenance Graphs**: Support for multiple derivation paths and influence relationships
- **Interoperability**: Bridge between geospatial (ISO 19115) and semantic web (PROV) communities

Both `liability:quality` (ISO 19115) and `liability:prov` (W3C PROV) can be used together for maximum interoperability. See [PROV-ISO19115-MAPPING.md](PROV-ISO19115-MAPPING.md) for detailed mapping guidelines and conversion strategies.

### Verifiable Credentials 2.0 Support

**NEW in v1.2.0:** The extension now supports W3C Verifiable Credentials Data Model 2.0 for cryptographically verifiable liability claims, quality reports, and provenance information through the `liability:verifiable_credentials` field. This enables:

- **Cryptographic Verification**: Digital signatures proving authenticity of claims and quality assessments
- **Selective Disclosure**: Reveal only necessary information using SD-JWT or BBS+ signatures
- **Decentralized Trust**: Use DIDs (Decentralized Identifiers) for issuer/subject identification
- **Tamper Evidence**: Detect unauthorized modifications to metadata
- **Compliance Evidence**: Verifiable proof of ISO 19157 quality standards compliance
- **Legal Standing**: Digitally signed liability claims with non-repudiation

Verifiable Credentials can wrap existing `liability:quality`, `liability:prov`, or claim metadata to provide cryptographic assurance. See [VC-2.0-INTEGRATION.md](VC-2.0-INTEGRATION.md) for detailed integration guide, examples, and best practices.

### Interoperability with Metadata Standards

The extension's ISO 19115 foundation provides high compatibility with major geospatial metadata frameworks:

- **NASA UMM (Unified Metadata Model)** - 5/5 compatibility rating through ISO 19115 alignment. See [UMM Compatibility Assessment](UMM-COMPATIBILITY.md) for detailed crosswalk.
- **OGC TrainingDML-AI** - 4/5 compatibility rating for ML training data quality/provenance metadata. See [TrainingDML-AI Compatibility Assessment](TRAININGDML-AI-COMPATIBILITY.md) for use cases and mapping guidance.

### HEIF/HEIC Imagery Metadata Support

**NEW**: The extension now includes automatic ISO 19115-4 metadata extraction for **HEIF/HEIC** imagery formats (High Efficiency Image Format). When processing HEIF imagery through compatible tools (e.g., QGIS HEIF/TTL Importer, IPFS Imagery Uploader), the following metadata is automatically extracted and can be included in STAC items:

**Extracted ISO 19115-4 Elements:**
- **Processing Level** (L0, L1A, L1B, L2A) - Radiometric/geometric correction status
- **Sensor Quality** - Calibration status and sensor health from EXIF
- **Acquisition Information** - Platform (camera make/model), sensor type, acquisition datetime
- **Usability Assessment** - Fitness for geospatial applications (0.0-1.0 score)
- **Gridded Data Representation** - Image dimensions, spatial structure
- **Radiometric Accuracy** - Quality of radiometric measurements (when available)
- **Cloud Coverage** - Imagery obscuration percentage (when applicable)

**Integration Points:**
- Metadata embedded in `liability:quality` field as ISO 19115-4 quality reports
- Provenance tracking in `liability:prov` using W3C PROV-O
- Compatible with STAC Processing Extension for georeferencing workflows
- BLAKE3 cryptographic hashing for integrity verification

**Supported Tools:**
- [QGIS HEIF/TTL Importer](https://github.com/luciocola/QGIS-GIMI_importer) - Automatic georeferencing with ISO 19115-4 metadata extraction
- IPFS Imagery Uploader (QGIS plugin) - Upload HEIF imagery to IPFS with quality metadata
- Compatible with TB21 GIMI format (embedded RDF metadata)

**Example STAC Item with HEIF ISO 19115-4 Metadata:**
```json
{
  "stac_version": "1.0.0",
  "type": "Feature",
  "id": "heif-imagery-001",
  "properties": {
    "datetime": "2026-01-28T14:30:00Z",
    "liability:quality": [{
      "type": "processingLevel",
      "level": "L0",
      "description": "HEIF imagery - unprocessed sensor data"
    }, {
      "type": "sensorQuality",
      "sensorType": "iPhone 12 Pro",
      "calibrationStatus": "unknown"
    }, {
      "type": "usabilityAssessment",
      "usabilityScore": 0.9,
      "intendedUse": "Geospatial imagery analysis"
    }]
  },
  "assets": {
    "image": {
      "href": "./imagery.heic",
      "type": "image/heif",
      "roles": ["data"]
    }
  }
}
```

See [ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md](ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md) for detailed mapping between ISO 19115-4 imagery quality elements and ISO 19157-3 data quality measures.

### Cloud Coverage and Conformance Statements

**Quick Reference**: The extension provides full ISO 19115-4 support for **cloud coverage assessment** and **conformance statements** essential for satellite imagery quality reporting.

**Key Features:**
- ✅ `cloudCoverage` element with percentage and assessment method
- ✅ `snowCoverage` element for snow/ice monitoring
- ✅ `conformance` result for pass/fail against specifications
- ✅ Integration with all ISO 19115-4 imagery quality elements

**Example Usage:**
```json
{
  "liability:quality": {
    "elements": [{
      "elementType": "cloudCoverage",
      "detail": {
        "type": "cloudCoverage",
        "coveragePercentage": 8.5,
        "assessmentMethod": "Automated scene classification"
      },
      "conformance": {
        "specification": "Sentinel-2 Product Specification",
        "pass": true,
        "explanation": "Cloud coverage <10% meets operational requirements"
      }
    }]
  }
}
```

**Documentation:**
- 📖 Complete guide: [CLOUD-COVERAGE-CONFORMANCE-GUIDE.md](CLOUD-COVERAGE-CONFORMANCE-GUIDE.md)
- 📋 COP integration example: [examples/item-cop-with-cloud-coverage.json](examples/item-cop-with-cloud-coverage.json)
- 🎯 Imagery quality example: [examples/item-with-imagery-quality.json](examples/item-with-imagery-quality.json)

**Schema Compatibility:** The cloud coverage and conformance schemas are **100% identical to ISO 19115-4**, providing full interoperability with standard geospatial metadata workflows.

## Fields

The fields in the table below can be used in these parts of STAC documents:

- [ ] Catalogs
- [x] Collections
- [x] Item Properties (incl. Summaries in Collections)
- [x] Assets (for both Collections and Items, incl. Item Asset Definitions in Collections)
- [ ] Links

| Field Name                        | Type                      | Description |
| --------------------------------- | ------------------------- | ----------- |
| liability:responsible_party       | string                    | **RECOMMENDED.** Name or identifier of the party responsible for the liability or claim |
| liability:claim_status            | string                    | **RECOMMENDED.** Current status of the liability claim. One of: `pending`, `under_investigation`, `accepted`, `rejected`, `settled`, `closed` |
| liability:claim_id                | string                    | **RECOMMENDED.** Unique identifier for the liability claim |
| liability:claim_date              | string                    | Date when the claim was filed (RFC 3339 format) |
| liability:claim_type              | string                    | Type or category of the liability claim. One of: `environmental`, `property_damage`, `personal_injury`, `financial`, `operational`, `other` |
| liability:coverage_area           | GeoJSON Geometry Object   | Geographic area affected by the claim |
| liability:affected_parties        | \[Affected Party Object\] | List of parties affected by or involved in the claim |
| liability:damages_estimated       | number                    | Estimated monetary value of damages (must be >= 0) |
| liability:damages_currency        | string                    | Currency code for damages (ISO 4217, e.g., USD, EUR, GBP) |
| liability:legal_jurisdiction      | string                    | Legal jurisdiction under which the claim falls |
| liability:incident_date           | string                    | Date when the incident occurred that led to the claim (RFC 3339 format) |
| liability:resolution_date         | string                    | Date when the claim was resolved (RFC 3339 format) |
| liability:resolution_status       | string                    | Final resolution outcome. One of: `in_favor`, `against`, `partial_settlement`, `dismissed`, `withdrawn` |
| liability:insurance_provider      | string                    | Name of the insurance provider covering the claim |
| liability:policy_number           | string                    | Insurance policy number associated with the claim |
| liability:evidence_refs           | \[string\]                | References to evidence documents, images, or other supporting materials (URIs or STAC Asset keys) |
| liability:notes                   | string                    | Additional notes or comments about the claim |
| liability:origin                  | string                    | Origin or source organization of the claim data |
| liability:quality                 | Quality Report Object or \[Quality Report Object\] | ISO 19157-1:2023 (RECOMMENDED) or ISO 19115/19115-4/DGIWG-compliant data quality report(s). See [ISO 19157 Schema](json-schema/iso19157-quality.json) and [ISO 19115 Schema](json-schema/iso19115-quality.json). ISO 19157 provides metaquality, usability assessment, and standardized measures. Both formats maintain full provenance compatibility with W3C PROV. |
| liability:prov                    | PROV Document Object      | **NEW in v1.1.0.** W3C PROV-JSON provenance information following PROV-DM model with entities, activities, and agents. See [W3C PROV](https://www.w3.org/TR/prov-overview/) |
| liability:verifiable_credentials  | \[Verifiable Credential Object\] | **NEW in v1.2.0.** Array of W3C Verifiable Credentials 2.0 providing cryptographically signed assertions about quality, provenance, or liability claims. See [VC-2.0-INTEGRATION.md](VC-2.0-INTEGRATION.md) |

### Asset-Level Fields

The following fields can be used in STAC Asset objects to specify security classification and access requirements:

| Field Name                             | Type                      | Description |
| -------------------------------------- | ------------------------- | ----------- |
| liability:security_classification      | string                    | Security classification level. One of: `public`, `internal`, `confidential`, `restricted`, `classified` |
| liability:access_restrictions          | \[string\]                | List of access restrictions (e.g., `legal_hold`, `court_order`, `privacy_constraints`) |
| liability:required_roles               | \[string\]                | **NEW in v1.1.0.** Roles required to access this asset (enforced at API level via OpenAPI security schemes) |
| ~~liability:access_control~~           | ~~Access Control Object~~ | **DEPRECATED in v1.1.0.** Use API-level security (OpenAPI `securitySchemes`) instead. Will be removed in v2.0.0. |
| ~~liability:alternate~~                | ~~Map<string, Alternate>~~| **DEPRECATED in v1.1.0.** Use standard STAC assets with different hrefs or `links` with `rel='alternate'` instead. Will be removed in v2.0.0. |

**Important Note on Authentication (v1.1.0+):**

Authentication and authorization are **API-level concerns** and should be configured in the STAC API's OpenAPI specification using standard `securitySchemes`, not in STAC Item/Collection metadata. STAC Items should only contain:
- **Security classification metadata** (what data this is)
- **Access restrictions** (legal/policy constraints)
- **Required roles** (who should have access)

The actual authentication mechanisms (API keys, OAuth2, etc.) should be defined in your STAC API's `openapi.yaml`. See [examples/stac-api-openapi.yaml](examples/stac-api-openapi.yaml) for a complete example.

### Additional Field Information

#### Affected Party Object

| Field Name | Type   | Description |
| ---------- | ------ | ----------- |
| name       | string | Name of the affected party |
| role       | string | Role or relationship to the claim (e.g., `claimant`, `witness`, `third_party`) |
| contact    | string | Contact information for the affected party |

#### liability:claim_status

The status field follows a typical claim lifecycle:

- `pending`: Claim has been filed but not yet reviewed
- `under_investigation`: Claim is being actively investigated
- `accepted`: Claim has been accepted for processing
- `rejected`: Claim has been rejected
- `settled`: Claim has been settled between parties
- `closed`: Claim has been finalized and closed

#### liability:claim_type

Categories of claims that can be tracked:

- `environmental`: Environmental damage or pollution incidents
- `property_damage`: Physical damage to property
- `personal_injury`: Claims involving personal injury
- `financial`: Financial losses or damages
- `operational`: Operational incidents or failures
- `other`: Other types of claims not covered above

#### liability:security_classification

Security classification levels for assets:

- `public`: Publicly accessible information
- `internal`: Internal use only, not for external distribution
- `confidential`: Confidential information requiring authorized access
- `restricted`: Highly restricted access (e.g., attorney-client privilege)
- `classified`: Classified information requiring security clearance

#### liability:required_roles

**NEW in v1.1.0:** Specifies which user roles are required to access an asset. The actual enforcement happens at the API level through OpenAPI security schemes. This field provides metadata about access requirements.

Example:
```json
"liability:required_roles": ["investigator", "legal_counsel"]
```

#### Deprecated Fields (v1.1.0)

The following fields are **deprecated** as of v1.1.0 and will be removed in v2.0.0:

- **`liability:access_control`** - Replaced by API-level OpenAPI `securitySchemes`
- **`liability:alternate`** - Replaced by standard STAC `assets` (with different hrefs) or `links` with `rel="alternate"`

**Migration Guide:**

*Old approach (v1.0.0):*
```json
"assets": {
  "evidence": {
    "href": "https://secure.example.com/image.tif",
    "liability:access_control": {
      "required_auth": true,
      "auth_methods": ["apiKey"]
    }
  }
}
```

*New approach (v1.1.0):*
```json
// In STAC Item:
"assets": {
  "evidence": {
    "href": "https://secure.example.com/image.tif",
    "liability:security_classification": "confidential",
    "liability:required_roles": ["investigator"]
  }
}

// In STAC API openapi.yaml:
components:
  securitySchemes:
    ClaimsApiKey:
      type: apiKey
      in: header
      name: X-Claims-API-Key
security:
  - ClaimsApiKey: []
```

### W3C PROV Provenance Support

**NEW in v1.1.0:** The `liability:prov` field provides W3C PROV-JSON compliant provenance tracking alongside ISO 19115 lineage. This enables interoperability with W3C PROV tools and semantic web applications.

#### PROV vs ISO 19157 / ISO 19115 Lineage

Both fields serve provenance and quality needs but use different models:

- **`liability:quality` (ISO 19157 / ISO 19115 lineage)**: Geospatial standards focused on data quality and processing history. ISO 19157-1:2023 recommended for comprehensive quality framework with metaquality and usability assessment. ISO 19115 maintained for backward compatibility. Preferred for GIS workflows.
- **`liability:prov` (W3C PROV)**: Semantic web standard for machine-readable provenance graphs using entities, activities, and agents. Enables SPARQL queries and RDF integration. Preferred for linked data and semantic web applications.

You can use **both fields together** for maximum interoperability. Both formats maintain full **identity and provenance compatibility** - quality reports can be tracked as PROV entities, and quality assessments as PROV activities. See [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) for detailed integration guidance.

#### PROV Core Concepts

The PROV data model uses three main types:

- **Entity**: Things (datasets, files, documents) - identified with qualified names
- **Activity**: Processes that act upon entities (data processing, analysis)
- **Agent**: Responsible parties (people, organizations, software)

Relations connect these types:
- `wasGeneratedBy`: Entity was created by Activity
- `used`: Activity consumed Entity
- `wasAttributedTo`: Entity was created by Agent
- `wasAssociatedWith`: Activity was performed by Agent
- `wasDerivedFrom`: Entity was derived from another Entity
- `actedOnBehalfOf`: Agent acted on behalf of another Agent

#### PROV Field Structure

```json
"liability:prov": {
  "prefix": {
    "ex": "http://example.org/",
    "prov": "http://www.w3.org/ns/prov#"
  },
  "entity": {
    "ex:entity1": {
      "prov:type": "prov:Dataset",
      "prov:label": "Output dataset"
    }
  },
  "activity": {
    "ex:activity1": {
      "prov:type": "prov:ProcessExecution",
      "prov:startTime": "2025-01-15T10:00:00Z",
      "prov:endTime": "2025-01-15T12:00:00Z",
      "prov:label": "Data processing"
    }
  },
  "agent": {
    "ex:agent1": {
      "prov:type": "prov:Person",
      "prov:label": "Dr. Jane Smith"
    }
  },
  "wasGeneratedBy": {
    "_:wgb1": {
      "prov:entity": "ex:entity1",
      "prov:activity": "ex:activity1"
    }
  },
  "wasAssociatedWith": {
    "_:waw1": {
      "prov:activity": "ex:activity1",
      "prov:agent": "ex:agent1"
    }
  }
}
```

#### When to Use PROV

Use `liability:prov` when:
- Integrating with semantic web tools (SPARQL, RDF stores)
- Complex provenance graphs with multiple derivation chains
- Need to track responsibility and attribution explicitly
- Compliance with W3C standards is required
- Cross-domain provenance (beyond geospatial)

#### PROV References

- [W3C PROV Overview](https://www.w3.org/TR/prov-overview/)
- [PROV-DM (Data Model)](https://www.w3.org/TR/prov-dm/)
- [PROV-JSON Specification](https://www.w3.org/Submission/prov-json/)
- [PROV Primer](https://www.w3.org/TR/prov-primer/)

## Examples

### Example 1: Environmental Liability Claim

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "environmental-incident-2024-001",
  "bbox": [-122.5, 37.7, -122.3, 37.9],
  "geometry": {
    "type": "Polygon",
    "coordinates": [[
      [-122.5, 37.7],
      [-122.3, 37.7],
      [-122.3, 37.9],
      [-122.5, 37.9],
      [-122.5, 37.7]
    ]]
  },
  "properties": {
    "datetime": "2024-01-15T10:30:00Z",
    "liability:claim_id": "ENV-2024-001",
    "liability:claim_type": "environmental",
    "liability:claim_status": "under_investigation",
    "liability:claim_date": "2024-01-20T09:00:00Z",
    "liability:incident_date": "2024-01-15T10:30:00Z",
    "liability:responsible_party": "Industrial Corp XYZ",
    "liability:affected_parties": [
      {
        "name": "Local Municipality",
        "role": "claimant",
        "contact": "claims@municipality.gov"
      },
      {
        "name": "Environmental Protection Agency",
        "role": "third_party",
        "contact": "epa@agency.gov"
      }
    ],
    "liability:damages_estimated": 500000,
    "liability:damages_currency": "USD",
    "liability:legal_jurisdiction": "State of California",
    "liability:insurance_provider": "Global Insurance Inc.",
    "liability:policy_number": "ENV-POL-123456",
    "liability:coverage_area": {
      "type": "Polygon",
      "coordinates": [[
        [-122.5, 37.7],
        [-122.3, 37.7],
        [-122.3, 37.9],
        [-122.5, 37.9],
        [-122.5, 37.7]
      ]]
    },
    "liability:evidence_refs": [
      "satellite-imagery-2024-01-15",
      "https://evidence.example.com/photos/site-001.jpg",
      "https://evidence.example.com/reports/water-quality.pdf"
    ],
    "liability:notes": "Spill incident affecting local water source. Satellite imagery shows contamination spread."
  },
  "assets": {
    "satellite-imagery-2024-01-15": {
      "href": "https://example.com/imagery/2024-01-15.tif",
      "type": "image/tiff; application=geotiff",
      "title": "Incident Day Satellite Imagery",
      "roles": ["data", "evidence"]
    }
  },
  "links": []
}
```

### Example 2: Property Damage Claim (Settled)

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "property-damage-2023-042",
  "bbox": [-0.15, 51.5, -0.1, 51.55],
  "geometry": {
    "type": "Point",
    "coordinates": [-0.125, 51.525]
  },
  "properties": {
    "datetime": "2023-06-10T14:20:00Z",
    "liability:claim_id": "PROP-2023-042",
    "liability:claim_type": "property_damage",
    "liability:claim_status": "settled",
    "liability:claim_date": "2023-06-15T08:30:00Z",
    "liability:incident_date": "2023-06-10T14:20:00Z",
    "liability:resolution_date": "2023-09-20T16:00:00Z",
    "liability:resolution_status": "partial_settlement",
    "liability:responsible_party": "Construction Company ABC",
    "liability:affected_parties": [
      {
        "name": "Building Owner Ltd",
        "role": "claimant",
        "contact": "legal@buildingowner.com"
      }
    ],
    "liability:damages_estimated": 75000,
    "liability:damages_currency": "GBP",
    "liability:legal_jurisdiction": "England and Wales",
    "liability:insurance_provider": "UK Liability Insurance",
    "liability:policy_number": "UKL-789012",
    "liability:evidence_refs": [
      "drone-survey-damage",
      "https://evidence.example.com/structural-report.pdf"
    ],
    "liability:notes": "Construction work caused structural damage to adjacent building. Settled for £60,000."
  },
  "assets": {
    "drone-survey-damage": {
      "href": "https://example.com/surveys/damage-assessment.tif",
      "type": "image/tiff; application=geotiff",
      "title": "Drone Survey - Damage Assessment",
      "roles": ["data", "evidence"]
    }
  },
  "links": []
}
```

### Example 3: Secure Asset with Security Classification (v1.1.0)

This example demonstrates the **recommended v1.1.0 approach** for secure assets. Authentication is handled at the API level (see `examples/stac-api-openapi.yaml`):

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json",
    "https://stac-extensions.github.io/file/v2.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "environmental-incident-2024-secure",
  "bbox": [-122.5, 37.7, -122.3, 37.9],
  "geometry": {
    "type": "Polygon",
    "coordinates": [[
      [-122.5, 37.7],
      [-122.3, 37.7],
      [-122.3, 37.9],
      [-122.5, 37.9],
      [-122.5, 37.7]
    ]]
  },
  "properties": {
    "datetime": "2024-11-15T10:30:00Z",
    "liability:claim_id": "ENV-2024-SECURE-001",
    "liability:claim_type": "environmental",
    "liability:claim_status": "under_investigation",
    "liability:origin": "Environmental Protection Agency"
  },
  "assets": {
    "satellite-imagery-secure": {
      "href": "https://assets.claims.example.com/api/v1/evidence/sat-2024-11-15.tif",
      "title": "Satellite Imagery - Confidential Evidence",
      "type": "image/tiff; application=geotiff",
      "roles": ["data", "evidence"],
      "file:checksum": "1220e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      "liability:security_classification": "confidential",
      "liability:access_restrictions": [
        "legal_hold",
        "authorized_investigators_only",
        "privacy_act_protected"
      ],
      "liability:required_roles": ["investigator", "legal_counsel"]
    },
    "investigation-report": {
      "href": "https://assets.claims.example.com/api/v1/reports/inv-2024-001.pdf",
      "title": "Investigation Report - Restricted",
      "type": "application/pdf",
      "roles": ["metadata", "evidence"],
      "liability:security_classification": "restricted",
      "liability:access_restrictions": [
        "attorney_client_privilege",
        "work_product_doctrine"
      ],
      "liability:required_roles": ["legal_counsel"]
    },
    "public-overview": {
      "href": "https://public.claims.example.com/overview-2024-001.jpg",
      "title": "Public Overview Image",
      "type": "image/jpeg",
      "roles": ["overview"],
      "liability:security_classification": "public"
    }
  },
  "links": [
    {
      "rel": "alternate",
      "href": "https://portal.claims.example.com/items/ENV-2024-SECURE-001",
      "title": "View in authenticated web portal",
      "type": "text/html"
    }
  ]
}
```

**Note:** For the corresponding API-level authentication configuration, see `examples/stac-api-openapi.yaml`.

### Example 4: Data Quality Reporting (ISO 19115-4 and DGIWG)

This example demonstrates quality reporting for satellite imagery and defence geospatial data. See `examples/item-with-imagery-quality.json` for the full example.

### Example 5: W3C PROV Provenance Tracking

This example demonstrates complete W3C PROV-JSON provenance tracking with entities, activities, agents, and their relationships. It shows a multi-stage satellite image processing workflow with full attribution chains. See `examples/item-with-prov.json` for the complete example with detailed PROV graph.

**Key features demonstrated:**
- Multiple processing stages (atmospheric correction, geometric correction, classification)
- Source data tracking (Sentinel-2 imagery, DEM, training data)
- Person, Organization, and SoftwareAgent tracking
- Derivation chains showing data flow
- Delegation relationships (persons acting on behalf of organizations)

For guidance on mapping between ISO 19115 lineage and W3C PROV, see [PROV-ISO19115-MAPPING.md](PROV-ISO19115-MAPPING.md).

## Contributing

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "quality-report-example",
  "properties": {
    "datetime": "2025-11-27T10:30:00Z",
    "liability:claim_id": "CLM-SAT-0001",
    "liability:claim_type": "environmental",
    "liability:quality": {
      "reportId": "QR-2025-0001",
      "scope": "feature",
      "date": "2025-11-27T12:00:00Z",
      "summary": "Quality assessment for satellite imagery",
      "elements": [
        {
          "elementType": "processingLevel",
          "summary": "Satellite data processing level",
          "detail": {
            "type": "processingLevel",
            "level": "L2A",
            "description": "Surface reflectance with atmospheric correction",
            "processingDate": "2025-11-27T08:00:00Z",
            "processor": "Sen2Cor v2.10"
          }
        },
        {
          "elementType": "cloudCoverage",
          "summary": "Cloud coverage assessment",
          "detail": {
            "type": "cloudCoverage",
            "coveragePercentage": 12.5,
            "assessmentMethod": "Automated scene classification"
          }
        },
        {
          "elementType": "absoluteExternalPositionalAccuracy",
          "summary": "Absolute positional accuracy",
          "detail": {
            "type": "absoluteExternalPositionalAccuracy",
            "horizontalAccuracy": 5.0,
            "verticalAccuracy": 3.0,
            "units": "m",
            "method": "GNSS survey with ground control points"
          },
          "conformance": {
            "specification": "DGIWG-500",
            "pass": true,
            "explanation": "Meets DGIWG accuracy requirements"
          }
        }
      ]
    }
  },
  "geometry": {
    "type": "Point",
    "coordinates": [12.0, 45.0]
  },
  "assets": {}
}
```

See the [examples directory](examples/) for complete examples including:
- `item-with-quality.json` - ISO 19115 quality elements
- `item-with-imagery-quality.json` - ISO 19115-4 imagery quality
- `item-with-dgiwg-quality.json` - DGIWG defence geospatial quality
- `collection-with-quality.json` - Collection-level quality reporting

## Contributing

All contributions are subject to the
[STAC Specification Code of Conduct](https://github.com/radiantearth/stac-spec/blob/master/CODE_OF_CONDUCT.md).
For contributions, please follow the
[STAC specification contributing guide](https://github.com/radiantearth/stac-spec/blob/master/CONTRIBUTING.md) Instructions
for running tests are copied here for convenience.

### Running tests

The same checks that run as checks on PR's are part of the repository and can be run locally to verify that changes are valid. 
To run tests locally, you'll need `npm`, which is a standard part of any [node.js installation](https://nodejs.org/en/download/).

First you'll need to install everything with npm once. Just navigate to the root of this repository and on 
your command line run:
```bash
npm install
```

Then to check markdown formatting and test the examples against the JSON schema, you can run:
```bash
npm test
```

This will spit out the same texts that you see online, and you can then go and fix your markdown or examples.

If the tests reveal formatting problems with the examples, you can fix them with:
```bash
npm run format-examples
```

## OGC Building Blocks Compliance

This extension is aligned with [OGC Building Blocks](https://opengeospatial.github.io/bblocks/) standards for enhanced interoperability:

### Semantic Web Support

- **JSON-LD Context**: [`context.jsonld`](./context.jsonld) enables RDF uplift and SPARQL queries
- **Ontology Mappings**: Fields map to Schema.org, W3C Legal, FIBO, DQV, and PROV ontologies
- **Linked Data**: Compatible with semantic web tools and knowledge graphs

### Dependencies

This extension builds on:
- `ogc.contrib.stac.item` - Base STAC Item schema
- `ogc.contrib.stac.collection` - Base STAC Collection schema  
- `ogc.ogc-utils.prov` - W3C PROV provenance schema (via [`json-schema/prov-ref.json`](./json-schema/prov-ref.json))

### Validation

This extension includes comprehensive validation capabilities:

#### JSON Schema Validation

Automated JSON Schema validation tests are available in the [`tests/`](./tests/) directory:

```bash
# Install JSON Schema validator
npm install -g ajv-cli

# Validate examples
ajv validate -s json-schema/schema.json -d "tests/valid/*.json"

# Test invalid examples
! ajv validate -s json-schema/schema.json -d "tests/invalid/*.json"
```

#### SHACL Semantic Validation

**NEW in v1.1.0:** The extension includes SHACL (Shapes Constraint Language) validation rules for semantic validation of provenance graphs:

```bash
# Install pyshacl
pip install pyshacl rdflib

# Convert JSON-LD example to Turtle
riot --syntax=jsonld --output=turtle examples/item-with-prov.json > item.ttl

# Run SHACL validation
pyshacl -s shacl/liability-claims-shapes.ttl -df turtle -sf turtle item.ttl
```

**SHACL validation rules include:**
- **Core extension properties** validation (liability_framework, jurisdiction, etc.)
- **PROV provenance graphs** validation (entities, activities, agents)
- **Temporal consistency** checks (activity start/end times, derivation ordering)
- **Graph completeness** checks (referenced entities/agents exist)
- **Quality metadata** validation (ISO 19115 quality measurements)

See [`shacl/README.md`](./shacl/README.md) for detailed documentation on SHACL validation rules and usage.

#### CI/CD Validation

Automated validation runs on every push and pull request via GitHub Actions:
- JSON Schema validation across Python 3.9-3.12
- SHACL semantic validation
- OGC Building Blocks compliance checks
- Security scanning
- Documentation validation

See [`.github/workflows/validate.yml`](.github/workflows/validate.yml) for the complete CI/CD pipeline.

See [OGC-COMPLIANCE-ACTIONS.md](./OGC-COMPLIANCE-ACTIONS.md) for detailed compliance documentation.

## References

- [STAC Specification](https://stacspec.org/)
- [ISO 19115 Geographic Information - Metadata](https://www.iso.org/standard/53798.html)
- [W3C PROV-DM](https://www.w3.org/TR/prov-dm/)
- [W3C PROV-JSON](https://www.w3.org/Submission/prov-json/)
- [OGC Building Blocks](https://opengeospatial.github.io/bblocks/)
- [NASA UMM](https://earthdata.nasa.gov/eosdis/science-system-description/eosdis-components/common-metadata-repository/unified-metadata-model)

## License

This extension is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
