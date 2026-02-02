# ISO TC211 Official Schema Alignment

**Version:** 1.2.0  
**Date:** February 2, 2026  
**Status:** In Progress

## Overview

This document describes the alignment of the STAC Liability and Claims Extension v1.2.0 with the official ISO TC211 JSON schemas, particularly for ISO 19157 Data Quality structures.

## Official ISO TC211 Schema Reference

**Primary Schema:** https://github.com/ISO-TC211/XML/blob/master/schemas.isotc211.org/json/19157/-1/dqc/1.0.0/dqc.json

**Related Schemas:**
- ISO 19115-4 Metadata: https://schemas.isotc211.org/json/19115/-4/mdj/1.0.0/mdj.json
- ISO 19157-1 Data Quality: https://schemas.isotc211.org/json/19157/-1/dqc/1.0.0/dqc.json

## Key Differences: v1.1.0 vs ISO TC211 Official

### 1. Schema Version
| Aspect | v1.1.0 | ISO TC211 Official | v1.2.0 Target |
|--------|--------|-------------------|---------------|
| JSON Schema | Draft-07 | Draft 2020-12 | Draft-07 (maintain STAC compatibility) |
| Type Discriminator | `resultType` | `type` | Support both |

### 2. ConformanceResult Structure

**v1.1.0 (Current):**
```json
{
  "resultType": "conformance",
  "pass": true,
  "specification": {
    "title": "CEOS-ARD NRB"
  },
  "explanation": "This collection is conformant..."
}
```

**ISO TC211 Official:**
```json
{
  "type": "ConformanceResult",
  "pass": true,
  "specification": {
    "$ref": "CI_Citation"
  },
  "explanation": "This collection is conformant..."
}
```

**v1.2.0 (Hybrid - Accepts Both):**
```json
{
  "type": "ConformanceResult",  // or "resultType": "conformance"
  "pass": true,
  "specification": {
    "title": "CEOS-ARD NRB",
    "date": "2022-06-15T00:00:00Z",
    "identifier": "CARD4L-PFS-NRB-v1.2"
  },
  "explanation": "This collection is conformant..."
}
```

### 3. Quality Element Type Field

| v1.1.0 | ISO TC211 | v1.2.0 Support |
|--------|-----------|----------------|
| No `type` field required | `"type": "AbsolutePositionalAccuracy"` required | Optional in properties, recommended |
| Category-based: `"category": "positionalAccuracy"` | Type-based discriminator | Support both approaches |

### 4. Citation References

**v1.1.0:** Inline citation objects
```json
"specification": {
  "title": "...",
  "date": "...",
  "uri": "..."
}
```

**ISO TC211:** References to CI_Citation schema
```json
"specification": {
  "$ref": "https://schemas.isotc211.org/json/19115/-4/mdj/1.0.0/mdj.json#CI_Citation"
}
```

**v1.2.0:** Accept both inline and structured CI_Citation format

## Migration Path

### For Users of v1.1.0

**Your existing items will continue to work in v1.2.0.** No changes required.

**Optional enhancements for v1.2.0:**

1. **Add type discriminators** (recommended for ISO TC211 compatibility):
   ```json
   {
     "category": "positionalAccuracy",
     "type": "AbsolutePositionalAccuracy",  // ADD THIS
     "subcategory": "absoluteExternalPositionalAccuracy",
     // ... rest of fields
   }
   ```

2. **Use structured citations** for better interoperability:
   ```json
   "specification": {
     "title": "CEOS-ARD NRB",
     "date": "2022-06-15T00:00:00Z",
     "dateType": "publication",
     "identifier": "CARD4L-PFS-NRB-v1.2",
     "uri": "https://ceos.org/ard/files/PFS/NRB/v1.2/..."
   }
   ```

3. **Add resultType to ConformanceResult** (if not already present):
   ```json
   {
     "type": "ConformanceResult",        // ISO TC211 style
     "resultType": "conformance",        // STAC extension style (backward compat)
     "pass": true,
     "specification": {...}
   }
   ```

### Example: NovaSAR Collection Migration

**v1.1.0 Format (Still Valid in v1.2.0):**
```json
{
  "liability:quality": {
    "scope": {"level": "series"},
    "report": [{
      "category": "completeness",
      "result": [{
        "resultType": "conformance",
        "pass": true,
        "specification": {
          "title": "CEOS-ARD NRB"
        },
        "explanation": "This collection is conformant..."
      }]
    }]
  }
}
```

**v1.2.0 Enhanced (ISO TC211 Aligned):**
```json
{
  "liability:quality": {
    "scope": {"level": "series"},
    "report": [{
      "type": "Commission",
      "category": "completeness",
      "measure": {
        "measureIdentification": {
          "code": "7",
          "codeSpace": "https://standards.isotc211.org/19157/-3/1/dqc/content/qualityMeasure/"
        },
        "nameOfMeasure": ["Rate of missing items"]
      },
      "result": [{
        "type": "ConformanceResult",
        "resultType": "conformance",
        "pass": true,
        "specification": {
          "title": "CEOS-ARD Normalized Radar Backscatter",
          "date": "2022-06-15T00:00:00Z",
          "dateType": "publication",
          "identifier": "CARD4L-PFS-NRB-v1.2",
          "uri": "https://ceos.org/ard/files/PFS/NRB/v1.2/CARD4L-PFS_Normalised_Radar_Backscatter-v1.2.pdf"
        },
        "explanation": "This collection is conformant with the CEOS ARD NRB Specification"
      }]
    }]
  }
}
```

## Backward Compatibility Strategy

### v1.2.0 Schema Will:

✅ **Accept** v1.1.0 style (category-based, resultType discriminator)  
✅ **Accept** ISO TC211 style (type-based discriminator)  
✅ **Accept** both inline citations and structured CI_Citation  
✅ **Recommend** ISO TC211 alignment for new implementations  
✅ **Validate** both formats without errors

### What's Optional in v1.2.0:

- `type` field in quality elements (can use `category` instead)
- Full CI_Citation structure (can use simplified inline)
- `measure` field (can provide results without explicit measure reference)

### What's Required in v1.2.0:

Same as v1.1.0:
- `scope.level`
- `category` (if not using `type`)
- `result` array with at least one result
- For ConformanceResult: `pass` and `specification.title`

## Implementation Status

| Feature | Status | Notes |
|---------|--------|-------|
| Backward compatibility with v1.1.0 | ✅ Complete | All v1.1.0 items validate |
| Accept `type` discriminators | 🔄 In Progress | Schema updates needed |
| Accept ISO TC211 CI_Citation | 🔄 In Progress | Schema updates needed |
| Dual discriminator support | 🔄 In Progress | Both `type` and `category` |
| Migration examples | ✅ Complete | This document |
| Validation tests | ⏳ Pending | After schema updates |

## Next Steps

1. **Update json-schema/iso19157-quality.json**
   - Add `type` field as optional alternative to `category`
   - Support ISO TC211 type names (AbsolutePositionalAccuracy, etc.)
   - Accept both discriminator styles

2. **Update examples**
   - Add ISO TC211 aligned example
   - Keep v1.1.0 style examples for backward compatibility
   - Add migration example

3. **Create validation tests**
   - Test v1.1.0 format validates in v1.2.0
   - Test ISO TC211 format validates in v1.2.0
   - Test hybrid format validates

4. **Documentation updates**
   - Update README with ISO TC211 alignment notes
   - Add best practices guide
   - Update CHANGELOG

## References

- **ISO TC211 GitHub Repository:** https://github.com/ISO-TC211/XML
- **ISO 19157-1:2023 Standard:** https://www.iso.org/standard/78900.html
- **STAC Specification:** https://stacspec.org/
- **OGC Building Blocks:** https://github.com/ogcincubator/bblocks-stac

## Contact

For questions about ISO TC211 alignment:
- GitHub Issues: https://github.com/luciocola/stac-extension-liability-claims/issues
- ISO TC211 XML Working Group: https://github.com/ISO-TC211/XML/discussions
