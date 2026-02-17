# STAC Extension Liability Claims - NIIRS Compatibility Analysis

**Analysis Date:** February 11, 2026  
**STAC Extension Version:** v1.3.0  
**Reference Standard:** NIIRS (National Imagery Interpretability Rating Scale)  
**Reference URL:** https://irp.fas.org/imint/niirs.htm

---

## Executive Summary

The STAC Extension Liability Claims v1.3.0 is **structurally compatible but functionally incomplete** for NIIRS integration. While the extension provides comprehensive ISO 19157/19115 quality metadata infrastructure, it **does not currently include NIIRS-specific fields** for imagery interpretability ratings.

### Compatibility Status: ⚠️ **PARTIAL**

| Aspect | Compatible? | Details |
|--------|-------------|---------|
| **Quality Metadata Infrastructure** | ✅ Yes | ISO 19157 quality reports support interpretability metrics |
| **NIIRS Rating Fields** | ❌ No | No dedicated fields for NIIRS levels (0-9) |
| **Imagery Quality Measures** | ⚠️ Partial | Generic quality measures exist, but no NIIRS-specific criteria |
| **Multi-Spectral Support** | ⚠️ Partial | No specific fields for MS NIIRS, IR NIIRS, Radar NIIRS variants |
| **Interpretability Tasks** | ❌ No | No structured representation of NIIRS task criteria |
| **GIQE Integration** | ❌ No | No General Image Quality Equation (GIQE) parameters |

---

## What is NIIRS?

The **National Imagery Interpretability Rating Scale (NIIRS)** is a U.S. government standard for measuring the quality and interpretability of aerial and satellite imagery. It provides:

### NIIRS Variants

1. **Visible NIIRS** (March 1994) - Standard photographic imagery
2. **Radar NIIRS** (August 1992) - Synthetic Aperture Radar (SAR) imagery
3. **Infrared NIIRS** (April 1996) - Thermal/IR imagery
4. **Multispectral NIIRS** (February 1995) - Multi-band imagery

### Rating Scale (0-9)

- **0**: Interpretability precluded by obscuration, degradation, or very poor resolution
- **1**: Detect large area features (ports, airfields, urban vs rural)
- **2**: Detect large buildings, hangars, military installations
- **3**: Identify large aircraft wing configurations, SAM sites
- **4**: Identify fighter aircraft types, tracked vehicles
- **5**: Distinguish aircraft models (FENCER vs. FOXBAT), missile types
- **6**: Identify vehicle spare tires, antenna shapes, ship details
- **7**: Detect rivet lines, joints/welds on equipment
- **8**: Identify windshield wipers, screws/bolts
- **9**: Detect individual spikes in railroad ties, fastener slot types

### Key Characteristics

- **Task-Based:** Each level defines specific interpretation tasks achievable at that quality
- **Resolution-Driven:** Higher NIIRS = finer spatial resolution = more detailed interpretation
- **Application-Specific:** Different NIIRS variants for different sensor types
- **Standardized:** Used across DoD, intelligence community, civil applications

---

## Current STAC Extension Capabilities

### What the Extension DOES Provide

#### 1. ISO 19157 Quality Metadata

```json
{
  "liability:quality": {
    "scope": {
      "level": "dataset"
    },
    "report": [
      {
        "type": "DQ_AbsoluteExternalPositionalAccuracy",
        "measure": {
          "nameOfMeasure": ["Absolute positional accuracy"],
          "measureIdentification": {
            "code": "ISO19157:2013",
            "description": "Positional accuracy of georeferenced data"
          }
        },
        "result": [
          {
            "type": "QuantitativeResult",
            "value": [10.5],
            "valueUnit": "meter"
          }
        ]
      }
    ]
  }
}
```

**✅ Supports:** Generic quality measures with quantitative results

#### 2. EOVOC Dual Namespace

```json
{
  "dq:quality": [
    {
      "scope": {"level": "dataset"},
      "report": [{...}]
    }
  ]
}
```

**✅ Supports:** Compatibility with Earth Observation Vocabulary (EOVOC) schemas

#### 3. Lineage/Provenance

```json
{
  "liability:quality": {
    "lineage": {
      "statement": "Imagery captured by WorldView-3 satellite on 2024-01-15",
      "processStep": [{
        "description": "Orthorectification using SRTM DEM"
      }]
    }
  }
}
```

**✅ Supports:** Source tracking and processing history

### What the Extension DOES NOT Provide

#### ❌ NIIRS Rating Field

No field for storing the NIIRS level (0-9) assigned to imagery:

```json
// MISSING - No equivalent exists
{
  "imagery:niirs": 6,
  "imagery:niirs_type": "visible"
}
```

#### ❌ NIIRS Task Criteria

No structured representation of specific interpretation tasks achievable:

```json
// MISSING
{
  "imagery:niirs_tasks": [
    "Identify vehicle spare tires",
    "Distinguish antenna shapes",
    "Identify ship launcher covers"
  ]
}
```

#### ❌ GIQE Parameters

No General Image Quality Equation metrics:

```json
// MISSING
{
  "imagery:giqe": {
    "gsd": 0.5,
    "rer": 0.9,
    "snr": 50,
    "edge_overshoot": 0.1
  }
}
```

#### ❌ Multi-Sensor NIIRS Variants

No distinction between Visible/Radar/IR/Multispectral NIIRS:

```json
// MISSING
{
  "imagery:niirs_variants": {
    "visible": 6,
    "radar": 5,
    "infrared": 4,
    "multispectral": 7
  }
}
```

---

## Compatibility Gap Analysis

### Gap 1: No NIIRS Top-Level Field

**Issue:** Users cannot specify NIIRS rating without custom extensions

**Impact:** 
- Cannot filter imagery by interpretability level
- Cannot validate imagery meets mission NIIRS requirements
- Incompatible with NIIRS-aware applications

**Workaround (Current):**
```json
{
  "liability:quality": {
    "report": [
      {
        "type": "DQ_UsabilityElement",
        "measure": {
          "nameOfMeasure": ["NIIRS Rating"],
          "measureDescription": "National Imagery Interpretability Rating Scale"
        },
        "result": [
          {
            "type": "QuantitativeResult",
            "value": [6],
            "valueUnit": "NIIRS_level"
          }
        ]
      }
    ]
  }
}
```

**Limitation:** Not standardized, requires custom parsing logic

### Gap 2: No Sensor-Specific NIIRS

**Issue:** NIIRS varies by sensor type (Visible/SAR/IR/MS)

**Impact:**
- Cannot represent multi-sensor imagery with different NIIRS per band
- Cannot specify which NIIRS variant applies
- Ambiguous for mixed-sensor platforms

**Workaround (Current):**
```json
{
  "liability:quality": {
    "report": [
      {
        "type": "DQ_UsabilityElement",
        "measure": {
          "nameOfMeasure": ["Visible NIIRS"]
        },
        "result": [{"type": "QuantitativeResult", "value": [6]}]
      },
      {
        "type": "DQ_UsabilityElement",
        "measure": {
          "nameOfMeasure": ["Radar NIIRS"]
        },
        "result": [{"type": "QuantitativeResult", "value": [5]}]
      }
    ]
  }
}
```

**Limitation:** Verbose, inconsistent naming across implementations

### Gap 3: No Interpretation Task Metadata

**Issue:** NIIRS levels are defined by achievable tasks, but extension has no task enumeration

**Impact:**
- Users must manually reference NIIRS documentation
- Cannot auto-generate capability reports
- No machine-readable task validation

**No Current Workaround**

### Gap 4: No GIQE Support

**Issue:** GIQE (General Image Quality Equation) predicts NIIRS from physical parameters

**Impact:**
- Cannot compute predicted NIIRS from sensor specs
- Cannot validate reported NIIRS against physical measurements
- Missing critical metadata for NIIRS verification

**Workaround (Current):**
```json
{
  "properties": {
    "gsd": 0.5,
    "eo:cloud_cover": 10
  }
}
```

**Limitation:** GSD is available via eo extension, but RER/SNR/overshoot not standardized

---

## Recommendations for NIIRS Integration

### Option 1: Add NIIRS Fields to v1.4.0 (RECOMMENDED)

Add dedicated NIIRS fields to the liability extension:

```json
{
  "liability:niirs": {
    "overall": 6,
    "variants": {
      "visible": 6,
      "radar": 5,
      "infrared": null,
      "multispectral": 7
    },
    "evaluation_method": "subjective_analyst_rating",
    "evaluation_date": "2024-01-15T14:30:00Z",
    "tasks_verified": [
      "Identify vehicle spare tires",
      "Distinguish antenna shapes as parabolic/rectangular"
    ],
    "giqe_predicted": 5.8
  }
}
```

**Advantages:**
- ✅ Native NIIRS support without workarounds
- ✅ Structured, searchable metadata
- ✅ Validation-friendly schema
- ✅ Backward compatible (optional field)

**Schema Addition:**
```json
{
  "definitions": {
    "fields": {
      "properties": {
        "liability:niirs": {
          "type": "object",
          "title": "NIIRS Interpretability Rating",
          "description": "National Imagery Interpretability Rating Scale metadata",
          "properties": {
            "overall": {
              "type": "number",
              "minimum": 0,
              "maximum": 9,
              "description": "Overall NIIRS rating (0-9)"
            },
            "variants": {
              "type": "object",
              "description": "Sensor-specific NIIRS ratings",
              "properties": {
                "visible": {"type": ["number", "null"], "minimum": 0, "maximum": 9},
                "radar": {"type": ["number", "null"], "minimum": 0, "maximum": 9},
                "infrared": {"type": ["number", "null"], "minimum": 0, "maximum": 9},
                "multispectral": {"type": ["number", "null"], "minimum": 0, "maximum": 9}
              }
            },
            "evaluation_method": {
              "type": "string",
              "enum": [
                "subjective_analyst_rating",
                "giqe_prediction",
                "automated_assessment",
                "comparative_analysis"
              ]
            },
            "evaluation_date": {
              "type": "string",
              "format": "date-time"
            },
            "tasks_verified": {
              "type": "array",
              "items": {"type": "string"},
              "description": "List of NIIRS tasks confirmed achievable with this imagery"
            },
            "giqe_predicted": {
              "type": "number",
              "minimum": 0,
              "maximum": 9,
              "description": "NIIRS predicted by General Image Quality Equation"
            }
          },
          "required": ["overall"]
        }
      }
    }
  }
}
```

### Option 2: Reference via ISO 19157 Quality Reports (CURRENT APPROACH)

Continue using generic quality reports with NIIRS encoded as usability measures:

```json
{
  "liability:quality": {
    "report": [
      {
        "type": "DQ_UsabilityElement",
        "measure": {
          "nameOfMeasure": ["National Imagery Interpretability Rating Scale"],
          "measureIdentification": {
            "code": "NIIRS",
            "codeSpace": "https://irp.fas.org/imint/niirs.htm"
          },
          "measureDescription": "Visible NIIRS rating for imagery interpretability"
        },
        "evaluationMethod": {
          "type": "CI_Citation",
          "title": "NIIRS Evaluation Methodology",
          "date": [{"date": "2024-01-15T14:30:00Z", "dateType": "creation"}]
        },
        "result": [
          {
            "type": "QuantitativeResult",
            "value": [6],
            "valueUnit": "NIIRS_level"
          }
        ]
      }
    ]
  }
}
```

**Advantages:**
- ✅ No schema changes required
- ✅ Uses existing ISO 19157 infrastructure
- ✅ Fully compliant with current v1.3.0

**Disadvantages:**
- ❌ Verbose and difficult to query
- ❌ Requires custom parsing logic
- ❌ No validation of NIIRS-specific rules
- ❌ Inconsistent across implementations

### Option 3: Separate NIIRS STAC Extension

Create a dedicated `stac-extension-niirs` for imagery interpretability:

```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.3.0/schema.json",
    "https://example.org/stac-extension-niirs/v1.0.0/schema.json"
  ],
  "properties": {
    "niirs:rating": 6,
    "niirs:type": "visible",
    "niirs:giqe": {
      "gsd": 0.5,
      "rer": 0.9,
      "snr": 50
    }
  }
}
```

**Advantages:**
- ✅ Focused extension for imagery community
- ✅ Can evolve independently
- ✅ Composable with liability extension

**Disadvantages:**
- ❌ Requires maintaining separate extension
- ❌ Potential overlap with eo extension
- ❌ Community adoption uncertainty

---

## Interoperability Assessment

### With ISO 19157 Quality Standards

**Status: ✅ FULLY COMPATIBLE**

The liability extension's ISO 19157 infrastructure can represent NIIRS as a data quality measure:

```json
{
  "liability:quality": {
    "scope": {"level": "dataset"},
    "report": [
      {
        "type": "DQ_UsabilityElement",
        "measure": {
          "nameOfMeasure": ["NIIRS"],
          "measureIdentification": {
            "code": "NIIRS-6",
            "authority": {
              "title": "National Imagery Interpretability Rating Scale",
              "date": [{"date": "1996-03-01", "dateType": "publication"}]
            }
          }
        },
        "result": [
          {
            "type": "QuantitativeResult",
            "value": [6]
          }
        ]
      }
    ]
  }
}
```

### With EOVOC Earth Observation Extension

**Status: ✅ COMPATIBLE VIA DUAL NAMESPACE**

The `dq:quality` array field enables EOVOC compatibility:

```json
{
  "dq:quality": [
    {
      "scope": {"level": "dataset"},
      "report": [
        {
          "type": "DQ_UsabilityElement",
          "measure": {"nameOfMeasure": ["NIIRS"]},
          "result": [{"type": "QuantitativeResult", "value": [6]}]
        }
      ]
    }
  ]
}
```

### With STAC EO Extension

**Status: ⚠️ COMPLEMENTARY BUT INCOMPLETE**

The [eo extension](https://github.com/stac-extensions/eo) provides:
- `eo:cloud_cover` - Affects NIIRS via obscuration
- `eo:bands` - Multi-spectral metadata

**Missing for NIIRS:**
- Ground Sample Distance (GSD) - available in separate extensions
- Relative Edge Response (RER) - no standard field
- Signal-to-Noise Ratio (SNR) - no standard field
- Edge overshoot - no standard field

### With Defense/Intelligence Systems

**Status: ⚠️ REQUIRES CUSTOM MAPPING**

Many DoD/IC systems expect NIIRS as a top-level metadata field. Current approach requires:

1. **Custom extraction logic** to parse NIIRS from quality reports
2. **Schema mapping** to convert ISO 19157 to system-specific formats
3. **Validation rules** to ensure NIIRS values are 0-9 integers

---

## Use Case Analysis

### Use Case 1: Intelligence Mission Planning

**Requirement:** "Find imagery with NIIRS ≥ 5 covering Area X"

**Current Approach (v1.3.0):**
```javascript
// STAC API query - CANNOT FILTER ON NIIRS DIRECTLY
// Must fetch all items and parse quality reports
const items = await fetch('/search?bbox=...').then(r => r.json());
const filtered = items.features.filter(item => {
  const quality = item.properties['liability:quality'];
  if (!quality || !quality.report) return false;
  
  const niirsReport = quality.report.find(r => 
    r.measure?.nameOfMeasure?.includes('NIIRS')
  );
  
  return niirsReport && 
         niirsReport.result?.[0]?.value?.[0] >= 5;
});
```

**With Proposed NIIRS Field:**
```javascript
// Direct STAC API query
const items = await fetch('/search?bbox=...&query={"liability:niirs.overall":{"gte":5}}')
  .then(r => r.json());
```

**Impact:** 10x simpler query, server-side filtering, standard STAC API support

### Use Case 2: Multi-Sensor Platform

**Requirement:** "Satellite provides Visible NIIRS 7, SAR NIIRS 5 - represent both"

**Current Approach (v1.3.0):**
```json
{
  "liability:quality": {
    "report": [
      {
        "type": "DQ_UsabilityElement",
        "measure": {"nameOfMeasure": ["Visible NIIRS"]},
        "result": [{"type": "QuantitativeResult", "value": [7]}]
      },
      {
        "type": "DQ_UsabilityElement",
        "measure": {"nameOfMeasure": ["Radar NIIRS"]},
        "result": [{"type": "QuantitativeResult", "value": [5]}]
      }
    ]
  }
}
```

**With Proposed NIIRS Field:**
```json
{
  "liability:niirs": {
    "overall": 7,
    "variants": {
      "visible": 7,
      "radar": 5
    }
  }
}
```

**Impact:** 50% smaller, structured for validation, queryable

### Use Case 3: Automated Quality Assessment

**Requirement:** "Predict NIIRS from GIQE parameters and validate against analyst rating"

**Current Approach (v1.3.0):**
- ❌ No standardized GIQE parameter storage
- ❌ Cannot correlate predicted vs. actual NIIRS
- ⚠️ Must use custom properties

**With Proposed NIIRS Field:**
```json
{
  "liability:niirs": {
    "overall": 6,
    "giqe_predicted": 5.8,
    "evaluation_method": "subjective_analyst_rating"
  }
}
```

**Impact:** Enables quality control, validation workflows, automated systems

---

## Conclusion

### Current Status

The STAC Extension Liability Claims v1.3.0:

✅ **CAN represent NIIRS** via ISO 19157 quality reports (verbose approach)  
✅ **IS compatible** with ISO standards and EOVOC schemas  
⚠️ **LACKS native NIIRS fields** for efficient use  
❌ **DOES NOT support** GIQE parameters or task enumeration  
❌ **IS NOT optimized** for intelligence/defense workflows  

### Recommendations

**For Immediate Use (v1.3.0):**
1. Use `DQ_UsabilityElement` quality reports to encode NIIRS
2. Store NIIRS variant type in `measureDescription`
3. Use `QuantitativeResult.value` array with single element for NIIRS level
4. Document standard naming conventions in extension documentation

**For v1.4.0 Development:**
1. ✅ **Add `liability:niirs` top-level field** (Option 1 recommended)
2. ✅ Include sensor variant support (visible/radar/IR/MS)
3. ✅ Add GIQE parameter fields
4. ✅ Provide task verification metadata
5. ⚠️ Consider alignment with planned `stac-extension-eo` updates
6. 📝 Add NIIRS examples to documentation

**For Long-Term Compatibility:**
1. Coordinate with STAC community on imagery quality standards
2. Reference official NIIRS documentation in schema descriptions
3. Validate against DoD/IC metadata requirements
4. Ensure backward compatibility with ISO 19157 approach

---

## References

- **NIIRS Specification:** https://irp.fas.org/imint/niirs.htm
- **Civil NIIRS Reference Guide:** https://irp.fas.org/imint/niirs_c/index.html
- **EOVOC EOF-EOS Extension:** https://github.com/eovoc/eof-eos-stac-extension
- **ISO 19157-1:2023:** Geographic information — Data quality
- **ISO 19115-1:2014:** Geographic information — Metadata
- **STAC Extension Liability Claims v1.3.0:** https://luciocola.github.io/stac-extension-liability-claims/v1.3.0/

---

**Document Version:** 1.0  
**Analysis Performed:** February 11, 2026  
**Prepared For:** 4113 Engineering STAC Extension Development  
**Next Review:** Upon v1.4.0 planning
