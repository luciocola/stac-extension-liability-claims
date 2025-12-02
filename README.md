# Liability and Claims Extension Specification

- **Title:** Liability and Claims
- **Identifier:** <https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json>
- **Field Name Prefix:** liability
- **Scope:** Item, Collection
- **Extension [Maturity Classification](https://github.com/radiantearth/stac-spec/tree/master/extensions/README.md#extension-maturity):** Proposal
- **Owner**: @luciocola Https://secure-dimensions.de

This extension provides fields for documenting liability information and claims associated with geospatial data. It is designed to track incidents, damages, legal proceedings, and insurance information related to spatial data assets.

## Use Cases

This extension supports several important use cases:

1. **Environmental Liability Tracking**: Document environmental incidents, affected areas, and associated claims
2. **Insurance Claims Management**: Link geospatial data with insurance claims and coverage information
3. **Legal Compliance**: Track legal jurisdictions, responsible parties, and resolution status
4. **Damage Assessment**: Record estimated damages and affected geographic areas
5. **Evidence Management**: Reference supporting documentation and evidence for claims

## Data Quality Support

This extension includes comprehensive support for data quality reporting based on international standards:

- **ISO 19115** - Core data quality elements (completeness, logical consistency, positional accuracy, temporal accuracy, thematic accuracy, attribute accuracy, topological consistency, lineage)
- **ISO 19115-4** - Imagery and gridded data quality extensions (radiometric accuracy, sensor quality, cloud coverage, processing level, usability assessment)
- **DGIWG** - Defence Geospatial Information Working Group quality elements (absolute/relative positional accuracy, gridded data accuracy, quantitative/non-quantitative attribute correctness, format/domain consistency, temporal validity)

Quality information can be attached to Items and Collections using the `liability:quality` field, which accepts ISO 19115-compliant quality reports. A standalone JSON Schema for quality reports is provided at `json-schema/iso19115-quality.json`.

### Interoperability with Metadata Standards

The extension's ISO 19115 foundation provides high compatibility with major geospatial metadata frameworks:

- **NASA UMM (Unified Metadata Model)** - 5/5 compatibility rating through ISO 19115 alignment. See [UMM Compatibility Assessment](UMM-COMPATIBILITY.md) for detailed crosswalk.
- **OGC TrainingDML-AI** - 4/5 compatibility rating for ML training data quality/provenance metadata. See [TrainingDML-AI Compatibility Assessment](TRAININGDML-AI-COMPATIBILITY.md) for use cases and mapping guidance.

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
| liability:quality                 | Quality Report Object or \[Quality Report Object\] | ISO 19115/19115-4/DGIWG-compliant data quality report(s). See [Quality Schema](json-schema/iso19115-quality.json) |

### Asset-Level Fields

The following fields can be used in STAC Asset objects to control access and specify security requirements:

| Field Name                             | Type                      | Description |
| -------------------------------------- | ------------------------- | ----------- |
| liability:access_control               | Access Control Object     | Access control configuration for liability-related assets |
| liability:alternate                    | Map<string, Alternate>    | Alternative access methods with different authentication requirements |
| liability:security_classification      | string                    | Security classification level. One of: `public`, `internal`, `confidential`, `restricted`, `classified` |
| liability:access_restrictions          | \[string\]                | List of access restrictions (e.g., `legal_hold`, `court_order`, `privacy_constraints`) |

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

#### Access Control Object

Used in `liability:access_control` field at the asset level:

| Field Name    | Type       | Description |
| ------------- | ---------- | ----------- |
| required_auth | boolean    | Whether authentication is required to access this asset |
| auth_methods  | \[string\] | Available authentication methods (e.g., `apiKey`, `oauth2`, `cookie`, `certificate`) |
| auth_schemes  | object     | Detailed authentication scheme configurations keyed by scheme name |

#### Alternate Access Object

Used in `liability:alternate` field at the asset level, keyed by access method name:

| Field Name  | Type             | Description |
| ----------- | ---------------- | ----------- |
| href        | string (URI)     | Alternative URL for accessing the asset |
| title       | string           | Title for the alternative access method |
| description | string           | Description of how to use this access method |
| type        | string           | Media type of the alternative asset |
| auth        | Auth Config      | Authentication configuration for this alternative |

#### Auth Config Object

Used in alternate access methods:

| Field Name | Type       | Description |
| ---------- | ---------- | ----------- |
| refs       | \[string\] | References to authentication schemes |
| roles      | \[string\] | Roles required for this access method |
| schemes    | object     | Inline authentication scheme definition |

#### liability:security_classification

Security classification levels for assets:

- `public`: Publicly accessible information
- `internal`: Internal use only, not for external distribution
- `confidential`: Confidential information requiring authorized access
- `restricted`: Highly restricted access (e.g., attorney-client privilege)
- `classified`: Classified information requiring security clearance

## Examples

### Example 1: Environmental Liability Claim

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
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
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
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

### Example 3: Secure Asset with Authentication

This example demonstrates the use of asset-level security and authentication fields:

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json",
    "https://stac-extensions.github.io/file/v2.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "environmental-incident-2024-secure",
  "properties": {
    "datetime": "2024-11-15T10:30:00Z",
    "liability:claim_id": "ENV-2024-SECURE-001",
    "liability:claim_type": "environmental",
    "liability:claim_status": "under_investigation",
    "liability:security_classification": "confidential",
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
        "authorized_investigators_only"
      ],
      "liability:access_control": {
        "required_auth": true,
        "auth_methods": ["apiKey"],
        "auth_schemes": {
          "apiKey": {
            "type": "apiKey",
            "description": "API Key authentication for authorized investigators",
            "in": "header",
            "name": "X-Claims-API-Key"
          }
        }
      },
      "liability:alternate": {
        "API_Key_Access": {
          "href": "https://assets.claims.example.com/api/v1/evidence/sat-2024-11-15.tif",
          "title": "Download Asset via API Key",
          "description": "Download evidence using X-Claims-API-Key header. Obtain key from https://claims.example.com/auth/api-key",
          "type": "image/tiff; application=geotiff",
          "auth": {
            "refs": ["apiKey"],
            "roles": ["investigator", "legal_counsel"],
            "schemes": {
              "description": "X-Claims-API-Key authenticates authorized personnel",
              "type": "apiKey",
              "in": "header",
              "name": "X-Claims-API-Key",
              "required": true
            }
          }
        }
      }
    }
  }
}
```

### Example 4: Data Quality Reporting (ISO 19115-4 and DGIWG)

This example demonstrates quality reporting for satellite imagery and defence geospatial data:

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
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

## License

This extension is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
