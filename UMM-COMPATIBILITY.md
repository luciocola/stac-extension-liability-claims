# NASA UMM Compatibility Assessment

## Overview

This document analyzes the compatibility between the STAC Liability and Claims Extension and NASA's Unified Metadata Model (UMM), particularly UMM-C (Collections) and UMM-G (Granules).

## What is UMM?

NASA's Unified Metadata Model (UMM) is a metadata framework used by the Common Metadata Repository (CMR) to provide interoperability between different metadata standards including:
- ISO 19115-1 and ISO 19115-2
- GCMD DIF10
- ECHO 10
- Other NASA metadata standards

## Compatibility Status: ✅ HIGH COMPATIBILITY

### Key Findings

#### 1. **ISO 19115 Foundation** ✅ COMPATIBLE
- **UMM**: Maps to ISO 19115-1 and ISO 19115-2 for collections
- **This Extension**: Implements ISO 19115, ISO 19115-4, and DGIWG quality elements
- **Result**: Direct compatibility through shared ISO 19115 foundation

#### 2. **Data Quality Metadata** ✅ COMPATIBLE

**UMM Quality Elements** (from ISO 19115 mapping):
- Completeness
- Logical Consistency
- Positional Accuracy
- Temporal Quality
- Thematic Accuracy

**This Extension Quality Elements**:
- ✅ All UMM/ISO 19115 core elements supported
- ✅ Additional ISO 19115-4 imagery elements (radiometric accuracy, sensor quality, cloud coverage)
- ✅ Additional DGIWG elements for defence/geospatial data

**Conclusion**: This extension is a **superset** of UMM quality capabilities.

#### 3. **Metadata Structure** ✅ COMPATIBLE

Both use hierarchical JSON/XML structures with:
- Collection-level metadata
- Granule/Item-level metadata
- Extensible schema design
- Support for additional properties

#### 4. **Geospatial Coverage** ✅ COMPATIBLE

- **UMM**: Uses ISO 19115 spatial extent (bounding boxes, polygons)
- **This Extension**: Uses GeoJSON geometries (STAC standard)
- **Interoperability**: Direct conversion possible between formats

## Integration Opportunities

### 1. **STAC ↔ UMM-C Crosswalk**

A STAC Collection using this extension can map to UMM-C:

| STAC Liability Extension | UMM-C Field |
|--------------------------|-------------|
| `liability:quality` → elements[type=completeness] | `DataQuality/CompletionStatus` |
| `liability:quality` → elements[type=positionalAccuracy] | `SpatialExtent/HorizontalSpatialDomain/Geometry/...` quality |
| `liability:quality` → elements[type=lineage] | `DataQuality/Lineage/Sources` |
| `liability:incident_date` | `TemporalExtent/...` |
| `liability:origin` | `DataCenters`, `ContactGroups` |
| `liability:coverage_area` | `SpatialExtent/HorizontalSpatialDomain` |

### 2. **Quality Reporting Harmonization**

The `liability:quality` field structure aligns with UMM's ISO 19115-based quality reporting:

```json
{
  "liability:quality": {
    "reportId": "...",
    "scope": "dataset",
    "elements": [
      {
        "elementType": "completeness",
        "detail": { ... }
      }
    ]
  }
}
```

This maps directly to UMM-C's `DataQuality` section.

### 3. **CMR Ingestion Pathway**

**Recommended Approach**:
1. STAC Collection/Item with Liability Extension
2. Convert to UMM-C/UMM-G using crosswalk
3. Ingest into NASA CMR
4. Quality elements preserved through ISO 19115 mapping

## Compatibility Matrix

| Feature | UMM-C 1.18.4 | UMM-G 1.6.6 | STAC Liability Extension | Compatible? |
|---------|--------------|-------------|--------------------------|-------------|
| ISO 19115 Quality | ✅ | ✅ | ✅ | ✅ Yes |
| Spatial Coverage | ✅ | ✅ | ✅ (GeoJSON) | ✅ Yes (convertible) |
| Temporal Info | ✅ | ✅ | ✅ | ✅ Yes |
| Data Lineage | ✅ | ✅ | ✅ | ✅ Yes |
| Processing Level | ✅ | ✅ | ✅ (ISO 19115-4) | ✅ Yes |
| Sensor Quality | ❌ | ❌ | ✅ (ISO 19115-4) | ⚠️ Extension adds value |
| Cloud Coverage | ✅ | ✅ | ✅ (ISO 19115-4) | ✅ Yes |
| DGIWG Quality | ❌ | ❌ | ✅ | ⚠️ Extension adds value |
| Liability Claims | ❌ | ❌ | ✅ | ⚠️ Extension-specific |

## Recommendations

### For NASA CMR Integration

1. **Create UMM-C Mapping Document**: Define explicit field mappings between STAC Liability Extension and UMM-C
2. **Quality Element Crosswalk**: Map `liability:quality` ISO 19115 elements to UMM-C `DataQuality` structure
3. **Extension Registry**: Register this STAC extension with NASA EOSDIS as a supported metadata format
4. **Validation Tools**: Develop conversion/validation tools for STAC→UMM-C translation

### For This Extension

1. **✅ Current State**: ISO 19115 foundation ensures high UMM compatibility
2. **Enhancement**: Add explicit UMM-C mapping examples in documentation
3. **Tooling**: Create reference implementation for STAC↔UMM conversion
4. **Testing**: Validate against CMR ingestion workflow

## Conclusion

**Compatibility Rating: ⭐⭐⭐⭐⭐ (5/5)**

The STAC Liability and Claims Extension is **highly compatible** with NASA's UMM due to:

1. ✅ Shared ISO 19115 foundation
2. ✅ Compatible quality metadata structures
3. ✅ Convertible spatial/temporal representations
4. ✅ Extensible design supporting additional UMM elements
5. ✅ Superset of UMM quality capabilities (adds ISO 19115-4 and DGIWG)

**Key Advantage**: This extension can serve as a bridge between STAC catalogs and NASA CMR, enabling:
- STAC-native metadata authoring
- Automatic conversion to UMM-C/UMM-G
- Preservation of quality information
- Enhanced imagery/defence geospatial metadata (beyond standard UMM)

## References

- [NASA UMM Documentation](https://wiki.earthdata.nasa.gov/display/CMR/UMM+Documents)
- [UMM-C Schema (v1.18.4)](https://git.earthdata.nasa.gov/projects/EMFD/repos/unified-metadata-model/)
- [ISO 19115-1:2014](https://www.iso.org/standard/53798.html)
- [ISO 19115-2:2019](https://www.iso.org/standard/67039.html)
- [STAC Specification](https://stacspec.org/)

---

*Assessment Date: 2025-11-27*  
*UMM Version Analyzed: UMM-C 1.18.4, UMM-G 1.6.6*  
*Extension Version: v1.0.0*
