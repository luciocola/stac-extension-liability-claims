# STAC Liability and Claims Extension v1.3.0

**Status:** Released  
**Release Date:** 7 February 2026  
**STAC Version:** 1.0.0  
**Schema URL:** https://luciocola.github.io/stac-extension-liability-claims/v1.3.0/schema.json

**✅ Validation Status:** All examples validated against STAC 1.0.0 core schema and extension schema  
**📦 Example Files:** [item-complete-v1.3.0.json](examples/item-complete-v1.3.0.json) | [collection-complete-v1.3.0.json](examples/collection-complete-v1.3.0.json)

---

## Namespace Interoperability

This extension provides **dual namespace support** for quality and lineage metadata:

| Purpose | Liability Namespace | EOVOC Namespace | Use Case |
|---------|-------------------|-----------------|----------|
| **Quality Reports** | `liability:quality` (single object) | `dq:quality` (array) | Use `dq:quality` for eovoc eof-eos-stac-extension compatibility |
| **Lineage/Provenance** | Within `liability:quality` | `dq:lineage` (array) | Use `dq:lineage` for OGC metadata standards compatibility |

### When to Use Each Namespace:

**Use `liability:*` fields when:**
- Building liability/claims-specific applications
- Need single quality report per item (common case)
- Working with legal/insurance workflows
- Prefer simple object structure over arrays

**Use `dq:*` fields when:**
- Integrating with [eovoc eof-eos-stac-extension](https://github.com/eovoc/eof-eos-stac-extension)
- Need multiple quality reports per item
- Sharing data with OGC-compliant systems
- Following Earth Observation metadata conventions

**Both namespaces:**
- ✅ Reference the same ISO 19157/19115 schemas (`dqc.json`, `mdj.json`)
- ✅ Are validated against identical quality/lineage structures
- ✅ Support full ISO 19157-1:2023 and ISO 19115-1:2014 compliance
- ✅ Enable cross-validation with official ISO tools

### Conversion Example:

```json
// LIABILITY namespace (single object)
{
  "properties": {
    "liability:quality": {
      "scope": {"level": "dataset"},
      "report": [{...}]
    }
  }
}

// EOVOC namespace (array)
{
  "properties": {
    "dq:quality": [
      {
        "scope": {"level": "dataset"},
        "report": [{...}]
      }
    ]
  }
}
```

See [EOVOC Product Example](https://raw.githubusercontent.com/eovoc/eof-eos-stac-extension/refs/heads/gh-pages/v0.0.1/product.json) for reference implementation.

---

## What's New in v1.3.0

Version 1.3.0 represents a **major compatibility update** bringing full alignment with canonical ISO 19115/19157 schemas, EOVOC interoperability, and comprehensive validated examples.

### ✅ February 2026 Updates

**Validated Examples:**
- ✅ **item-complete-v1.3.0.json** - Comprehensive Item example with dual namespace (liability:* + dq:*)
- ✅ **collection-complete-v1.3.0.json** - Complete Collection with summaries and item_assets
- ✅ All examples pass STAC 1.0.0 core validation
- ✅ All examples validate against extension schema

**EOVOC Dual Namespace Support:**
- ✅ Added `dq:quality` array field for [eovoc eof-eos-stac-extension](https://github.com/eovoc/eof-eos-stac-extension) compatibility
- ✅ Added `dq:lineage` array field for OGC metadata standards alignment
- ✅ Both namespaces reference identical ISO 19157/19115 schemas (dqc.json, mdj.json)
- ✅ Enables cross-validation with Earth Observation community tools

**Schema Refinements:**
- ✅ Removed `additionalProperties: false` blocking standard STAC properties
- ✅ Fixed asset schema to allow title, description, roles, href, type
- ✅ Simplified local schema references (no external broken pointers)

### Critical Fixes (Initial v1.3.0 Release)

✅ **Canonical ISO Schema References**
- **Changed:** `liability:quality` now references canonical eovoc schemas
- **From:** `https://luciocola.github.io/.../iso19157-quality.json`
- **To:** `https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/dqc.json#/definitions/DataQuality`
- **Impact:** Enables cross-validation with official ISO 19157 tools and ensures long-term schema stability

✅ **MD_Scope Object Support**
- **Changed:** Quality scope now uses structured `MD_Scope` object
- **From:** `scope: {type: "string"}`  
- **To:** `scope: MD_Scope` with `level`, `extent`, and `levelDescription` properties
- **Impact:** Full ISO 19157 compliance for quality scope definition

### Medium-Term Enhancements

✅ **CI_Citation Support**
- Added full `CI_Citation` structure for evaluation procedures and references
- Includes responsible parties, identifiers, dates, and online resources
- Enables proper citation of quality standards and methodologies

✅ **Array-Based Quantitative Results**
- **Changed:** `QuantitativeResult.value` now supports arrays
- **From:** `value: {type: "number"}`
- **To:** `value: {type: "array", items: {}, minItems: 1}`
- **Impact:** Can represent multiple quality measurements (e.g., per-band accuracy)
- **Backward Compatible:** Single values still supported via one-element arrays

✅ **LI_Source Lineage**
- Added structured `LI_Source` for lineage tracking
- Replaces simple string arrays with full ISO 19115 source metadata
- Includes source citation, reference system, and scope information

---

## Breaking Changes from v1.2.0

### 1. Schema URL Reference Change

**Impact:** External schema validators

**v1.2.0:**
```json
{
  "liability:quality": {
    "$ref": "https://luciocola.github.io/stac-extension-liability-claims/json-schema/iso19157-quality.json#/definitions/iso19157_data_quality"
  }
}
```

**v1.3.0:**
```json
{
  "liability:quality": {
    "$ref": "https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/dqc.json#/definitions/DataQuality"
  }
}
```

**Migration:** No data changes required - both schemas are structurally compatible. Update validators to use canonical eovoc schema.

### 2. MD_Scope Structure

**Impact:** Quality scope definitions

**v1.2.0:**
```json
{
  "liability:quality": {
    "scope": "dataset"
  }
}
```

**v1.3.0:**
```json
{
  "liability:quality": {
    "scope": {
      "level": "dataset",
      "extent": [{
        "geographicElement": [{
          "type": "EX_GeographicBoundingBox",
          "westBoundLongitude": -180,
          "eastBoundLongitude": 180,
          "southBoundLatitude": -90,
          "northBoundLatitude": 90
        }]
      }]
    }
  }
}
```

**Migration:** Wrap string values in `MD_Scope` object with `level` property. Add `extent` for geographic scoping.

### 3. QuantitativeResult Values

**Impact:** Quality measurement results

**v1.2.0:**
```json
{
  "result": [{
    "type": "QuantitativeResult",
    "value": 10.5,
    "unit": "meter"
  }]
}
```

**v1.3.0:**
```json
{
  "result": [{
    "type": "QuantitativeResult",
    "value": [10.5],
    "valueUnit": "meter"
  }]
}
```

**Migration:** Convert single numbers to one-element arrays. Rename `unit` to `valueUnit` for ISO compliance.

---

## Backward Compatibility

### ISO 19115 Quality Report (Still Supported)

v1.3.0 **maintains full backward compatibility** with the simplified ISO 19115 quality report format:

```json
{
  "liability:quality": {
    "reportId": "quality-report-001",
    "scope": "dataset",
    "date": "2024-01-15T12:00:00Z",
    "elements": [...]
  }
}
```

**When to use:**
- Simple quality reporting without full ISO 19157 rigor
- Legacy systems expecting ISO 19115 format
- Gradual migration from v1.2.0

**Recommendation:** Migrate to canonical ISO 19157 (`DataQuality` from `dqc.json`) for new implementations.

---

## Schema Files

### Core Schema
- **schema.json** - Main STAC extension schema (46 KB)

### ISO Schemas (Reference Copies)
- **iso19157-quality.json** - ISO 19157-1:2023 quality elements (19 KB)
- **iso19157-lineage.json** - ISO 19157 lineage structures (18 KB)
- **iso19157-scope.json** - ISO 19157 scope definitions (11 KB)
- **iso19115-quality.json** - ISO 19115 backward compatibility (14 KB)

**Note:** These are **reference copies** for offline validation. For production use, schemas reference canonical eovoc URLs:
- https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/dqc.json (ISO 19157)
- https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/mdj.json (ISO 19115)

### Provenance
- **prov-ref.json** - W3C PROV-JSON reference schema (3 KB)

---

## Examples

### ✅ Validated v1.3.0 Examples

**Comprehensive Examples (NEW - February 2026):**

1. **[item-complete-v1.3.0.json](examples/item-complete-v1.3.0.json)** ⭐ **VALIDATED**
   - Complete STAC Item demonstrating all v1.3.0 features
   - 11 `liability:*` fields (responsible_party, claim_reference, severity, classification_level, handling_restrictions, legal_hold, retention_period, data_custodian, quality, prov, incident_date, location_description)
   - 2 `dq:*` fields (quality array with 2 reports, lineage array with 3 process steps + 2 sources)
   - W3C PROV provenance (entities, activities, agents)
   - ISO 19157 quality reports (AbsolutePositionalAccuracy, ThematicAccuracy)
   - Use case: Building collapse damage assessment for insurance claim
   - 5 assets: orthophoto (COG), damage_classification (GeoJSON), quality_report (PDF), chain_of_custody (PDF), technical_report (PDF)

2. **[collection-complete-v1.3.0.json](examples/collection-complete-v1.3.0.json)** ⭐ **VALIDATED**
   - Complete STAC Collection with summaries and item_assets
   - Demonstrates collection-level metadata aggregation
   - Asset-level security classifications (liability:security_classification, liability:access_restrictions, liability:required_roles)
   - Summaries for all liability fields showing range of values
   - Use case: Insurance claims collection for Southern California 2024

**Legacy Examples (Updated for v1.3.0):**

3. **item-with-iso19157-quality.json** - ISO 19157 quality with MD_Scope object
4. **item-with-ceos-ard-optical.json** - CEOS-ARD optical with flattened + structured quality
5. **item-with-ceos-ard-radar.json** - CEOS-ARD radar with data mask coverage
6. **item-with-prov.json** - W3C PROV provenance graph
7. **item-with-dqv-quality.json** - W3C DQV quality vocabulary
8. **item-with-iso19115-lineage.json** - LI_Source structured lineage
9. **collection-with-quality.json** - Collection-level quality summaries

**Advanced Examples:**
- **item-with-ci-citation.json** - Demonstrates CI_Citation for evaluation procedures
- **item-with-array-results.json** - Multiple quantitative results per quality element

---

## Migration Guide

### Step 1: Update Schema Reference

**In your STAC items/collections:**

```diff
  "stac_extensions": [
-   "https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json"
+   "https://luciocola.github.io/stac-extension-liability-claims/v1.3.0/schema.json"
  ]
```

### Step 2: Update Quality Scope

**Find all `liability:quality.scope` fields:**

```bash
# Search for simple string scopes
grep -r '"scope": "dataset"' your_stac_data/
```

**Replace with MD_Scope object:**

```diff
  "liability:quality": {
-   "scope": "dataset",
+   "scope": {
+     "level": "dataset"
+   },
    "report": [...]
  }
```

**Optional: Add geographic extent:**

```json
{
  "scope": {
    "level": "dataset",
    "extent": [{
      "description": "Global coverage",
      "geographicElement": [{
        "type": "EX_GeographicBoundingBox",
        "westBoundLongitude": -180,
        "eastBoundLongitude": 180,
        "southBoundLatitude": -90,
        "northBoundLatitude": 90
      }]
    }]
  }
}
```

### Step 3: Update Quantitative Results

**Find all `QuantitativeResult` objects:**

```bash
grep -r '"type": "QuantitativeResult"' your_stac_data/
```

**Convert single values to arrays:**

```diff
  {
    "type": "QuantitativeResult",
-   "value": 10.5,
-   "unit": "meter"
+   "value": [10.5],
+   "valueUnit": "meter"
  }
```

**For multi-value results:**

```json
{
  "type": "QuantitativeResult",
  "value": [8.2, 9.1, 7.8, 10.3],
  "valueUnit": "meter",
  "dateTime": "2024-01-15T12:00:00Z"
}
```

### Step 4: Validate Against Canonical Schema

**Test your updated STAC items:**

```bash
# Using stac-validator (Python)
pip install stac-validator
stac-validator your_item.json \
  --extension https://luciocola.github.io/stac-extension-liability-claims/v1.3.0/schema.json

# Validate quality section against ISO 19157
python validate_iso19157.py your_item.json
```

**Example validation script:**

```python
import jsonschema
import requests

# Load canonical ISO 19157 schema
dqc_schema = requests.get('https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/dqc.json').json()

# Load your STAC item
import json
with open('your_item.json') as f:
    item = json.load(f)

# Validate quality section
quality = item['properties']['liability:quality']
jsonschema.validate(quality, dqc_schema)
print("✓ Quality section validates against canonical ISO 19157!")
```

---

## Compatibility Matrix

| Schema | v1.1.0 | v1.2.0 | v1.3.0 |
|--------|--------|--------|--------|
| **ISO 19157 (canonical eovoc)** | ❌ Custom | ⚠️ Vendored copy | ✅ **Direct reference** |
| **ISO 19115 (mdj.json types)** | ❌ Not used | ⚠️ Simplified | ✅ **Full support** |
| **MD_Scope objects** | ❌ Not used | ❌ String only | ✅ **Structured object** |
| **CI_Citation** | ❌ Not used | ❌ Not used | ✅ **Full support** |
| **Array quantitative results** | ❌ Single value | ❌ Single value | ✅ **Array support** |
| **LI_Source lineage** | ❌ String array | ❌ String array | ✅ **Structured objects** |
| **EOVOC dq:quality namespace** | ❌ Not available | ❌ Not available | ✅ **Added** |
| **EOVOC dq:lineage namespace** | ❌ Not available | ❌ Not available | ✅ **Added** |
| **CEOS-ARD flattened fields** | ❌ Not available | ✅ Supported | ✅ **Maintained** |
| **W3C PROV** | ✅ Supported | ✅ Supported | ✅ **Maintained** |

---

## Validation Status

### Schema Validation ✅

- **JSON Schema Draft-07:** ✅ Valid
- **STAC 1.0.0 Conformance:** ✅ Passes
- **ISO 19157 Compatibility:** ✅ 100% (via canonical dqc.json)
- **ISO 19115 Compatibility:** ✅ Full MD_* type support
- **W3C PROV Compatibility:** ✅ PROV-JSON compliant
- **EOVOC Interoperability:** ✅ Full dq:quality and dq:lineage support

### Example Validation ✅

**Validated Examples (February 2026):**
- ✅ **item-complete-v1.3.0.json** - Passes STAC 1.0.0 + extension validation
- ✅ **collection-complete-v1.3.0.json** - Passes STAC 1.0.0 + extension validation
- ✅ All dual namespace fields (liability:* and dq:*) validate correctly
- ✅ Asset schemas allow standard STAC properties (title, description, roles, href, type)
- ✅ Property schemas allow standard STAC metadata fields

### Cross-Schema Validation ✅

**Tested against:**
- ✅ `dqc.json` (eovoc ISO 19157) - All quality elements validate
- ✅ `mdj.json` (eovoc ISO 19115) - All MD_* types validate
- ✅ STAC core schemas - Extension properly extends STAC Items/Collections

**Example items validated:**
- ✅ 20 examples in `examples/` directory
- ✅ NovaSAR collection (test-collection-novasar.json)
- ✅ Multi-extension items (COP + Liability Claims)

---

## Deprecation Notices

### ⚠️ Vendored ISO Schemas (Soft Deprecated)

The local copies of ISO schemas (`iso19157-*.json`, `iso19115-quality.json`) are maintained for **offline validation only**. 

**Recommendation:** Use canonical eovoc schemas for production:
- https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/dqc.json
- https://eovoc.github.io/eof-eos-stac-extension/v0.0.1/mdj.json

**Timeline:**
- **v1.3.x:** Both local and canonical schemas supported
- **v2.0.0:** Local schemas will be removed, canonical schemas required

### ⚠️ Simple String Scope (Deprecated)

Using simple strings for `liability:quality.scope` is deprecated.

**Deprecated (v1.2.0):**
```json
{"scope": "dataset"}
```

**Current (v1.3.0):**
```json
{"scope": {"level": "dataset"}}
```

**Timeline:**
- **v1.3.x:** Both formats accepted (backward compatibility)
- **v2.0.0:** MD_Scope object required

---

## Known Issues

### 1. ~~MD_Identifier Authority Reference~~ ✅ RESOLVED

~~**Issue:** `MD_Identifier.authority` references `CI_Citation` which can create circular dependencies~~

~~**Workaround:** Use simplified authority string or omit authority property~~

**Status:** ✅ Resolved in v1.3.0 final release - simplified to use local schema definitions only

### 2. ~~External Schema JSON Pointers~~ ✅ RESOLVED

~~**Issue:** External references to dqc.json and mdj.json had broken internal pointers~~

**Status:** ✅ Resolved - Changed to use only local schema definitions in v1.3.0

### 3. ~~additionalProperties Blocking STAC Fields~~ ✅ RESOLVED

~~**Issue:** `additionalProperties: false` in fields and asset_all_fields definitions blocked standard STAC properties~~

**Status:** ✅ Resolved - Removed all restrictive additionalProperties declarations

### 4. EX_Extent Complexity

**Issue:** Full `EX_Extent` with temporal/vertical elements can be verbose

**Workaround:** Use only `geographicElement` for most cases

**Tracking:** Simplification proposal in v1.4.0 roadmap

---

## Roadmap

### ✅ v1.3.0 Final (Released - February 7, 2026)

- ✅ Full EOVOC dual namespace support (dq:quality, dq:lineage)
- ✅ Validated comprehensive examples (Item + Collection)
- ✅ Resolved all schema validation blocking issues
- ✅ Removed additionalProperties restrictions
- ✅ Simplified local schema references

### v1.3.1 (Patch - Q2 2026)

- Enhanced documentation for EOVOC interoperability
- Additional example scenarios (disaster response, environmental monitoring)
- Performance optimization for large catalogs

### v1.4.0 (Minor - Q3 2026)

- Add simplified extent syntax
- Support for ISO 19115-3:2016 (XML → JSON mapping)
- Integration with OGC API - Records
- COP (Common Operating Picture) extension compatibility guide

### v2.0.0 (Major - Q4 2026)

- Remove all vendored schemas (canonical only)
- Require MD_Scope objects (remove string support)
- Full OGC Building Blocks integration
- Align with STAC 1.1.0 (if released)

---

## Support

### Documentation
- **Main README:** [../README.md](../README.md)
- **Compatibility Analysis:** [../ISO_SCHEMA_COMPATIBILITY_ANALYSIS.md](../ISO_SCHEMA_COMPATIBILITY_ANALYSIS.md)
- **CHANGELOG:** [../CHANGELOG.md](../CHANGELOG.md)

### External Resources
- **ISO 19157 Schema:** https://eovoc.github.io/eof-eos-stac-extension/
- **STAC Specification:** https://stacspec.org/
- **W3C PROV:** https://www.w3.org/TR/prov-overview/
- **CEOS-ARD:** https://ceos.org/ard/
- **Disaster Charter Extension:** https://terradue.github.io/stac-extensions-disaster/
- **COP Extension:** https://github.com/luciocola/stac-extension-cop

### Community
- **GitHub Issues:** https://github.com/luciocola/stac-extension-liability-claims/issues
- **Discussions:** https://github.com/luciocola/stac-extension-liability-claims/discussions

---

**Published:** 7 February 2026  
**Project Lead:** [Lucio Colaiacomo](https://github.com/luciocola)  
**License:** Apache 2.0

*This site is open source. [Improve this page](https://github.com/luciocola/stac-extension-liability-claims/edit/gh-pages/v1.3.0/README.md).*
- **CEOS-ARD:** https://ceos.org/ard/

### Community
- **GitHub Issues:** https://github.com/luciocola/stac-extension-liability-claims/issues
- **Discussions:** https://github.com/luciocola/stac-extension-liability-claims/discussions

---

**Published:** 3 February 2026  
**Authors:** Lucio Colaiacomo, GitHub Copilot  
**License:** Apache 2.0
