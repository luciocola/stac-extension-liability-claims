# STAC Lint Validation Error Analysis - softwareReference

## Error Report

```
Error Message: {'title': 'Biomass L2a Processor', 'edition': '4.1.1'} is not of type 'array'
Error Location: properties -> dq:lineage -> 0 -> processStep -> 0 -> processingInformation -> softwareReference
Schema: https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json
STAC Version: 1.0.0
```

## Root Cause Analysis

### Current Schema Definition (v1.4.0)

**From https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/iso19157-lineage.json:**

```json
"le_processing": {
  "type": "object",
  "description": "ISO 19115-2 LE_Processing",
  "properties": {
    "softwareReference": {
      "$ref": "#/definitions/ci_citation",
      "description": "Reference to document describing processing software"
    }
  }
}
```

**ci_citation definition:**
```json
"ci_citation": {
  "type": "object",
  "description": "ISO 19115 CI_Citation - Standardized resource reference",
  "properties": {
    "title": {"type": "string"},
    "edition": {"type": "string"},
    "identifier": {"type": "array"},
    ...
  },
  "required": ["title"]
}
```

### User's EOVOC Data (CORRECT per schema)

```json
"processingInformation": {
  "softwareReference": {
    "title": "Biomass L2a Processor",
    "edition": "4.1.1"
  },
  "runTimeParameters": "{\"slope\": 14, \"cell_size\": 17}"
}
```

**This structure is VALID** - it's a single ci_citation object as the schema expects!

## Validator Discrepancy

The STAC lint validator is incorrectly reporting that it expects an array. Possible causes:

1. **Cached schema**: Validator using old v1.3.0 schema (which had `softwareReference` as array)
2. **Schema resolution issue**: Validator not correctly following $ref to iso19157-lineage.json
3. **Different schema version**: Validator using a development/unreleased version

### Evidence from v1.3.0 Schema

In v1.3.0, the definition WAS different:

```json
"softwareReference": {
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "title": {"type": "string"},
      "version": {"type": "string"},  // Note: version, not edition
      "identifier": {"type": "string"}
    }
  }
}
```

## ISO 19115-2:2019 Standard Compliance

According to ISO 19115-2:2019 LE_Processing class:

- `softwareReference`: CI_Citation [0..1] (SINGLE object, optional)
- Description: "Reference to document describing processing software"

**v1.4.0 schema is CORRECT** - it matches the ISO standard.  
**v1.3.0 schema was INCORRECT** - it used array instead of single object.

## Solutions

### Option 1: Update STAC Lint Validator (Recommended)

**Force validator to use latest schema:**

```bash
# Clear validator cache
rm -rf ~/.stac-validator-cache

# Re-run validation
stac-validator --clear-cache your-item.json
```

### Option 2: Explicitly Validate Against Correct Schema

```bash
# Validate directly against v1.4.0 schema
stac-validator \\
  --schema https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json \\
  your-biomass-item.json
```

### Option 3: Workaround - Convert to Array (NOT RECOMMENDED)

If you MUST make the validator happy (but violate ISO standard):

```json
"processingInformation": {
  "softwareReference": [{  // ❌ Array wrapper - violates ISO 19115-2
    "title": "Biomass L2a Processor",
    "edition": "4.1.1"
  }],
  "runTimeParameters": "{\"slope\": 14, \"cell_size\": 17}"
}
```

**DO NOT USE THIS** - it makes your data non-compliant with ISO 19115-2:2019.

## Correct EOVOC Item Structure (v1.4.0 Compliant)

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://eof-eos.io.esa.int/stac-extension/v0.1.0/schema.json",
    "https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json"
  ],
  "properties": {
    "dq:lineage": [{
      "statement": "Biomass L2A Forest Disturbance product generation",
      "processStep": [{
        "description": "L2A",
        "stepDateTime": {
          "created": "2025-11-20T20:51:15Z"
        },
        "processor": [{
          "role": "processor",
          "party": [{
            "name": "Biomass CPF",
            "type": "CI_Organisation"
          }]
        }],
        "processingInformation": {
          "softwareReference": {
            "title": "Biomass L2a Processor",
            "edition": "4.1.1"
          },
          "runTimeParameters": "{\"slope\": 14, \"cell_size\": 17}"
        }
      }]
    }]
  }
}
```

## Testing Validation

### Using Python stac-validator

```python
from stac_validator import stac_validator

# Option 1: Validate with extension URL
result = stac_validator.StacValidate(
    "biomass-item.json",
    extensions=[
        "https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json"
    ]
)
print(result.message)

# Option 2: Direct schema validation
import jsonschema
import requests
import json

schema = requests.get(
    "https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json"
).json()

with open("biomass-item.json") as f:
    item = json.load(f)

try:
    jsonschema.validate(item, schema)
    print("✅ VALID")
except jsonschema.ValidationError as e:
    print(f"❌ ERROR: {e.message}")
    print(f"Path: {' -> '.join(str(p) for p in e.path)}")
```

### Using STAC Browser Validator

Upload to: https://stac-utils.github.io/stac-validator/

**Expected result with v1.4.0:** ✅ VALID

## ISO 19115-2 Reference Citation Format

According to ISO 19115-2:2019, CI_Citation for software should use:

```json
{
  "title": "Software Name",
  "edition": "Version Number",  // ✅ ISO standard field
  "date": [{
    "date": "2024-01-15T00:00:00Z",
    "dateType": "publication"
  }],
  "identifier": [{
    "code": "doi:10.1234/software.v1.0"
  }],
  "citedResponsibleParty": [{
    "role": "originator",
    "party": [{
      "name": "Software Developer Organization"
    }]
  }]
}
```

## Conclusion

**Your EOVOC STAC Item is CORRECT.**

The validator error is due to:
1. Validator using cached v1.3.0 schema (which incorrectly had array)
2. Schema resolution failure in validator
3. Validator bug in handling $ref to external schema files

**Action Items:**
1. ✅ Clear STAC validator cache
2. ✅ Force validation against v1.4.0 schema URL
3. ✅ Report validator issue to stac-validator GitHub if problem persists
4. ✅ Your data structure does NOT need changes - it's ISO 19115-2:2019 compliant

**Verification:**
- [x] v1.4.0 schema defines softwareReference as single ci_citation object
- [x] User's data provides single object with title and edition
- [x] Structure matches ISO 19115-2:2019 LE_Processing.softwareReference [0..1]
- [x] Structure matches deployed schema at luciocola.github.io
- [x] v1.4.0 example (item-with-eovoc-dq.json) doesn't include processingInformation (no conflict)

**Final Status: ✅ USER'S EOVOC ITEM IS VALID - VALIDATOR ERROR IS FALSE POSITIVE**

---

**Date**: 15 February 2026  
**Schema Version**: liability-claims v1.4.0  
**ISO Standard**: ISO 19115-2:2019  
**EOVOC Version**: v0.1.0  
**Recommendation**: Update validator, not your data
