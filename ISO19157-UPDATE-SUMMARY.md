# ISO 19157-1:2023 Integration Summary

## Overview

The STAC Liability and Claims Extension has been updated to support **ISO 19157-1:2023 Geographic information - Data quality** as the primary data quality framework, while maintaining **100% backward compatibility** with ISO 19115/19115-4 and **full identity and provenance compatibility** with W3C PROV.

## What Changed

### New Primary Standard: ISO 19157-1:2023

The extension now recommends **ISO 19157-1:2023** as the primary data quality framework, replacing ISO 19115/19115-4. This provides:

1. **Standardized Quality Measures**: Official ISO 19157 measure catalog with unique identifiers (e.g., Measure 28 = "Mean value of positional uncertainties")
2. **Metaquality Support**: Quality of quality information (confidence, representativity, homogeneity)
3. **Usability Assessment**: Formalized fitness-for-purpose evaluation
4. **Structured Evaluation Methods**: Three standardized method types (directInternal, directExternal, indirect)
5. **Multiple Result Types**: Quantitative, conformance, descriptive, and coverage results

### Files Updated

| File | Change Description |
|------|-------------------|
| `json-schema/iso19157-quality.json` | **NEW** - Complete ISO 19157-1:2023 JSON Schema |
| `json-schema/schema.json` | Updated to support both ISO 19157 and ISO 19115 (backward compatible) |
| `examples/item-with-iso19157-quality.json` | **NEW** - Comprehensive ISO 19157 example with provenance |
| `ISO19157-INTEGRATION.md` | **NEW** - Complete migration and integration guide |
| `README.md` | Updated with ISO 19157 documentation |
| `CHANGELOG.md` | Documented ISO 19157 integration |

### Schema Changes

The `liability:quality` field now accepts **both** formats:

```json
{
  "liability:quality": {
    // OPTION 1: ISO 19157-1:2023 (RECOMMENDED)
    "scope": {"level": "dataset"},
    "report": [ /* ISO 19157 quality elements */ ],
    "lineage": { /* ISO 19115 lineage */ }
  }
}
```

```json
{
  "liability:quality": {
    // OPTION 2: ISO 19115/19115-4 (BACKWARD COMPATIBLE)
    "reportId": "...",
    "scope": "dataset",
    "elements": [ /* ISO 19115 quality elements */ ]
  }
}
```

## Key Features

### 1. Metaquality (NEW)

ISO 19157 introduces metaquality - quality of quality information:

```json
{
  "category": "metaquality",
  "subcategory": "confidence",
  "measure": {
    "measureIdentification": {
      "code": "129",
      "codeSpace": "ISO 19157",
      "version": "2023"
    }
  },
  "result": [{
    "resultType": "quantitative",
    "value": [0.95],
    "valueUnit": "probability"
  }]
}
```

**Use Case**: Document confidence in quality assessments for liability-sensitive applications.

### 2. Usability Assessment (Enhanced)

Formalized fitness-for-purpose evaluation:

```json
{
  "category": "usability",
  "usabilityDescription": "Dataset suitable for agricultural monitoring at 10m resolution",
  "result": [{
    "resultType": "descriptive",
    "statement": "Meets all requirements for crop classification"
  }]
}
```

**Use Case**: Explicitly document whether data is fit for specific applications.

### 3. Standardized Measures

Official ISO 19157 measure codes:

```json
{
  "measure": {
    "measureIdentification": {
      "code": "28",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Mean value of positional uncertainties"]
  }
}
```

**Benefit**: Consistent quality reporting across organizations using official ISO register.

### 4. Structured Evaluation Methods

Three standardized evaluation types:

- **directInternal**: Internal dataset analysis (e.g., automated topology validation)
- **directExternal**: Comparison with external reference (e.g., ground control points)
- **indirect**: Inference from related information (e.g., quality estimation from metadata)

```json
{
  "evaluationMethod": {
    "evaluationMethodType": "directExternal",
    "evaluationMethodDescription": "Ground control point validation",
    "dateTime": "2025-06-16T14:00:00Z",
    "referenceDoc": [{
      "title": "Quality Assessment Procedure v2.1",
      "uri": "https://example.org/procedures/qap-2.1.pdf"
    }]
  }
}
```

**Benefit**: Standardized documentation of how quality was assessed.

## Provenance Compatibility

### Identity Preservation

Both ISO 19157 and ISO 19115 quality reports maintain **full identity preservation** with W3C PROV:

```json
{
  "liability:quality": {
    // ISO 19157 quality report
  },
  "liability:prov": {
    "entity": {
      "quality-report-2025": {
        "prov:id": "quality-report-2025",
        "prov:type": "QualityReport",
        "prov:wasGeneratedBy": "quality-assessment",
        "prov:wasAttributedTo": "quality-team"
      }
    },
    "activity": {
      "quality-assessment": {
        "prov:id": "quality-assessment",
        "prov:type": "QualityAssessment",
        "prov:used": "source-dataset"
      }
    }
  }
}
```

### Lineage and PROV Alignment

ISO 19157 lineage aligns directly with W3C PROV:

| ISO 19157 Lineage | W3C PROV |
|-------------------|----------|
| `processStep` | `prov:Activity` |
| `processStep.processor` | `prov:Agent` |
| `processStep.stepDateTime` | `prov:startTime` / `prov:endTime` |
| `source` | `prov:Entity` (used) |

**Result**: Organizations can maintain **dual representations** or **generate one from the other**.

## Migration Path

### Phase 1: No Action Required (Backward Compatible)

Existing ISO 19115/19115-4 quality reports continue to work:

```json
{
  "liability:quality": {
    // Existing ISO 19115 format - still valid!
    "elements": [...]
  }
}
```

### Phase 2: Gradual Adoption (Recommended)

Start using ISO 19157 for new quality reports:

```json
{
  "liability:quality": {
    "scope": {"level": "dataset"},
    "report": [
      {
        "category": "positionalAccuracy",
        "measure": {
          "measureIdentification": {"code": "28", "codeSpace": "ISO 19157"}
        }
      }
    ]
  }
}
```

### Phase 3: Full Migration (Optional)

Convert existing ISO 19115 reports to ISO 19157 format for enhanced capabilities:

See [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) for detailed migration examples.

## Benefits Summary

| Feature | ISO 19115 | ISO 19157-1:2023 |
|---------|-----------|------------------|
| Core quality elements | ✓ | ✓ |
| Lineage documentation | ✓ | ✓ (enhanced) |
| Standardized measures | ✗ | ✓ |
| Metaquality | ✗ | ✓ |
| Usability assessment | Limited | ✓ (formalized) |
| Evaluation method structure | Informal | ✓ (standardized) |
| Multiple result types | Limited | ✓ (4 types) |
| W3C PROV compatibility | ✓ | ✓ |

## Examples

### Basic Positional Accuracy (ISO 19157)

```json
{
  "liability:quality": {
    "scope": {"level": "dataset"},
    "report": [{
      "category": "positionalAccuracy",
      "subcategory": "absoluteExternalPositionalAccuracy",
      "measure": {
        "measureIdentification": {
          "code": "28",
          "codeSpace": "ISO 19157",
          "version": "2023"
        },
        "nameOfMeasure": ["Mean value of positional uncertainties"]
      },
      "evaluationMethod": {
        "evaluationMethodType": "directExternal",
        "evaluationMethodDescription": "RMSE with ground control points",
        "dateTime": "2025-06-16T14:00:00Z"
      },
      "result": [{
        "resultType": "quantitative",
        "value": [12.3],
        "valueUnit": "meter",
        "errorStatistic": "RMSE"
      }]
    }]
  }
}
```

### Metaquality with Provenance

```json
{
  "liability:quality": {
    "report": [{
      "category": "metaquality",
      "subcategory": "confidence",
      "result": [{
        "resultType": "quantitative",
        "value": [0.95],
        "valueUnit": "probability"
      }]
    }]
  },
  "liability:prov": {
    "entity": {
      "quality-report": {
        "prov:wasGeneratedBy": "quality-assessment",
        "prov:wasAttributedTo": "quality-team"
      }
    }
  }
}
```

## Documentation

- **Complete Guide**: [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md)
- **JSON Schema**: [json-schema/iso19157-quality.json](json-schema/iso19157-quality.json)
- **Full Example**: [examples/item-with-iso19157-quality.json](examples/item-with-iso19157-quality.json)
- **README**: Updated with ISO 19157 documentation

## Standards References

- **ISO 19157-1:2023**: Geographic information - Data quality - Part 1: General requirements
- **ISO 19157-3 Data Quality Measures Register**: https://def.isotc211.org/dataqualitymeasures/ (permanent URI, expected publication April 2026)
- **ISO 19115-1:2014**: Geographic information - Metadata (backward compatibility)
- **W3C PROV**: Provenance Data Model - https://www.w3.org/TR/prov-dm/

## Validation

The extension validates both formats:

```bash
# Validate ISO 19157 example
python validate.py examples/item-with-iso19157-quality.json
# Result: PASS

# Validate existing ISO 19115 examples (still work!)
python validate.py examples/item-with-quality.json
# Result: PASS
```

## Support

- **Email**: luciocol@gmail.com
- **GitHub Issues**: https://github.com/stac-extensions/liability-claims/issues
- **OGC Building Blocks**: https://github.com/opengeospatial/bblocks

---

**Status**: ✅ Ready for use  
**Backward Compatibility**: ✅ 100% maintained  
**Provenance Compatibility**: ✅ Full W3C PROV integration  
**Date**: 2025-12-21
