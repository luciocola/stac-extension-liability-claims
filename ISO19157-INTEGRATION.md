# ISO 19157-1:2023 Integration Guide

## Overview

The STAC Liability and Claims Extension has been updated to support **ISO 19157-1:2023 Geographic information - Data quality** as the primary data quality framework, while maintaining backward compatibility with ISO 19115/19115-4.

## Key Improvements in ISO 19157-1:2023

### New Data Quality Categories

ISO 19157-1:2023 introduces several advanced quality categories beyond ISO 19115:

1. **Metaquality** (`metaquality`): Quality of quality information
   - Confidence: Trustworthiness of data quality results
   - Representativity: Degree to which sample data represents the population
   - Homogeneity: Expected similarity of quality characteristics

2. **Usability** (`usability`): Fitness for purpose assessment
   - Evaluates whether dataset meets specific user requirements
   - Supports multiple use case evaluations

3. **Temporal Quality** (`temporalQuality`): Enhanced temporal accuracy
   - Accuracy of time measurement
   - Temporal consistency
   - Temporal validity

### Standardized Quality Measures

ISO 19157 provides a catalog of **standardized data quality measures** with unique identifiers:

- Each measure has a numeric code (e.g., Measure 28 = "Mean value of positional uncertainties")
- Measures defined in ISO 19157-3:2026 Data Quality Measures Register (expected April 2026)
- Official register URI: https://def.isotc211.org/dataqualitymeasures/ (permanent)
- Development register: https://defs-hosted.opengis.net/prez-hosted/catalogs/hosted:iso-19157-3
- Enables consistent quality reporting across organizations

### Structured Evaluation Methods

ISO 19157 formalizes three evaluation method types:

| Method Type | Description | Example |
|------------|-------------|---------|
| `directInternal` | Internal dataset analysis | Automated topology validation |
| `directExternal` | Comparison with external reference | Ground control point validation |
| `indirect` | Inference from related information | Quality estimation from metadata |

### Multiple Result Types

ISO 19157 supports four distinct result types:

1. **Quantitative Result** (`quantitative_result`): Numeric measurements
2. **Conformance Result** (`conformance_result`): Pass/fail against specifications
3. **Descriptive Result** (`descriptive_result`): Textual descriptions
4. **Coverage Result** (`coverage_result`): Spatial quality variation maps

## Migration from ISO 19115 to ISO 19157

### Backward Compatibility

The extension maintains **full backward compatibility** with existing ISO 19115/19115-4 quality reports. Both formats are supported in the `liability:quality` field:

```json
{
  "liability:quality": {
    // ISO 19157-1:2023 format (RECOMMENDED)
    "scope": {"level": "dataset"},
    "report": [ /* ISO 19157 quality elements */ ],
    "lineage": { /* ISO 19115 lineage */ }
  }
}
```

or

```json
{
  "liability:quality": {
    // ISO 19115/19115-4 format (backward compatibility)
    "reportId": "...",
    "scope": "dataset",
    "elements": [ /* ISO 19115 quality elements */ ]
  }
}
```

### Mapping ISO 19115 to ISO 19157

| ISO 19115 Element | ISO 19157 Category | Notes |
|-------------------|-------------------|-------|
| `completeness` | `completeness` | Direct mapping, enhanced with subcategories |
| `logicalConsistency` | `logicalConsistency` | Enhanced with 4 subcategories |
| `positionalAccuracy` | `positionalAccuracy` | Enhanced with gridded data accuracy |
| `thematicAccuracy` | `thematicQuality` | Renamed, expanded subcategories |
| `temporalAccuracy` | `temporalQuality` | Enhanced with consistency checks |
| `lineage` | `lineage` (in DQ_DataQuality) | Maintained from ISO 19115 |
| *(no equivalent)* | `metaquality` | **NEW** in ISO 19157 |
| `usabilityAssessment` (19115-4) | `usability` | Formalized in ISO 19157 |

### Example Migration

**Before (ISO 19115):**
```json
{
  "liability:quality": {
    "reportId": "QUAL-001",
    "scope": "dataset",
    "elements": [
      {
        "elementType": "positionalAccuracy",
        "detail": {
          "type": "positionalAccuracy",
          "accuracyValue": 12.3,
          "units": "meters",
          "method": "RMSE with ground control points"
        }
      }
    ]
  }
}
```

**After (ISO 19157-1:2023):**
```json
{
  "liability:quality": {
    "scope": {"level": "dataset"},
    "report": [
      {
        "category": "positionalAccuracy",
        "subcategory": "absoluteExternalPositionalAccuracy",
        "measure": {
          "measureIdentification": {
            "code": "28",
            "codeSpace": "ISO 19157",
            "version": "2023"
          },
          "nameOfMeasure": ["Mean value of positional uncertainties"],
          "measureDescription": "Mean of positional uncertainties where positional uncertainties are defined as the distance between measured and true position"
        },
        "evaluationMethod": {
          "evaluationMethodType": "directExternal",
          "evaluationMethodDescription": "RMSE calculation using ground control points",
          "dateTime": "2025-06-16T14:00:00Z"
        },
        "result": [
          {
            "resultType": "quantitative",
            "value": [12.3],
            "valueUnit": "meter",
            "valueRecordType": "Real",
            "errorStatistic": "RMSE"
          }
        ]
      }
    ]
  }
}
```

## Provenance Integration

### Identity Preservation

Both ISO 19115 and ISO 19157 quality reports maintain **full identity preservation** with W3C PROV:

- Quality reports can be tracked as PROV entities
- Quality assessment processes become PROV activities
- Quality assessors/organizations are PROV agents

### Example with Provenance

```json
{
  "liability:quality": {
    "scope": {"level": "dataset"},
    "report": [ /* ISO 19157 quality elements */ ]
  },
  "liability:prov": {
    "entity": {
      "quality-report-20250620": {
        "prov:id": "quality-report-20250620",
        "prov:type": "QualityReport",
        "prov:wasGeneratedBy": "quality-assessment-activity",
        "prov:wasAttributedTo": "quality-team",
        "prov:generatedAtTime": "2025-06-20T16:00:00Z"
      }
    },
    "activity": {
      "quality-assessment-activity": {
        "prov:id": "quality-assessment-activity",
        "prov:type": "QualityAssessment",
        "prov:used": "source-dataset",
        "prov:wasAssociatedWith": "quality-team"
      }
    },
    "agent": {
      "quality-team": {
        "prov:id": "quality-team",
        "prov:type": "prov:Organization",
        "prov:label": "Quality Assurance Team"
      }
    }
  }
}
```

### Lineage and PROV Alignment

ISO 19157 lineage (inherited from ISO 19115) aligns naturally with W3C PROV:

| ISO 19115/19157 Lineage | W3C PROV |
|------------------------|----------|
| `processStep` | `prov:Activity` |
| `processStep.processor` | `prov:Agent` |
| `processStep.stepDateTime` | `prov:startTime` / `prov:endTime` |
| `source` | `prov:Entity` (used) |
| `source.sourceCitation` | `prov:Entity` metadata |

Organizations can maintain **dual representations** (lineage + PROV) or **generate one from the other** using this mapping.

## Best Practices

### 1. Use Standardized Measures

Prefer ISO 19157 registered measures with official codes:

```json
{
  "measure": {
    "measureIdentification": {
      "code": "28",
      "codeSpace": "ISO 19157",
      "version": "2023"
    }
  }
}
```

Reference: ISO 19157-3 Data Quality Measures Register - https://def.isotc211.org/dataqualitymeasures/ (permanent URI, expected April 2026)

### 2. Document Evaluation Methods

Always specify evaluation method type and timing:

```json
{
  "evaluationMethod": {
    "evaluationMethodType": "directExternal",
    "evaluationMethodDescription": "Clear description of method",
    "dateTime": "2025-06-16T14:00:00Z",
    "referenceDoc": [
      {
        "title": "Quality Assessment Procedure v2.1",
        "identifier": "QAP-2.1",
        "uri": "https://example.org/procedures/qap-2.1.pdf"
      }
    ]
  }
}
```

### 3. Include Metaquality for Critical Applications

For liability-sensitive applications, document confidence in quality assessments:

```json
{
  "category": "metaquality",
  "subcategory": "confidence",
  "measure": {
    "measureIdentification": {"code": "129", "codeSpace": "ISO 19157"}
  },
  "result": [
    {
      "resultType": "quantitative",
      "value": [0.95],
      "valueUnit": "probability"
    }
  ]
}
```

### 4. Assess Usability for Specific Applications

Document fitness for purpose:

```json
{
  "category": "usability",
  "usabilityDescription": "Dataset suitable for agricultural monitoring at 10m resolution",
  "result": [
    {
      "resultType": "descriptive",
      "statement": "Meets all requirements for crop classification applications"
    }
  ]
}
```

### 5. Maintain Provenance Alignment

Ensure quality assessment activities are documented in PROV:

```json
{
  "liability:quality": { /* ISO 19157 quality */ },
  "liability:prov": {
    "activity": {
      "quality-assessment": {
        "prov:type": "QualityAssessment",
        "prov:used": "dataset-id",
        "prov:wasAssociatedWith": "quality-team"
      }
    }
  }
}
```

## Implementation Examples

See the following example files:

1. **Basic ISO 19157**: `examples/item-with-iso19157-quality.json`
   - Demonstrates comprehensive ISO 19157 quality report
   - Shows all major quality categories
   - Includes metaquality and usability assessment
   - Full provenance integration

2. **Migration Example**: Compare existing ISO 19115 examples with new ISO 19157 format

3. **Provenance Focus**: Shows identity preservation across quality frameworks

## Validation

### JSON Schema Validation

The extension validates both ISO 19157 and ISO 19115 formats:

```bash
# Validate using Python jsonschema
python validate.py examples/item-with-iso19157-quality.json

# Expected: PASS - Valid ISO 19157-1:2023 quality report with provenance
```

### SHACL Validation (for PROV)

PROV provenance graphs are validated using SHACL:

```bash
pyshacl -s shacl/liability-claims-shapes.ttl \
        -df json-ld \
        examples/item-with-iso19157-quality.json
```

## Standards References

- **ISO 19157-1:2023**: Geographic information - Data quality - Part 1: General requirements (published)
- **ISO 19157-3:2026**: Geographic information - Data quality - Part 3: Data quality measures register (expected April 2026, final draft stage)
- **ISO 19115-1:2014**: Geographic information - Metadata - Part 1: Fundamentals
- **ISO 19115-4**: Geographic information - Metadata - Part 4: Imagery and gridded data (backward compatibility)
- **W3C PROV**: PROV Data Model (https://www.w3.org/TR/prov-dm/)

### Data Quality Measures Register

- **Permanent URI**: https://def.isotc211.org/dataqualitymeasures/ (will resolve after ISO 19157-3 publication in April 2026)
- **Development Register**: https://defs-hosted.opengis.net/prez-hosted/catalogs/hosted:iso-19157-3 (currently active)

## Support

For questions about ISO 19157 integration:
- Email: luciocol@gmail.com
- GitHub Issues: https://github.com/stac-extensions/liability-claims/issues
- OGC Building Blocks: https://github.com/opengeospatial/bblocks
