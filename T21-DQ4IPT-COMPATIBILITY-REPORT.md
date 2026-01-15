# T21-DQ4IPT Data Quality Extension Compatibility Report

## Executive Summary

**Date:** January 15, 2025  
**Document Version:** 1.0  
**Prepared For:** STAC Liability and Claims Extension v1.1.0

### Key Findings

✅ **COMPATIBLE** - The liability-claims extension and T21-DQ4IPT data quality extension can coexist and complement each other  
⚠️ **OVERLAP IDENTIFIED** - Both extensions address data quality but with different scopes  
📋 **RECOMMENDATION** - Use both extensions together for comprehensive quality and legal tracking

### Compatibility Score: 4.5/5 ⭐

**Strengths:**
- Both follow STAC 1.0.0 specification
- Both reference ISO 19157 data quality standard
- No direct field name conflicts (different prefixes: `liability:` vs `dq:`)
- Complementary purposes: legal/claims vs technical quality

**Gaps:**
- Different JSON Schema draft versions (draft-07 vs draft/2020-12)
- Different ISO 19157 implementation approaches
- T21-DQ4IPT uses external schema references; liability-claims uses embedded schemas

---

## 1. Extension Overview Comparison

### 1.1 T21-DQ4IPT Data Quality Extension

| Property | Value |
|----------|-------|
| **Extension Name** | Data Quality Extension |
| **Prefix** | `dq:` |
| **Version** | v0.1.0 |
| **Schema ID** | https://xxx.github.io/dq/v0.1.0/schema.json |
| **JSON Schema Version** | draft/2020-12 |
| **Primary Standard** | ISO 19157-1:2023 |
| **Schema Approach** | External reference to schemas.isotc211.org |
| **Scope** | Items, Collections, Assets |
| **Purpose** | Technical data quality metadata using standardized ISO measures |

**Key Field:**
- `dq:quality` - Array of DataQuality objects referencing ISO 19157 schema

**Example:**
```json
{
  "stac_extensions": ["https://xxx.github.io/dq/v0.1.0/schema.json"],
  "properties": {
    "dq:quality": [{
      "scope": {"level": "dataset"},
      "report": [
        {
          "type": "ConceptualConsistency",
          "measure": {
            "measureIdentification": {
              "code": "101",
              "authority": {
                "title": "International Organization for Standardization"
              },
              "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/"
            },
            "nameOfMeasure": ["MD101"]
          },
          "result": [{
            "type": "QuantitativeResult",
            "value": ["true"]
          }]
        }
      ]
    }]
  }
}
```

### 1.2 STAC Liability and Claims Extension

| Property | Value |
|----------|-------|
| **Extension Name** | Liability and Claims Extension |
| **Prefix** | `liability:` |
| **Version** | v1.1.0 |
| **Schema ID** | https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json |
| **JSON Schema Version** | draft-07 |
| **Primary Standard** | ISO 19157-1:2023 (with ISO 19115 backward compatibility) |
| **Schema Approach** | Embedded schemas with detailed definitions |
| **Scope** | Items, Collections, Assets |
| **Purpose** | Legal liability tracking, claims management, security classification, data quality, and provenance |

**Key Fields:**
- `liability:quality` - ISO 19157 or ISO 19115 quality reports (embedded schema)
- `liability:prov` - W3C PROV-JSON provenance
- `liability:claim_*` - Claim-specific metadata (status, type, parties, damages, etc.)
- `liability:security_classification` - Security levels for assets
- `liability:evidence_refs` - Legal evidence references

**Example:**
```json
{
  "stac_extensions": ["https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"],
  "properties": {
    "liability:claim_id": "CLAIM-2025-001",
    "liability:claim_status": "under_investigation",
    "liability:quality": {
      "scope": {"level": "dataset"},
      "report": [
        {
          "category": "positionalAccuracy",
          "subcategory": "absoluteExternalPositionalAccuracy",
          "measure": {
            "measureIdentification": {"code": "28", "codeSpace": "ISO 19157"}
          },
          "result": [{"resultType": "quantitative", "value": [12.3], "valueUnit": "meter"}]
        }
      ]
    }
  },
  "assets": {
    "evidence": {
      "liability:security_classification": "confidential",
      "liability:access_restrictions": ["legal_hold", "court_order"]
    }
  }
}
```

---

## 2. Detailed Field Comparison

### 2.1 Quality Field Structure Comparison

| Aspect | T21-DQ4IPT `dq:quality` | Liability-Claims `liability:quality` |
|--------|------------------------|--------------------------------------|
| **Data Type** | Array of DataQuality | oneOf: ISO 19157 data quality OR ISO 19115 quality report (array or single) |
| **ISO 19157 Reference** | External: `https://schemas.isotc211.org/json/19157/-1/dqc/1.0.0/dqc.json#DataQuality` | Embedded: `iso19157-quality.json#/definitions/iso19157_data_quality` |
| **Validation Strategy** | Relies on external ISO TC211 schema | Self-contained with embedded ISO 19157 definitions |
| **Backward Compatibility** | ISO 19157 only | ISO 19157 (preferred) + ISO 19115/19115-4 (legacy) |
| **Schema Enforcement** | `additionalProperties: false`, strict prefix pattern | `additionalProperties: false`, strict prefix pattern |
| **uniqueItems** | true (enforced in T21-DQ4IPT) | Not explicitly enforced |

### 2.2 ISO 19157 Implementation Differences

#### T21-DQ4IPT Approach
- **Strategy:** Reference canonical ISO TC211 JSON schemas hosted at schemas.isotc211.org
- **Advantages:**
  - Authoritative source alignment
  - Automatic updates when ISO schemas evolve
  - Reduced schema duplication
- **Disadvantages:**
  - External dependency (network required for validation)
  - Less control over schema versioning
  - Potential breaking changes if ISO schema updates

#### Liability-Claims Approach
- **Strategy:** Embed complete ISO 19157-1:2023 definitions in local schema files
- **Advantages:**
  - Self-contained validation (no network dependency)
  - Version stability and control
  - Enhanced documentation and examples
  - ISO 19115 backward compatibility
- **Disadvantages:**
  - Schema duplication
  - Manual updates when ISO 19157 evolves
  - Larger schema file size

### 2.3 Field Overlap Analysis

| Concept | T21-DQ4IPT | Liability-Claims | Overlap? | Notes |
|---------|-----------|------------------|----------|-------|
| **Data Quality Reports** | `dq:quality` | `liability:quality` | ✅ YES | Both reference ISO 19157; liability-claims adds ISO 19115 compatibility |
| **Provenance** | *(not included)* | `liability:prov` | ⚠️ COMPLEMENTARY | W3C PROV-JSON for tracking data lineage, agents, activities |
| **Security Classification** | *(not included)* | `liability:security_classification` | ⚠️ COMPLEMENTARY | Asset-level security levels |
| **Access Control** | *(not included)* | `liability:access_restrictions`, `liability:required_roles` | ⚠️ COMPLEMENTARY | Legal and role-based access restrictions |
| **Legal Claims** | *(not included)* | `liability:claim_*` fields (15 fields) | ⚠️ COMPLEMENTARY | Comprehensive legal claim tracking |
| **Evidence Management** | *(not included)* | `liability:evidence_refs` | ⚠️ COMPLEMENTARY | Links to legal evidence assets |

**Conclusion:** No true conflicts - the extensions serve different but related purposes.

---

## 3. Technical Compatibility Analysis

### 3.1 JSON Schema Version Compatibility

| Extension | JSON Schema Version | Validation Tools | Impact |
|-----------|-------------------|------------------|--------|
| **T21-DQ4IPT** | `draft/2020-12` | Latest validators (ajv 8+, jsonschema 4.18+) | Modern schema features: `$dynamicRef`, improved `unevaluatedProperties` |
| **Liability-Claims** | `draft-07` | Broad tool support (ajv 6+, jsonschema 3+) | Stable, widely supported, STAC ecosystem standard |

**Compatibility Assessment:**
- ✅ Both versions are backward compatible for validation purposes
- ⚠️ Tools validating STAC items with both extensions must support both draft-07 and draft/2020-12
- ⚠️ STAC specification recommends draft-07 for maximum ecosystem compatibility
- 📋 **Recommendation:** T21-DQ4IPT should consider downgrading to draft-07 for STAC alignment

### 3.2 STAC Extension Mechanism Compatibility

Both extensions use the standard STAC extension mechanism:

```json
{
  "stac_extensions": [
    "https://xxx.github.io/dq/v0.1.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "dq:quality": [...],
    "liability:quality": [...],
    "liability:claim_id": "..."
  }
}
```

✅ **FULLY COMPATIBLE** - Different field prefixes prevent naming collisions

### 3.3 Scope Compatibility

| Scope Level | T21-DQ4IPT Support | Liability-Claims Support | Compatible? |
|-------------|-------------------|-------------------------|-------------|
| **Item Properties** | ✅ Yes | ✅ Yes | ✅ |
| **Collection** | ✅ Yes | ✅ Yes | ✅ |
| **Assets** | ✅ Yes | ✅ Yes (with additional security fields) | ✅ |
| **Item Assets** | ✅ Yes | ⚠️ Not explicitly defined | ⚠️ |
| **Summaries** | ✅ Yes | ⚠️ Not explicitly defined | ⚠️ |

**Note:** Liability-claims focuses on item and asset-level metadata; T21-DQ4IPT provides collection-level quality summaries.

---

## 4. Use Case Alignment

### 4.1 T21-DQ4IPT Primary Use Cases
1. **Standardized Quality Reporting** - Using ISO 19157 registered measures with official codes
2. **Technical Data Quality** - Positional accuracy, thematic accuracy, completeness
3. **Identity and Provenance** (IPT) - Data trustworthiness and origin tracking
4. **OGC Testbed-21 Compliance** - Interoperability with OGC API standards

### 4.2 Liability-Claims Primary Use Cases
1. **Legal Liability Tracking** - Claims management, responsible parties, damages
2. **Security Classification** - Confidential, restricted, classified asset handling
3. **Access Control** - Role-based and legal restriction enforcement
4. **Evidence Management** - Legal hold, court order compliance
5. **Data Quality + Provenance** - ISO 19157/19115 quality + W3C PROV lineage
6. **Emergency Response** - Common Operating Picture (COP) scenarios with legal implications

### 4.3 Combined Use Cases

Organizations can use **both extensions together** for comprehensive metadata:

| Scenario | T21-DQ4IPT Usage | Liability-Claims Usage |
|----------|-----------------|----------------------|
| **Satellite Imagery Product** | `dq:quality` for technical accuracy metrics (positional, radiometric) | `liability:security_classification` for image classification; `liability:prov` for processing lineage |
| **Emergency Response Map** | `dq:quality` for dataset completeness and currency | `liability:claim_status` if litigation pending; `liability:evidence_refs` for court evidence |
| **Environmental Monitoring** | `dq:quality` for sensor accuracy and temporal consistency | `liability:quality` for regulatory compliance quality; `liability:claim_id` for environmental damage claims |
| **Legal Discovery** | `dq:quality` for data trustworthiness assessment | `liability:*` fields for complete legal case metadata and access restrictions |

---

## 5. Integration Strategy Recommendations

### 5.1 Recommended Approach: Dual Extension Pattern

**Use both extensions in the same STAC Item/Collection:**

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://xxx.github.io/dq/v0.1.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "properties": {
    "datetime": "2025-01-15T10:30:00Z",
    
    "dq:quality": [{
      "scope": {"level": "dataset"},
      "report": [
        {
          "type": "ConceptualConsistency",
          "measure": {
            "measureIdentification": {
              "code": "101",
              "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/"
            }
          },
          "result": [{"type": "QuantitativeResult", "value": ["true"]}]
        }
      ]
    }],
    
    "liability:claim_id": "ENV-2025-047",
    "liability:claim_status": "pending",
    "liability:claim_type": "environmental",
    "liability:prov": {
      "entity": {
        "e1": {"prov:id": "dataset-v1", "prov:wasGeneratedBy": "processing-2025"}
      },
      "activity": {
        "processing-2025": {"prov:id": "processing-2025", "prov:type": "DataProcessing"}
      }
    }
  },
  "assets": {
    "data": {
      "href": "data.geojson",
      "liability:security_classification": "internal",
      "liability:access_restrictions": ["legal_hold"]
    }
  }
}
```

**Benefits:**
- Technical quality metadata from T21-DQ4IPT `dq:quality`
- Legal and claims metadata from liability-claims
- Comprehensive provenance from `liability:prov`
- Security classifications from liability-claims assets

### 5.2 Field Selection Guidelines

| Requirement | Use T21-DQ4IPT | Use Liability-Claims | Use Both |
|-------------|---------------|---------------------|----------|
| ISO 19157 data quality only | `dq:quality` | - | - |
| ISO 19115 legacy compatibility | - | `liability:quality` | - |
| W3C PROV provenance | - | `liability:prov` | - |
| Legal claims tracking | - | `liability:claim_*` | - |
| Security classification | - | `liability:security_classification` | - |
| **Complete quality + legal metadata** | ✅ | ✅ | ✅ **RECOMMENDED** |

### 5.3 Conflict Resolution

**Scenario:** Both `dq:quality` and `liability:quality` present in same item

**Resolution Strategy:**
1. **Preferred:** Use `dq:quality` for **technical ISO 19157 data quality**
2. **Use `liability:quality` for:**
   - ISO 19115/19115-4 backward compatibility
   - Legal/regulatory compliance quality reports
   - Additional context-specific quality metadata

**Example:**
```json
{
  "properties": {
    "dq:quality": [
      {"scope": {"level": "dataset"}, "report": [/* Technical accuracy */]}
    ],
    "liability:quality": [
      {
        "reportId": "LEGAL-QUAL-001",
        "scope": "dataset",
        "elements": [/* Regulatory compliance quality using ISO 19115 */]
      }
    ]
  }
}
```

---

## 6. Identified Gaps and Limitations

### 6.1 T21-DQ4IPT Gaps

| Gap | Impact | Mitigation |
|-----|--------|-----------|
| **No provenance support** | Cannot track quality assessment activities, agents | Use `liability:prov` alongside `dq:quality` |
| **No security classification** | Cannot mark sensitive quality reports | Use `liability:security_classification` on assets |
| **External schema dependency** | Validation requires network access | Accept trade-off OR embed ISO schemas locally |
| **JSON Schema draft/2020-12** | Limited STAC tooling support | Downgrade to draft-07 for broader compatibility |

### 6.2 Liability-Claims Gaps

| Gap | Impact | Mitigation |
|-----|--------|-----------|
| **Schema duplication** | ISO 19157 schemas embedded, not referenced | Accept for stability OR reference schemas.isotc211.org |
| **No collection summaries** | Cannot summarize quality across collections | Add summaries support (follow T21-DQ4IPT pattern) |
| **Large schema file** | 1026 lines with embedded ISO definitions | Modularize into separate files (already done: `iso19157-quality.json`) |

### 6.3 Common Limitations

| Limitation | Both Extensions | Recommendation |
|-----------|----------------|---------------|
| **No automated quality checks** | Neither extension provides validation beyond schema | Integrate with quality assessment tools (e.g., QGIS, GDAL) |
| **No quality visualization** | Metadata-only, no rendering hints | Consider STAC rendering extension for quality overlays |
| **Limited quality aggregation** | No standard for combining quality from multiple sources | Define aggregation rules in implementation guidelines |

---

## 7. Recommended Actions

### 7.1 For Liability-Claims Extension Maintainers

#### Priority 1 (Immediate)
- [ ] **Document dual extension usage** - Create examples showing T21-DQ4IPT + liability-claims integration
- [ ] **Clarify quality field distinction** - Document when to use `dq:quality` vs `liability:quality`
- [ ] **Add T21-DQ4IPT reference** - Link to OGC Testbed-21 work in documentation

#### Priority 2 (Next Release)
- [ ] **Consider collection summaries** - Add `summaries` support following T21-DQ4IPT pattern
- [ ] **Alignment with OGC Building Blocks** - Ensure compatibility with OGC's modular schema approach
- [ ] **Provenance enhancement** - Document PROV integration with ISO 19157 lineage

#### Priority 3 (Future)
- [ ] **Evaluate JSON Schema upgrade** - Assess feasibility of moving to draft/2020-12
- [ ] **External schema references** - Consider referencing schemas.isotc211.org for ISO 19157 (optional)

### 7.2 For T21-DQ4IPT Extension Maintainers

#### Priority 1 (Immediate)
- [ ] **Add provenance support** - Integrate W3C PROV or reference liability-claims provenance pattern
- [ ] **Security classification guidance** - Document integration with security-focused extensions

#### Priority 2 (Next Release)
- [ ] **JSON Schema downgrade** - Consider draft-07 for STAC ecosystem compatibility
- [ ] **Asset-level quality** - Enhance asset quality metadata examples

### 7.3 For Users/Implementers

#### Priority 1 (Immediate)
✅ **Use both extensions together** for comprehensive metadata  
✅ **Use `dq:quality`** for technical ISO 19157 quality  
✅ **Use `liability:quality`** for legal/regulatory ISO 19115 quality  
✅ **Use `liability:prov`** for complete provenance tracking  
✅ **Use `liability:security_classification`** for sensitive data

#### Best Practice Example
```json
{
  "stac_extensions": [
    "https://xxx.github.io/dq/v0.1.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "dq:quality": [/* ISO 19157 technical quality */],
    "liability:quality": [/* ISO 19115 regulatory quality */],
    "liability:prov": {/* W3C PROV provenance */},
    "liability:claim_id": "...",
    "liability:security_classification": "..."
  }
}
```

---

## 8. Compatibility Matrix

| Feature | T21-DQ4IPT | Liability-Claims | Compatible? | Integration Pattern |
|---------|-----------|------------------|-------------|-------------------|
| **STAC 1.0.0** | ✅ | ✅ | ✅ | Standard |
| **JSON Schema** | draft/2020-12 | draft-07 | ⚠️ | Both supported by validators |
| **ISO 19157-1:2023** | ✅ (external ref) | ✅ (embedded) | ✅ | Use both approaches |
| **ISO 19115 Quality** | ❌ | ✅ | ✅ | liability-claims provides |
| **W3C PROV** | ❌ | ✅ | ✅ | liability-claims provides |
| **Security Classification** | ❌ | ✅ | ✅ | liability-claims provides |
| **Legal Claims** | ❌ | ✅ | ✅ | liability-claims provides |
| **Field Prefixes** | `dq:` | `liability:` | ✅ | No conflicts |
| **Item Support** | ✅ | ✅ | ✅ | Both supported |
| **Collection Support** | ✅ | ✅ | ✅ | Both supported |
| **Asset Support** | ✅ | ✅ (enhanced) | ✅ | Liability-claims adds security |
| **Summaries Support** | ✅ | ❌ | ⚠️ | T21-DQ4IPT only |
| **External Dependencies** | schemas.isotc211.org | None | ✅ | Trade-off: authority vs stability |

**Legend:**
- ✅ Supported/Compatible
- ⚠️ Partial support or trade-offs
- ❌ Not supported

---

## 9. Validation Examples

### 9.1 Validating Items with Both Extensions

**Tool:** Python with jsonschema

```python
import jsonschema
import json
import requests

# Load schemas
dq_schema = requests.get("https://xxx.github.io/dq/v0.1.0/schema.json").json()
liability_schema = requests.get("https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json").json()

# Load STAC item
with open("item.json") as f:
    item = json.load(f)

# Validate against both schemas
jsonschema.validate(item, dq_schema)  # T21-DQ4IPT validation
jsonschema.validate(item, liability_schema)  # Liability-claims validation

print("✅ Item valid for both extensions")
```

### 9.2 Example STAC Item Passing Both Validations

See [examples/dual-extension-item.json](examples/dual-extension-item.json) (to be created)

---

## 10. Conclusions and Recommendations

### 10.1 Summary

The T21-DQ4IPT Data Quality Extension and STAC Liability and Claims Extension are **highly compatible** and **complementary**:

1. **No Field Conflicts** - Different prefixes (`dq:` vs `liability:`) prevent naming collisions
2. **Shared ISO 19157 Foundation** - Both reference same standard with different implementation strategies
3. **Complementary Scopes** - T21-DQ4IPT focuses on technical quality; liability-claims adds legal, security, and provenance dimensions
4. **Dual Extension Pattern Works** - Both can coexist in same STAC items with clear separation of concerns

### 10.2 Final Recommendations

#### For Organizations
✅ **Use BOTH extensions** for datasets with quality + legal requirements  
✅ **Use T21-DQ4IPT alone** for pure technical quality metadata  
✅ **Use Liability-Claims alone** for legal claims with embedded quality  

#### For Extension Maintainers
📋 **Collaborate** on shared ISO 19157 schema definitions  
📋 **Document integration patterns** in both extension specifications  
📋 **Consider JSON Schema version alignment** (both use draft-07)

#### For STAC Community
📋 **Promote dual extension pattern** for comprehensive metadata  
📋 **Develop quality visualization tools** supporting both extensions  
📋 **Create validation tooling** for multi-extension items

### 10.3 Compatibility Rating Justification

**4.5/5 Stars** ⭐⭐⭐⭐⭐

**Strengths (+):**
- Fully compatible field structure (no conflicts)
- Complementary purposes enhance each other
- Both follow STAC best practices
- Clear integration patterns

**Deductions (-):**
- JSON Schema version mismatch (-0.3)
- Duplication of ISO 19157 schemas (-0.2)

**Overall Assessment:** Highly compatible with minor technical variations that do not impact practical usage.

---

## Appendix A: References

1. **OGC Testbed-21 Data Quality Extension**
   - Repository: https://github.com/xxx/dq
   - Specification: T21-DQ4IPT Engineering Report

2. **STAC Liability and Claims Extension**
   - Repository: https://github.com/stac-extensions/liability-claims
   - Version: v1.1.0
   - Documentation: ISO19157-INTEGRATION.md, PROV-IMPLEMENTATION-SUMMARY.md

3. **Standards**
   - ISO 19157-1:2023 Geographic information - Data quality - Part 1: General requirements (published)
   - ISO 19157-3:2026 Geographic information - Data quality - Part 3: Data quality measures register (expected April 2026, final draft stage)
   - ISO 19115-1:2014 Geographic information - Metadata
   - W3C PROV-DM: https://www.w3.org/TR/prov-dm/
   - STAC Specification 1.0.0: https://stacspec.org

4. **Schema and Register References**
   - ISO TC211 JSON Schemas: https://schemas.isotc211.org/json/19157/-1/dqc/1.0.0/
   - ISO 19157-3 Data Quality Measures Register (permanent): https://def.isotc211.org/dataqualitymeasures/
   - ISO 19157-3 Development Register: https://defs-hosted.opengis.net/prez-hosted/catalogs/hosted:iso-19157-3
   - JSON Schema draft-07: http://json-schema.org/draft-07/schema
   - JSON Schema draft/2020-12: https://json-schema.org/draft/2020-12/schema

---

## Appendix B: Example Integrations

### B.1 Satellite Imagery with Both Extensions

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://xxx.github.io/dq/v0.1.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json",
    "https://stac-extensions.github.io/sar/v1.0.0/schema.json"
  ],
  "type": "Feature",
  "id": "SAR-2025-01-15-SCENE-001",
  "geometry": {...},
  "properties": {
    "datetime": "2025-01-15T06:30:00Z",
    "platform": "Sentinel-1A",
    "instruments": ["C-SAR"],
    
    "dq:quality": [{
      "scope": {"level": "dataset"},
      "report": [
        {
          "type": "AbsoluteExternalPositionalAccuracy",
          "measure": {
            "measureIdentification": {
              "code": "28",
              "authority": {"title": "ISO 19157-1:2023"},
              "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/"
            },
            "nameOfMeasure": ["Mean value of positional uncertainties"],
            "measureDescription": "RMSE with ground control points"
          },
          "evaluationMethod": [{
            "type": "DirectExternal",
            "evaluationMethodDescription": "Comparison with 50 ground control points"
          }],
          "result": [{
            "type": "QuantitativeResult",
            "value": [3.2],
            "valueUnit": "meter",
            "errorStatistic": "RMSE"
          }]
        }
      ]
    }],
    
    "liability:responsible_party": "European Space Agency",
    "liability:security_classification": "public",
    "liability:prov": {
      "entity": {
        "e1": {
          "prov:id": "sar-scene-raw",
          "prov:type": "RawSARData",
          "prov:wasGeneratedBy": "acquisition-2025-01-15"
        },
        "e2": {
          "prov:id": "sar-scene-processed",
          "prov:type": "ProcessedSARData",
          "prov:wasGeneratedBy": "sar-processing",
          "prov:wasDerivedFrom": "sar-scene-raw"
        }
      },
      "activity": {
        "acquisition-2025-01-15": {
          "prov:id": "acquisition-2025-01-15",
          "prov:type": "SatelliteAcquisition",
          "prov:startTime": "2025-01-15T06:30:00Z",
          "prov:endTime": "2025-01-15T06:32:00Z"
        },
        "sar-processing": {
          "prov:id": "sar-processing",
          "prov:type": "SARProcessing",
          "prov:used": ["sar-scene-raw"],
          "prov:wasAssociatedWith": "esa-processing-center"
        }
      },
      "agent": {
        "esa-processing-center": {
          "prov:id": "esa-processing-center",
          "prov:type": "prov:Organization",
          "prov:label": "ESA Ground Segment Processing Center"
        }
      }
    }
  },
  "assets": {
    "data": {
      "href": "sar-data.tiff",
      "type": "image/tiff; application=geotiff",
      "roles": ["data"],
      "liability:security_classification": "public"
    },
    "quality-report": {
      "href": "quality-assessment.pdf",
      "type": "application/pdf",
      "roles": ["metadata"],
      "liability:security_classification": "internal",
      "liability:access_restrictions": ["internal_use_only"]
    }
  }
}
```

### B.2 Environmental Claim with Legal Holds

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://xxx.github.io/dq/v0.1.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "ENVIRONMENTAL-CLAIM-2025-047",
  "geometry": {...},
  "properties": {
    "datetime": "2025-01-10T00:00:00Z",
    
    "dq:quality": [{
      "scope": {"level": "dataset"},
      "report": [
        {
          "type": "FormatConsistency",
          "measure": {
            "measureIdentification": {"code": "211", "codeSpace": "ISO 19157"}
          },
          "result": [{"type": "QuantitativeResult", "value": [0], "valueUnit": "%"}]
        }
      ]
    }],
    
    "liability:claim_id": "ENV-2025-047",
    "liability:claim_status": "under_investigation",
    "liability:claim_type": "environmental",
    "liability:claim_date": "2025-01-11T09:00:00Z",
    "liability:incident_date": "2025-01-10T14:30:00Z",
    "liability:responsible_party": "Industrial Facility XYZ",
    "liability:affected_parties": [
      {
        "name": "Local Environmental Agency",
        "role": "claimant",
        "contact": "claims@env-agency.gov"
      }
    ],
    "liability:damages_estimated": 250000,
    "liability:damages_currency": "USD",
    "liability:legal_jurisdiction": "US Federal Court, District of Oregon",
    "liability:evidence_refs": [
      "evidence-photos",
      "water-sample-results"
    ]
  },
  "assets": {
    "evidence-photos": {
      "href": "photos.zip",
      "type": "application/zip",
      "roles": ["data"],
      "liability:security_classification": "confidential",
      "liability:access_restrictions": ["legal_hold", "court_order"],
      "liability:required_roles": ["legal_team", "court_appointed_expert"]
    },
    "water-sample-results": {
      "href": "lab-results.pdf",
      "type": "application/pdf",
      "roles": ["metadata"],
      "liability:security_classification": "confidential",
      "liability:access_restrictions": ["legal_hold"]
    }
  }
}
```

---

**Document End**

*For questions or feedback, contact the STAC Liability and Claims Extension maintainers or OGC Testbed-21 DQ4IPT team.*
