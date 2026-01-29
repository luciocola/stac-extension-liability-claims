# Cloud Coverage and Conformance Statement Guide

## Overview

The STAC Liability and Claims Extension provides comprehensive support for **cloud coverage assessment** and **conformance statements** through its ISO 19115-4 imagery quality framework. These features are essential for satellite imagery and aerial photography quality reporting.

## Features Available

### 1. Cloud Coverage (`cloudCoverage`)

ISO 19115-4 imagery quality element for documenting cloud coverage in satellite/aerial imagery.

**Schema Definition:**
```json
{
  "type": "cloudCoverage",
  "coveragePercentage": 0-100,
  "assessmentMethod": "string",
  "measure": {
    "description": "string",
    "value": number,
    "valueType": "string",
    "units": "string"
  }
}
```

**Fields:**
- `coveragePercentage` (required): Percentage of scene covered by clouds (0-100)
- `assessmentMethod` (optional): Method used to detect clouds (e.g., "Automated scene classification", "Visual inspection", "Machine learning classifier")
- `measure` (optional): Detailed measurement information following ISO 19115 structure

### 2. Conformance Result (`conformance`)

ISO 19115 conformance result for quality elements, indicating pass/fail against specifications.

**Schema Definition:**
```json
{
  "specification": "string (required)",
  "pass": boolean (required),
  "explanation": "string (optional)"
}
```

**Fields:**
- `specification` (required): Name or identifier of the specification (e.g., "ISO 19115-4:2015", "Sentinel-2 Level-2A Product Specification")
- `pass` (required): Boolean indicating whether the data conforms to the specification
- `explanation` (optional): Additional details about conformance or non-conformance

## Usage Examples

### Example 1: Basic Cloud Coverage

```json
{
  "type": "Feature",
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "id": "satellite-image-001",
  "properties": {
    "datetime": "2025-11-27T10:30:00Z",
    "liability:quality": {
      "reportId": "QR-2025-001",
      "scope": "feature",
      "elements": [
        {
          "elementType": "cloudCoverage",
          "summary": "Low cloud coverage - suitable for analysis",
          "detail": {
            "type": "cloudCoverage",
            "coveragePercentage": 8.5,
            "assessmentMethod": "Sen2Cor Scene Classification"
          }
        }
      ]
    }
  },
  "geometry": { "type": "Point", "coordinates": [12.5, 45.5] },
  "bbox": [12.0, 45.0, 13.0, 46.0],
  "assets": {}
}
```

### Example 2: Cloud Coverage with Conformance Statement

```json
{
  "elementType": "cloudCoverage",
  "summary": "Cloud coverage assessment with quality conformance",
  "detail": {
    "type": "cloudCoverage",
    "coveragePercentage": 12.5,
    "assessmentMethod": "Automated scene classification (Fmask algorithm)",
    "measure": {
      "description": "Percentage of scene covered by clouds",
      "value": 12.5,
      "valueType": "percentage",
      "units": "%",
      "method": "Fmask 4.6 cloud detection algorithm",
      "reference": "https://doi.org/10.1016/j.rse.2015.01.005"
    }
  },
  "conformance": {
    "specification": "Landsat Collection 2 Level-2 Product Specification v3.0",
    "pass": true,
    "explanation": "Cloud coverage within acceptable range (<15%) for quality Level-2 product"
  }
}
```

### Example 3: Multiple Imagery Quality Elements

```json
{
  "liability:quality": {
    "reportId": "QR-SAT-2025-001",
    "scope": "dataset",
    "date": "2025-11-27T14:00:00Z",
    "version": "1.0",
    "summary": "Comprehensive imagery quality assessment",
    "elements": [
      {
        "elementType": "cloudCoverage",
        "summary": "Minimal cloud interference",
        "detail": {
          "type": "cloudCoverage",
          "coveragePercentage": 5.2,
          "assessmentMethod": "Sentinel-2 Scene Classification (SCL)"
        },
        "conformance": {
          "specification": "Copernicus Sentinel-2 MSI Level-2A Product Specification",
          "pass": true,
          "explanation": "Excellent quality - cloud coverage well below 10% threshold"
        }
      },
      {
        "elementType": "snowCoverage",
        "summary": "Snow coverage in mountain regions",
        "detail": {
          "type": "snowCoverage",
          "coveragePercentage": 18.3,
          "assessmentMethod": "NDSI-based snow detection (NDSI > 0.4)",
          "measure": {
            "description": "Percentage of scene covered by snow and ice",
            "value": 18.3,
            "units": "%"
          }
        }
      },
      {
        "elementType": "processingLevel",
        "summary": "Surface reflectance product",
        "detail": {
          "type": "processingLevel",
          "level": "L2A",
          "description": "Bottom-of-atmosphere reflectance with atmospheric correction",
          "processingDate": "2025-11-27T08:00:00Z",
          "processor": "Sen2Cor v2.10"
        },
        "conformance": {
          "specification": "ESA Sentinel-2 MSI Level-2A Algorithm Theoretical Basis Document",
          "pass": true
        }
      },
      {
        "elementType": "radiometricAccuracy",
        "summary": "Radiometric calibration quality",
        "detail": {
          "type": "radiometricAccuracy",
          "calibrationAccuracy": 3.5,
          "units": "%",
          "method": "On-board calibration with ground-based vicarious validation"
        },
        "conformance": {
          "specification": "ISO 19115-4:2015 Radiometric Calibration Requirements",
          "pass": true,
          "explanation": "Uncertainty <5% meets specification for quantitative analysis"
        }
      },
      {
        "elementType": "positionalAccuracy",
        "summary": "Geometric accuracy",
        "detail": {
          "type": "positionalAccuracy",
          "accuracyValue": 7.2,
          "units": "m",
          "method": "Ground control point validation (n=150)"
        },
        "conformance": {
          "specification": "Sentinel-2 Multi-Spectral Instrument Geometric Accuracy Specification",
          "pass": true,
          "explanation": "RMSE <10m horizontal accuracy requirement satisfied"
        }
      }
    ]
  }
}
```

### Example 4: Failed Conformance (Non-compliant Data)

```json
{
  "elementType": "cloudCoverage",
  "summary": "High cloud coverage - quality issue",
  "detail": {
    "type": "cloudCoverage",
    "coveragePercentage": 67.8,
    "assessmentMethod": "Manual visual inspection"
  },
  "conformance": {
    "specification": "Environmental Monitoring Protocol - Cloud Coverage Requirement",
    "pass": false,
    "explanation": "Cloud coverage exceeds 50% threshold - unsuitable for vegetation analysis"
  }
}
```

## Integration with COP Extension

When using both `stac-extension-cop` and `stac-extension-liability-claims` together:

```json
{
  "type": "Feature",
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/cop/v1.0.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "id": "cop-imagery-001",
  "properties": {
    "datetime": "2025-11-27T10:30:00Z",
    
    "cop:mission": "Flood Response Operation 2025",
    "cop:classification": "internal",
    "cop:platform": "Sentinel-2A",
    "cop:sensor": "MSI",
    
    "liability:quality": {
      "reportId": "QR-COP-2025-001",
      "scope": "feature",
      "elements": [
        {
          "elementType": "cloudCoverage",
          "detail": {
            "type": "cloudCoverage",
            "coveragePercentage": 8.5,
            "assessmentMethod": "Automated"
          },
          "conformance": {
            "specification": "COP Imagery Quality Requirements v2.0",
            "pass": true
          }
        }
      ]
    }
  },
  "geometry": { "type": "Point", "coordinates": [12.5, 45.5] },
  "bbox": [12.0, 45.0, 13.0, 46.0],
  "assets": {}
}
```

## Supported Quality Elements with Conformance

All ISO 19115-4 and DGIWG quality elements support conformance statements:

| Element Type | Use Conformance For |
|-------------|-------------------|
| `cloudCoverage` | Cloud coverage thresholds |
| `snowCoverage` | Snow/ice coverage limits |
| `radiometricAccuracy` | Calibration requirements |
| `sensorQuality` | Sensor performance specs |
| `processingLevel` | Processing algorithm conformance |
| `positionalAccuracy` | Geometric accuracy requirements |
| `usabilityAssessment` | Fitness-for-purpose criteria |
| All other elements | Relevant standards/specifications |

## Best Practices

1. **Always specify cloud coverage** for satellite/aerial imagery
2. **Use conformance statements** to indicate compliance with:
   - Product specifications
   - Mission requirements
   - Quality standards (ISO, DGIWG, etc.)
   - Operational thresholds
3. **Include assessment method** to document how cloud coverage was determined
4. **Provide explanations** for failed conformance to help users understand limitations
5. **Reference specific versions** of specifications (e.g., "ISO 19115-4:2015" not just "ISO 19115")
6. **Use measure object** for detailed metric documentation

## Schema Compatibility

✅ **YES** - The schemas are identical to ISO 19115-4:

- `cloudCoverage` follows ISO 19115-4:2015 Section 8.3.3.4 (MD_CloudCoverageElementPropertyType)
- `conformance` follows ISO 19115-1:2014 Section 7.11.5 (DQ_ConformanceResult)
- `measure` follows ISO 19115-1:2014 Section 7.11.2 (DQ_QuantitativeResult)

The JSON Schema definitions are direct mappings of the ISO XML schemas to JSON, maintaining full compatibility with ISO 19115-4 data quality reporting requirements.

## References

- **ISO 19115-4:2015** - Geographic information — Metadata — Part 4: Imagery and gridded data
- **ISO 19115-1:2014** - Geographic information — Metadata — Part 1: Fundamentals
- **Liability Claims Extension**: https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json
- **Full Schema**: [json-schema/iso19115-quality.json](json-schema/iso19115-quality.json)
- **Example**: [examples/item-with-imagery-quality.json](examples/item-with-imagery-quality.json)
