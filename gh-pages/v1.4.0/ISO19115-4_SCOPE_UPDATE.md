# v1.4.0 Schema Update - ISO 19115-4 Scope Compliance

**Date:** February 19, 2026  
**Version:** 1.4.0 (updated)  
**Change Type:** Enhancement - Backward Compatible

## Summary

Modified the v1.4.0 schema to accept **both** string and object formats for the `scope` field in quality reports, ensuring full ISO 19115-4 compliance while maintaining backward compatibility.

## Changes

### 1. `iso19115_quality_report` Definition

**Before:**
```json
"scope": { 
  "type": "string", 
  "description": "Scope of the report (e.g., dataset, series, feature)" 
}
```

**After:**
```json
"scope": { 
  "oneOf": [
    {
      "type": "string", 
      "description": "Simple scope string (e.g., dataset, series, feature)"
    },
    {
      "type": "object",
      "description": "ISO 19115-4 compliant scope object with level and optional extent",
      "properties": {
        "level": { 
          "type": "string", 
          "enum": ["dataset", "series", "feature", "attribute", "featureType", "propertyType", "fieldSession", "software", "service", "model", "tile", "metadata", "initiative", "sample", "document", "repository", "aggregate", "product", "collection", "coverage", "application"]
        },
        "extent": { "type": "object" },
        "levelDescription": { "type": "string" }
      },
      "required": ["level"]
    }
  ]
}
```

### 2. `iso19115_completeness` Definition

Similar update to accept both string and object formats for consistency.

## Supported Formats

### Format 1: Simple String (Backward Compatible)
```json
{
  "dq:quality": [{
    "scope": "series",
    "report": [...]
  }]
}
```

### Format 2: ISO 19115-4 Object (New Support)
```json
{
  "dq:quality": [{
    "scope": {
      "level": "series",
      "extent": {...},
      "levelDescription": "Time series data collection"
    },
    "report": [...]
  }]
}
```

## Benefits

1. **ISO 19115-4 Compliance**: Fully aligns with ISO 19115-4:2021 metadata standards
2. **EOVOC Compatibility**: Matches EOVOC v0.0.2 eof-eos-stac-extension expectations
3. **Backward Compatibility**: Existing items using string format remain valid
4. **Extended Metadata**: Object format supports spatial extent and level descriptions

## Valid Scope Levels

The `level` field accepts the following ISO 19115-1 MD_ScopeCode values:

- `dataset` - Dataset level
- `series` - Dataset series level
- `feature` - Feature level
- `attribute` - Attribute level
- `featureType` - Feature type level
- `propertyType` - Property type level
- `fieldSession` - Field session level
- `software` - Software level
- `service` - Service level
- `model` - Model level
- `tile` - Tile level
- `metadata` - Metadata level
- `initiative` - Initiative level
- `sample` - Sample level
- `document` - Document level
- `repository` - Repository level
- `aggregate` - Aggregate level
- `product` - Product level
- `collection` - Collection level
- `coverage` - Coverage level
- `application` - Application level

## Migration

No migration needed! Both formats are now valid:

### Existing Items (Continue to Work)
```json
"scope": "series"
```

### New Items (Can Use Either)
```json
// Option 1: Simple
"scope": "dataset"

// Option 2: Rich
"scope": {
  "level": "dataset",
  "extent": {
    "type": "Polygon",
    "coordinates": [...]
  },
  "levelDescription": "Regional dataset covering Europe"
}
```

## Testing

Example file demonstrating both formats: [`iso19115-4-scope-example.json`](examples/iso19115-4-scope-example.json)

## References

- **ISO 19115-1:2014** - Metadata — Part 1: Fundamentals
- **ISO 19115-4:2021** - Metadata — Part 4: Service metadata
- **EOVOC v0.0.2** - ESA Earth Observation Vocabulary
- **MD_ScopeCode** - ISO 19115-1 code list B.5.25

---

**Updated by:** GitHub Copilot  
**Review Status:** Schema tested with both formats  
**Backward Compatibility:** ✅ 100% maintained
