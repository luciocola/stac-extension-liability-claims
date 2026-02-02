# CEOS-ARD Integration Plan - v1.2.0

## Executive Summary

Integration of CEOS-ARD extension into liability-claims v1.2.0 to address OGC T21-DQ4IPT recommendations for Analysis Ready Data (ARD) quality certification.

## Rationale

From OGC T21-DQ4IPT Engineering Report (Section 3.2.2):
> "A critical area for future work is the maturation of the STAC Extension for CEOS Analysis Ready Data (ARD). While an initial proposal exists... it remains in a 'Proposal' state and is currently insufficient for operational certification."

**Benefits:**
1. Enables ARD certification queries: *"Find imagery where geometric_accuracy ≤ 10m"*
2. Provides standardized quality thresholds (Threshold/Goal/Target levels)
3. Aligns with CEOS-ARD Product Family Specifications (PFS)
4. Supports both optical (SR, ST, AR, NLSR) and radar (NRB, POL, ORB, GSLC) sensors
5. Maintains full backward compatibility with existing v1.1.0 metadata

## Integration Approach

### Option 1: Parallel Extensions (RECOMMENDED)
- **Implementation:** Add `ceosard:*` fields alongside `liability:*` fields
- **Schema:** Reference CEOS-ARD schema as optional extension
- **Backward Compatibility:** ✅ Perfect - no breaking changes
- **Use Case:** Items can declare both extensions simultaneously

### Option 2: Embedded Extension
- **Implementation:** Include CEOS-ARD fields within `liability:quality`
- **Schema:** Merge schemas into single structure
- **Backward Compatibility:** ⚠️ Requires careful versioning
- **Use Case:** Tighter integration but more complex

**Decision:** Option 1 - Parallel Extensions

## Schema Changes for v1.2.0

### 1. Update Extension Declaration

Add CEOS-ARD as optional co-extension:

```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/json-schema/schema.json",
    "https://stac-extensions.github.io/ceos-ard/v0.2.0/schema.json"
  ]
}
```

### 2. New Fields (Optional)

No new `liability:*` fields required. CEOS-ARD fields use `ceosard:*` prefix:

- `ceosard:type` - "optical" or "radar"
- `ceosard:specification` - "SR", "ST", "AR", "NLSR", "NRB", "POL", "ORB", "GSLC"
- `ceosard:specification_version` - e.g., "5.0.1", "1.2"

### 3. Quality Report Enhancements

Map CEOS-ARD requirements to ISO 19157 quality categories:

| CEOS-ARD Requirement | ISO 19157 Category | Mapping |
|---------------------|-------------------|---------|
| 1.8 Geometric Accuracy | `positionalAccuracy` | Direct |
| 1.12 Radiometric Uncertainty | `thematicAccuracy` | Via `radiometricAccuracy` |
| 2.x Per-pixel Quality | `completeness` | Via classification assets |
| 3.x Processing Levels | `lineage` | Via processStep |

### 4. Asset Role Mappings

CEOS-ARD roles compatible with liability-claims:

| CEOS-ARD Role | Liability-Claims Use | ISO 19157 Relation |
|---------------|---------------------|-------------------|
| `cloud` | `metadata` + classification | Completeness assessment |
| `cloud-shadow` | `metadata` + classification | Completeness assessment |
| `data` | `data` | Primary asset |
| `saturation` | `metadata` | Quality flag |
| `incomplete-testing` | `metadata` | Metaquality indicator |

## Example Integration

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/json-schema/schema.json",
    "https://stac-extensions.github.io/ceos-ard/v0.2.0/schema.json",
    "https://stac-extensions.github.io/eo/v2.0.0/schema.json",
    "https://stac-extensions.github.io/projection/v2.0.0/schema.json"
  ],
  "type": "Feature",
  "id": "sentinel2-ard-example",
  "geometry": {...},
  "bbox": [...],
  "properties": {
    "datetime": "2025-06-15T10:30:00Z",
    
    "ceosard:type": "optical",
    "ceosard:specification": "SR",
    "ceosard:specification_version": "5.0.1",
    
    "liability:responsible_party": "ESA Copernicus Program",
    "liability:origin": "Sentinel-2 L2A Processing",
    
    "liability:quality": {
      "scope": {"level": "dataset"},
      "report": [
        {
          "category": "positionalAccuracy",
          "subcategory": "absoluteExternalPositionalAccuracy",
          "measure": {
            "measureIdentification": {
              "code": "28",
              "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/",
              "authority": "ISO 19157-3"
            },
            "nameOfMeasure": ["Mean value of positional uncertainties"],
            "measureDescription": "CEOS-ARD SR 5.0.1 Requirement 1.8 - Geometric Accuracy"
          },
          "evaluationMethod": {
            "type": "directExternal",
            "dateTime": "2025-06-15T12:00:00Z"
          },
          "result": {
            "type": "quantitativeResult",
            "value": [12.5],
            "valueUnit": "m",
            "valueRecordType": "Real"
          }
        },
        {
          "category": "completeness",
          "measure": {
            "measureIdentification": {
              "code": "7",
              "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/"
            },
            "nameOfMeasure": ["Rate of missing items"],
            "measureDescription": "CEOS-ARD SR 5.0.1 Requirement 2.4 - Cloud coverage percentage"
          },
          "evaluationMethod": {
            "type": "directInternal"
          },
          "result": {
            "type": "quantitativeResult",
            "value": [15.2],
            "valueUnit": "%",
            "valueRecordType": "Real"
          }
        }
      ]
    },
    
    "liability:prov": {
      "entity": {
        "source-l1c": {
          "prov:type": "Sentinel2L1C",
          "prov:label": "Sentinel-2A MSI L1C Source"
        },
        "ard-product": {
          "prov:type": "CEOS-ARD-SR",
          "prov:wasDerivedFrom": "source-l1c",
          "prov:wasGeneratedBy": "atmospheric-correction",
          "ceosard:specification": "SR",
          "ceosard:specification_version": "5.0.1"
        }
      },
      "activity": {
        "atmospheric-correction": {
          "prov:type": "AtmosphericCorrection",
          "prov:startTime": "2025-06-15T11:00:00Z",
          "prov:endTime": "2025-06-15T11:45:00Z",
          "prov:used": "source-l1c"
        }
      }
    }
  },
  "assets": {
    "visual": {
      "href": "./data.tif",
      "type": "image/tiff; application=geotiff; profile=cloud-optimized",
      "roles": ["data", "visual"],
      "eo:bands": [...]
    },
    "cloud": {
      "href": "./cloud_mask.tif",
      "type": "image/tiff; application=geotiff",
      "roles": ["cloud", "metadata"],
      "liability:security_classification": "public",
      "classification:classes": [
        {"value": 0, "name": "clear"},
        {"value": 1, "name": "cloud"}
      ]
    }
  },
  "links": [
    {
      "rel": "ceos-ard-specification",
      "href": "https://ceos.org/ard/files/PFS/SR/v5.0.1/CARD4L-PFS_Surface_Reflectance-v5.0.1.pdf",
      "type": "application/pdf",
      "title": "CEOS-ARD Surface Reflectance Specification v5.0.1"
    }
  ]
}
```

## Backward Compatibility Analysis

### ✅ Fully Compatible Changes

1. **Schema Version:** v1.1.0 → v1.2.0 (minor version bump)
2. **Existing Fields:** All `liability:*` fields unchanged
3. **Validation:** Existing v1.1.0 items validate against v1.2.0
4. **New Fields:** All CEOS-ARD fields are optional
5. **Extension Declaration:** CEOS-ARD extension is optional

### ⚠️ Potential Conflicts

**None identified.** CEOS-ARD and liability-claims use different namespaces.

### Migration Path

Existing v1.1.0 items require **zero changes**:

```json
// v1.1.0 item - still valid in v1.2.0
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/json-schema/schema.json"
  ],
  "properties": {
    "liability:claim_id": "CLM-2024-001",
    "liability:quality": {...}
  }
}
```

To enable ARD features, add CEOS-ARD extension:

```json
// v1.2.0 item with ARD
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/json-schema/schema.json",
    "https://stac-extensions.github.io/ceos-ard/v0.2.0/schema.json"
  ],
  "properties": {
    "liability:claim_id": "CLM-2024-001",
    "ceosard:type": "optical",
    "ceosard:specification": "SR",
    "ceosard:specification_version": "5.0.1",
    "liability:quality": {...}
  }
}
```

## Documentation Updates Required

1. **README.md:**
   - Add CEOS-ARD integration section
   - Document `ceosard:*` fields
   - Provide ARD quality mapping examples

2. **CHANGELOG.md:**
   - Document v1.2.0 release
   - List CEOS-ARD integration

3. **examples/:**
   - Create `item-with-ceos-ard-optical.json`
   - Create `item-with-ceos-ard-radar.json`
   - Update existing examples with ARD compatibility notes

4. **Best Practices Guide:**
   - CEOS-ARD + ISO 19157 mapping
   - Quality measure selection for ARD compliance
   - Asset role conventions

## Testing Strategy

### 1. Schema Validation
- Validate v1.1.0 examples against v1.2.0 schema ✅
- Validate new ARD examples against v1.2.0 schema
- Test with STAC Browser external validation

### 2. Compatibility Tests
```bash
# Validate backward compatibility
python validate.py examples/item-environmental.json
python validate.py examples/item-with-quality.json

# Validate new ARD examples
python validate.py examples/item-with-ceos-ard-optical.json
python validate.py examples/item-with-ceos-ard-radar.json
```

### 3. Cross-Extension Tests
- Test with EO extension
- Test with Projection extension
- Test with Processing extension
- Test with Raster extension

## Implementation Checklist

- [ ] Update schema.json to v1.2.0
- [ ] Add CEOS-ARD compatibility documentation
- [ ] Create ARD example items (optical + radar)
- [ ] Update CHANGELOG.md
- [ ] Update README.md with ARD section
- [ ] Validate all existing examples against v1.2.0
- [ ] Create ARD + ISO 19157 mapping guide
- [ ] Test with STAC Browser
- [ ] Update GitHub Pages documentation

## Future Enhancements (v1.3.0+)

Based on OGC T21-DQ4IPT recommendations:

1. **Semantic Lifting (v1.3.0):**
   - JSON-LD contexts for ARD compliance reasoning
   - Automated validation against CEOS thresholds
   - W3C Verifiable Credentials for ARD certification

2. **ML Quality Measures (v1.4.0):**
   - Training dataset quality for ARD-based ML
   - Class imbalance indicators
   - Label noise assessment

3. **Real-time Quality Monitoring (v2.0.0):**
   - Streaming quality assessment
   - Temporal quality degradation tracking
   - Alert thresholds based on ARD requirements

## References

- [CEOS-ARD Extension](https://github.com/stac-extensions/ceos-ard)
- [CEOS-ARD Specifications](https://ceos.org/ard/)
- [OGC T21-DQ4IPT Report](http://t21-dq4ipt-0586cf.pages.ogc.org/documents/D001/document.html)
- [ISO 19157-1:2023](https://www.iso.org/standard/78900.html)
- [STAC Specification v1.0.0](https://github.com/radiantearth/stac-spec)

---

**Version:** 1.0  
**Date:** 2026-01-30  
**Status:** Ready for Implementation
