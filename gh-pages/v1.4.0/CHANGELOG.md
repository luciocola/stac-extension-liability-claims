# Changelog - v1.4.0

**Release Date:** February 13, 2026

## Breaking Changes

### ISO 19115-2 Lineage Compliance

**Changed:** `le_process_step.dateTime` → `le_process_step.stepDateTime`

To align with ISO 19115-2:2019 and EOVOC v0.0.2 schemas, the `dateTime` property in process steps has been renamed to `stepDateTime` and changed from a simple string to a `CI_Date` object.

**Migration Required:**

```json
// v1.3.0 (deprecated)
{
  "description": "Atmospheric correction",
  "dateTime": "2025-02-13T14:30:00Z"
}

// v1.4.0 (current)
{
  "description": "Atmospheric correction",
  "stepDateTime": {
    "processing": "2025-02-13T14:30:00Z"
  }
}
```

### New `ci_date` Definition

Added proper ISO 19115 `CI_Date` structure supporting multiple date formats:
- Full datetime: `{"creation": "2025-02-13T10:30:00Z"}`
- Date only: `{"publication": "2025-02-13"}`
- Year-month: `{"revision": "2025-02"}`
- Year only: `{"vintage": "2025"}`

Supported date type codes (ISO 19115 CI_DateTypeCode):
- `creation`, `publication`, `revision`, `expiry`, `lastUpdate`, `lastRevision`
- `nextUpdate`, `unavailable`, `inForce`, `adopted`, `deprecated`, `superseded`
- `validityBegins`, `validityExpires`, `released`, `distribution`

## Fixes

### ✅ EOVOC v0.0.2 Schema Alignment

- **Fixed**: `stepDateTime` now correctly references `CI_Date` object (was string)
- **Verified**: `softwareReference` remains single `CI_Citation` (not array) ✅
- **Verified**: `algorithm` remains array of `LE_Algorithm` objects ✅

### ✅ ISO Standard Compliance

Full alignment with:
- ISO 19115-1:2014 (Geographic information — Metadata — Part 1: Fundamentals)
- ISO 19115-2:2019 (Geographic information — Metadata — Part 2: Extensions for acquisition and processing)
- ISO 19157-1:2023 (Geographic information — Data quality)

## Validation

Schema validated against:
- EOVOC v0.0.2 dqc.json
- EOVOC v0.0.2 mdj.json
- Official ISO 19115-2 XML schemas

## Migration Guide

### For v1.3.0 Users

**Step 1: Update schema reference**
```json
"stac_extensions": [
  "https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json"
]
```

**Step 2: Convert dateTime to stepDateTime**

If using simple datetime strings:
```python
# Python migration example
old_step = {
    "description": "Processing step",
    "dateTime": "2025-02-13T14:30:00Z"
}

new_step = {
    "description": "Processing step",
    "stepDateTime": {
        "processing": old_step["dateTime"]
    }
}
```

**Step 3: Test with validator**
```bash
python gh-pages/v1.4.0/validate_example.py your-item.json
```

## Backward Compatibility

⚠️ **v1.4.0 is NOT backward compatible with v1.3.0**

Items using v1.3.0 `dateTime` will fail validation against v1.4.0 schemas.

**Upgrade path:**
1. Keep v1.3.0 items on v1.3.0 schema (still supported)
2. Migrate to v1.4.0 using above guide when ready
3. Update all references to use `stepDateTime` with `ci_date` structure

## Dependencies

- STAC 1.0.0
- JSON Schema draft-07
- EOVOC v0.0.2 (compatible)

## Documentation

- Full alignment details: `EOVOC_ISO_SCHEMA_ALIGNMENT.md`
- EOVOC compatibility: `EOVOC_COMPATIBILITY_VALIDATION.md`
- Schema: `schema.json`
- Lineage schema: `iso19157-lineage.json`

## Contributors

- EOVOC ISO schema alignment validation
- ISO 19115-2:2019 standard compliance review

---

**Previous Version:** [v1.3.0](../v1.3.0/README.md)  
**Full Changelog:** [CHANGELOG.md](../../CHANGELOG.md)
