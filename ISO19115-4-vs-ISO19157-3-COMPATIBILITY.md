# ISO 19115-4 vs ISO 19157-3 Quality Measures Compatibility Table

## Overview

This document provides a comprehensive comparison between **ISO 19115-4** (Geographic information - Metadata - Part 4: Imagery and gridded data) quality measures and **ISO 19157-3** (Geographic information - Data quality - Part 3: Data quality measures register) quality measures.

### Standards Summary

| Standard | Full Title | Primary Focus | Publication Status |
|----------|-----------|---------------|-------------------|
| **ISO 19115-4** | Geographic information - Metadata - Part 4: Imagery and gridded data | Imagery-specific metadata quality elements | Published |
| **ISO 19157-3** | Geographic information - Data quality - Part 3: Data quality measures register | Standardized quality measures with unique identifiers | Expected April 2026 (final draft) |

### Key Differences

| Aspect | ISO 19115-4 | ISO 19157-3 |
|--------|-------------|-------------|
| **Scope** | Imagery and gridded data specific quality elements | Generic quality measures applicable to all geospatial data |
| **Measure Registry** | No standardized measure codes | Official registry with unique numeric codes (e.g., Measure 28) |
| **Quality Categories** | 6 imagery-specific categories + core 19115 elements | 9 comprehensive categories including metaquality |
| **Evaluation Methods** | Informal descriptions | Formalized: directInternal, directExternal, indirect |
| **Result Types** | Simple value/conformance | 4 types: quantitative, conformance, descriptive, coverage |
| **Interoperability** | Metadata-focused | Measure-focused with semantic web support |

---

## Quality Category Mapping

### Core Quality Elements (Inherited from ISO 19115)

| ISO 19115-4 Element | ISO 19157-3 Category | Compatibility | Notes |
|---------------------|---------------------|---------------|-------|
| `completeness` | `completeness` | ✓ **Direct** | ISO 19157-3 adds subcategories (commission, omission) |
| `logicalConsistency` | `logicalConsistency` | ✓ **Direct** | ISO 19157-3 adds 4 subcategories (conceptual, domain, format, topological) |
| `positionalAccuracy` | `positionalAccuracy` | ✓ **Direct** | ISO 19157-3 enhances with gridded data accuracy measures |
| `thematicAccuracy` | `thematicQuality` | ✓ **Renamed** | ISO 19157-3 renamed and expanded subcategories |
| `temporalAccuracy` | `temporalQuality` | ✓ **Renamed** | ISO 19157-3 adds temporal consistency and validity |
| `attributeAccuracy` | Merged into `thematicQuality` | ✓ **Merged** | Now subcategory of thematic quality |
| `topologicalConsistency` | Subcategory of `logicalConsistency` | ✓ **Subcategory** | Part of logical consistency in ISO 19157 |
| `lineage` | `lineage` (in DQ_DataQuality) | ✓ **Direct** | Preserved from ISO 19115 |

### ISO 19115-4 Imagery-Specific Quality Elements

| ISO 19115-4 Element | ISO 19157-3 Equivalent | Compatibility | Migration Path |
|---------------------|----------------------|---------------|----------------|
| `radiometricAccuracy` | `thematicQuality.thematicClassificationCorrectness` | ⚠ **Partial** | Map to thematic quality with measure-specific description; consider using ISO 19157-3 Measure 60-63 (quantitative attribute accuracy) |
| `sensorQuality` | `metaquality.confidence` + custom measures | ⚠ **Partial** | Map sensor calibration status to metaquality confidence; use custom measure descriptions |
| `cloudCoverage` | Custom `descriptiveResult` or `usability` | ⚠ **Indirect** | Report as usability limitation or descriptive result; no direct ISO 19157-3 measure |
| `snowCoverage` | Custom `descriptiveResult` or `usability` | ⚠ **Indirect** | Report as usability limitation or descriptive result; no direct ISO 19157-3 measure |
| `processingLevel` | `lineage.processStep` | ✓ **Direct** | Document as lineage process step with processing level metadata |
| `usabilityAssessment` | `usability` | ✓ **Direct** | ISO 19157-3 formalizes usability as core category |

### ISO 19157-3 New Quality Categories

| ISO 19157-3 Category | ISO 19115-4 Equivalent | Description | Use for Imagery |
|---------------------|----------------------|-------------|-----------------|
| `metaquality` | ❌ **No equivalent** | Quality of quality information (confidence, representativity, homogeneity) | **High value**: Report confidence in radiometric calibration, sensor quality assessment reliability |
| `usability` | `usabilityAssessment` (19115-4) | Fitness for purpose assessment | **Direct**: Enhanced from 19115-4 with formal structure |

---

## Detailed Quality Measure Mappings

### 1. Completeness

| ISO 19115-4 Approach | ISO 19157-3 Measures | Example Migration |
|---------------------|---------------------|-------------------|
| Generic completeness value/description | **Measure 3**: Rate of missing items<br>**Measure 4**: Rate of excess items<br>**Measure 6**: Number of missing items | Use Measure 3 for omission errors, Measure 4 for commission errors |

**Example:**
```json
// ISO 19115-4
{
  "type": "completeness",
  "measure": {
    "description": "Percentage of features captured",
    "value": 98.5,
    "units": "percent"
  }
}

// ISO 19157-3 Equivalent
{
  "category": "completeness",
  "subcategory": "omission",
  "measure": {
    "measureIdentification": {
      "code": "3",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Rate of missing items"],
    "measureDescription": "Number of missing items in relation to the number of items that should have been present"
  },
  "result": [{
    "resultType": "quantitative",
    "value": [1.5],
    "valueUnit": "percent",
    "errorStatistic": "percentage"
  }]
}
```

### 2. Positional Accuracy

| ISO 19115-4 Approach | ISO 19157-3 Measures | Example Migration |
|---------------------|---------------------|-------------------|
| Simple RMSE value with method description | **Measure 28**: Mean value of positional uncertainties<br>**Measure 47**: Root mean square error (RMSE)<br>**Measure 48**: Circular error probable (CEP)<br>**Measure 50**: Linear error probable (LEP) | Use Measure 28 or 47 depending on statistical method |

**Example:**
```json
// ISO 19115-4
{
  "type": "positionalAccuracy",
  "accuracyValue": 12.3,
  "units": "meters",
  "method": "RMSE with ground control points"
}

// ISO 19157-3 Equivalent
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
  "result": [{
    "resultType": "quantitative",
    "value": [12.3],
    "valueUnit": "meter",
    "valueRecordType": "Real",
    "errorStatistic": "RMSE"
  }]
}
```

### 3. Radiometric Accuracy (Imagery-Specific)

| ISO 19115-4 Approach | ISO 19157-3 Measures | Migration Strategy |
|---------------------|---------------------|-------------------|
| Radiometric calibration accuracy | **Measure 60-63**: Quantitative attribute accuracy measures<br>**Measure 117**: Value domain non-conformance rate | Map calibration accuracy to quantitative attribute accuracy; use custom measure for sensor-specific calibration |

**Example:**
```json
// ISO 19115-4
{
  "type": "radiometricAccuracy",
  "description": "Radiometric calibration accuracy for multispectral bands",
  "calibrationAccuracy": 5.0,
  "units": "percent",
  "method": "Pre-flight calibration with certified reference targets"
}

// ISO 19157-3 Equivalent
{
  "category": "thematicQuality",
  "subcategory": "quantitativeAttributeAccuracy",
  "measure": {
    "measureIdentification": {
      "code": "60",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Value domain conformance rate"],
    "measureDescription": "Radiometric calibration accuracy assessed against certified reference targets"
  },
  "evaluationMethod": {
    "evaluationMethodType": "directExternal",
    "evaluationMethodDescription": "Pre-flight calibration with certified reference targets",
    "dateTime": "2025-06-16T14:00:00Z"
  },
  "result": [{
    "resultType": "quantitative",
    "value": [95.0],
    "valueUnit": "percent",
    "errorStatistic": "accuracy"
  }]
}
```

### 4. Sensor Quality (Imagery-Specific)

| ISO 19115-4 Approach | ISO 19157-3 Measures | Migration Strategy |
|---------------------|---------------------|-------------------|
| Sensor calibration status and date | **Metaquality - Measure 129**: Confidence in data quality result<br>Custom measures for sensor health | Map calibration status to metaquality confidence; document sensor health in lineage |

**Example:**
```json
// ISO 19115-4
{
  "type": "sensorQuality",
  "sensorType": "Multispectral Scanner",
  "calibrationStatus": "calibrated",
  "calibrationDate": "2025-05-15T10:00:00Z",
  "measure": {
    "description": "Sensor fully calibrated before acquisition"
  }
}

// ISO 19157-3 Equivalent (using Metaquality)
{
  "category": "metaquality",
  "subcategory": "confidence",
  "measure": {
    "measureIdentification": {
      "code": "129",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Confidence in data quality result"],
    "measureDescription": "Confidence in imagery quality based on sensor calibration status"
  },
  "evaluationMethod": {
    "evaluationMethodType": "indirect",
    "evaluationMethodDescription": "Sensor calibration certificate validated; multispectral scanner fully calibrated on 2025-05-15",
    "dateTime": "2025-05-15T10:00:00Z"
  },
  "result": [{
    "resultType": "quantitative",
    "value": [0.95],
    "valueUnit": "probability",
    "valueRecordType": "Real"
  }]
}
```

### 5. Cloud Coverage (Imagery-Specific)

| ISO 19115-4 Approach | ISO 19157-3 Measures | Migration Strategy |
|---------------------|---------------------|-------------------|
| Cloud coverage percentage | **Usability** assessment with limitations<br>**Descriptive result** | Report as usability limitation or descriptive environmental condition; no standardized ISO 19157-3 measure |

**Example:**
```json
// ISO 19115-4
{
  "type": "cloudCoverage",
  "coveragePercentage": 15.5,
  "assessmentMethod": "Automated cloud detection algorithm"
}

// ISO 19157-3 Equivalent (using Usability)
{
  "category": "usability",
  "usabilityDescription": "Imagery affected by cloud coverage",
  "evaluationMethod": {
    "evaluationMethodType": "directInternal",
    "evaluationMethodDescription": "Automated cloud detection algorithm",
    "dateTime": "2025-06-16T14:00:00Z"
  },
  "result": [{
    "resultType": "descriptive",
    "statement": "Cloud coverage: 15.5% of scene area. May affect feature interpretation in affected regions. Clear areas suitable for land cover classification."
  }]
}
```

### 6. Processing Level (Imagery-Specific)

| ISO 19115-4 Approach | ISO 19157-3 Measures | Migration Strategy |
|---------------------|---------------------|-------------------|
| Processing level code and description | **Lineage - Process Step** | Document as lineage process step with processing level metadata |

**Example:**
```json
// ISO 19115-4
{
  "type": "processingLevel",
  "level": "L2A",
  "description": "Atmospherically corrected surface reflectance",
  "processingDate": "2025-06-16T08:30:00Z",
  "processor": "Sen2Cor v2.10"
}

// ISO 19157-3 Equivalent (in Lineage)
{
  "lineage": {
    "statement": "Sentinel-2 imagery processed from L1C to L2A using atmospheric correction",
    "processStep": [{
      "description": "Atmospheric correction to surface reflectance (Processing Level L2A)",
      "rationale": "Convert top-of-atmosphere reflectance to surface reflectance for vegetation analysis",
      "dateTime": "2025-06-16T08:30:00Z",
      "processor": {
        "organisationName": "ESA Copernicus",
        "individualName": "Automated Processing System"
      },
      "processingInformation": {
        "identifier": "Sen2Cor v2.10",
        "softwareReference": {
          "title": "Sen2Cor Atmospheric Correction Processor",
          "edition": "2.10",
          "date": "2025-01-01"
        },
        "procedureDescription": "Atmospheric correction using MODTRAN radiative transfer model",
        "algorithm": [{
          "title": "Sen2Cor Algorithm Theoretical Basis Document",
          "date": "2025-01-01",
          "citedResponsibleParty": "ESA"
        }]
      }
    }]
  }
}
```

---

## Quality Category Availability Matrix

| Quality Category | ISO 19115-4 | ISO 19157-3 | Compatibility |
|-----------------|-------------|-------------|---------------|
| **Completeness** | ✓ | ✓ | Direct |
| **Logical Consistency** | ✓ | ✓ | Direct (enhanced subcategories) |
| **Positional Accuracy** | ✓ | ✓ | Direct (enhanced measures) |
| **Thematic/Attribute Accuracy** | ✓ (separate) | ✓ (merged as thematicQuality) | Merged |
| **Temporal Accuracy** | ✓ | ✓ (renamed temporalQuality) | Renamed |
| **Topological Consistency** | ✓ | ✓ (subcategory) | Subcategory |
| **Lineage** | ✓ | ✓ | Direct (enhanced structure) |
| **Radiometric Accuracy** | ✓ (19115-4) | ⚠ (map to thematicQuality) | Partial |
| **Sensor Quality** | ✓ (19115-4) | ⚠ (map to metaquality) | Partial |
| **Cloud Coverage** | ✓ (19115-4) | ⚠ (map to usability) | Indirect |
| **Snow Coverage** | ✓ (19115-4) | ⚠ (map to usability) | Indirect |
| **Processing Level** | ✓ (19115-4) | ✓ (lineage processStep) | Direct |
| **Usability Assessment** | ✓ (19115-4) | ✓ | Direct (formalized) |
| **Metaquality** | ❌ | ✓ (NEW) | New in 19157-3 |

**Legend:**
- ✓ Direct compatibility
- ⚠ Partial/indirect mapping required
- ❌ Not available

---

## Evaluation Methods Comparison

| ISO 19115-4 | ISO 19157-3 | Description |
|-------------|-------------|-------------|
| Generic method description | `directInternal` | Internal dataset analysis without external reference |
| Ground control point comparison | `directExternal` | Comparison with external reference data (ground truth) |
| Inference from metadata | `indirect` | Quality inferred from related information |

**ISO 19157-3 Advantages:**
- Standardized method type vocabulary
- Mandatory evaluation timestamp
- Reference to official procedure documentation
- Formal procedure citation structure

---

## Result Types Comparison

| ISO 19115-4 | ISO 19157-3 | Migration |
|-------------|-------------|-----------|
| Simple value + units | `quantitative_result` | Add resultType, valueRecordType, errorStatistic |
| Conformance pass/fail | `conformance_result` | Add formal specification citation structure |
| Text description | `descriptive_result` | Direct mapping with resultType field |
| ❌ Not supported | `coverage_result` | NEW: Spatial quality variation maps |

**Example - Conformance Result:**
```json
// ISO 19115-4
{
  "specification": "INSPIRE Data Specification",
  "explanation": "Meets positional accuracy requirements",
  "pass": true
}

// ISO 19157-3
{
  "resultType": "conformance",
  "specification": {
    "title": "INSPIRE Data Specification on Administrative Units",
    "date": "2014-04-10",
    "dateType": "publication",
    "edition": "3.1",
    "identifier": "D2.8.I.4"
  },
  "explanation": "Dataset meets INSPIRE positional accuracy requirement of ≤ 1m for urban areas",
  "pass": true
}
```

---

## Standardized Measure Identifiers (ISO 19157-3 Advantage)

ISO 19157-3 provides a **registered catalog of quality measures** with unique numeric identifiers, enabling consistent reporting across organizations.

### Key Measures for Imagery Data

| Measure ID | Name | Category | Use for Imagery |
|------------|------|----------|-----------------|
| **3** | Rate of missing items | Completeness (omission) | Missing features in vector extractions |
| **4** | Rate of excess items | Completeness (commission) | False positives in classifications |
| **28** | Mean value of positional uncertainties | Positional Accuracy | Geometric accuracy of orthorectified imagery |
| **47** | Root mean square error (RMSE) | Positional Accuracy | Standard accuracy metric |
| **48** | Circular error probable (CEP) | Positional Accuracy | Horizontal accuracy at 50% confidence |
| **60** | Value domain conformance rate | Thematic Quality | Radiometric value validation |
| **117** | Value domain non-conformance rate | Thematic Quality | Radiometric calibration errors |
| **129** | Confidence in data quality result | Metaquality | Sensor calibration confidence |

**Reference:**
- Development register: https://defs-hosted.opengis.net/prez-hosted/catalogs/hosted:iso-19157-3
- Permanent URI (April 2026): https://def.isotc211.org/dataqualitymeasures/

---

## Migration Strategy Recommendations

### For Imagery Data Providers

1. **Immediate (Backward Compatible)**
   - Continue using ISO 19115-4 for imagery-specific metadata
   - Add ISO 19157-3 quality measures alongside existing 19115-4 elements
   - Use both `iso19115-quality.json` and `iso19157-quality.json` schemas in STAC

2. **Short Term (3-6 months)**
   - Map radiometric accuracy → thematicQuality with Measure 60
   - Map sensor quality → metaquality confidence with Measure 129
   - Map cloud/snow coverage → usability descriptive results
   - Document processing levels in lineage.processStep

3. **Long Term (ISO 19157-3 publication, April 2026)**
   - Fully adopt ISO 19157-3 as primary quality framework
   - Use standardized measure identifiers for all quality reports
   - Maintain ISO 19115-4 lineage for processing history
   - Leverage metaquality for critical mission data

### Dual-Format Example (Recommended Approach)

```json
{
  "liability:quality": [
    {
      // ISO 19157-3 (Primary - comprehensive quality)
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
            }
          },
          "result": [{"resultType": "quantitative", "value": [12.3], "valueUnit": "meter"}]
        },
        {
          "category": "metaquality",
          "subcategory": "confidence",
          "measure": {"measureIdentification": {"code": "129", "codeSpace": "ISO 19157"}},
          "result": [{"resultType": "quantitative", "value": [0.95], "valueUnit": "probability"}]
        }
      ],
      "lineage": {
        "statement": "Sentinel-2 L2A atmospherically corrected",
        "processStep": [
          {
            "description": "Processing Level L2A - Surface reflectance",
            "dateTime": "2025-06-16T08:30:00Z",
            "processingInformation": {
              "identifier": "Sen2Cor v2.10"
            }
          }
        ]
      }
    },
    {
      // ISO 19115-4 (Backward compatibility - imagery-specific)
      "reportId": "IMAGERY-QUAL-001",
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
        },
        {
          "elementType": "cloudCoverage",
          "detail": {
            "type": "cloudCoverage",
            "coveragePercentage": 15.5,
            "assessmentMethod": "Automated cloud detection"
          }
        },
        {
          "elementType": "processingLevel",
          "detail": {
            "type": "processingLevel",
            "level": "L2A",
            "description": "Atmospherically corrected surface reflectance",
            "processingDate": "2025-06-16T08:30:00Z",
            "processor": "Sen2Cor v2.10"
          }
        }
      ]
    }
  ]
}
```

---

## Compatibility Summary

### High Compatibility (Direct Mapping)
- ✅ Completeness
- ✅ Logical Consistency
- ✅ Positional Accuracy
- ✅ Temporal Quality
- ✅ Lineage
- ✅ Usability Assessment
- ✅ Processing Level (via lineage)

### Partial Compatibility (Requires Interpretation)
- ⚠️ Radiometric Accuracy → Thematic Quality
- ⚠️ Sensor Quality → Metaquality Confidence
- ⚠️ Cloud Coverage → Usability/Descriptive Result
- ⚠️ Snow Coverage → Usability/Descriptive Result

### New in ISO 19157-3 (No 19115-4 Equivalent)
- ✨ Metaquality (quality of quality)
- ✨ Coverage Result (spatial quality variation)
- ✨ Standardized measure identifiers
- ✨ Formal evaluation method types
- ✨ Enhanced temporal quality

### Recommendation
**Compatibility Rating: 4/5**

ISO 19115-4 and ISO 19157-3 are **highly compatible** with clear migration paths. Organizations can:
1. Use both standards concurrently (dual-format approach)
2. Gradually migrate imagery-specific elements to ISO 19157-3 equivalents
3. Leverage ISO 19157-3's metaquality for enhanced imagery quality reporting
4. Maintain ISO 19115-4 lineage structure (fully preserved in ISO 19157)

---

## Related Documentation

- [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) - Complete ISO 19157-1:2023 integration guide
- [ISO19157-UPDATE-SUMMARY.md](ISO19157-UPDATE-SUMMARY.md) - Summary of ISO 19157 updates
- [json-schema/iso19115-quality.json](json-schema/iso19115-quality.json) - ISO 19115/19115-4 JSON Schema
- [json-schema/iso19157-quality.json](json-schema/iso19157-quality.json) - ISO 19157-1:2023 JSON Schema

## Standards References

- **ISO 19115-1:2014** - Geographic information - Metadata - Part 1: Fundamentals
- **ISO 19115-4** - Geographic information - Metadata - Part 4: Imagery and gridded data
- **ISO 19157-1:2023** - Geographic information - Data quality - Part 1: General requirements
- **ISO 19157-3:2026** - Geographic information - Data quality - Part 3: Data quality measures register (expected April 2026)

## Contact

For questions about quality measure compatibility:
- Email: luciocol@gmail.com
- GitHub Issues: https://github.com/stac-extensions/liability-claims/issues
