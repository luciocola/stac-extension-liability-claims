# Changelog - STAC Extension Liability Claims

All notable changes to this project will be documented in this file.

## [v1.5.0] - 2024-01-XX

### Added - NIIRS Support 🎯

#### New Field: `liability:niirs`

Comprehensive National Imagery Interpretability Rating Scale (NIIRS) support for standardized imagery quality assessment.

**Core Features:**
- `overall` (required): Primary NIIRS rating 0-9
- `variants`: Sensor-specific ratings (visible, radar, infrared, multispectral)
- `evaluation_method`: Six assessment methods (subjective, GIQE, automated, etc.)
- `evaluation_date`: ISO 8601 timestamp of assessment
- `evaluated_by`: Analyst/organization identifier
- `tasks_verified`: Array of confirmed NIIRS tasks
- `giqe_predicted`: NIIRS from General Image Quality Equation
- `giqe_parameters`: Physical sensor parameters (GSD, RER, SNR, overshoot)
- `confidence`: Assessment confidence level (high/medium/low)
- `notes`: Additional evaluation context

**Example Usage:**
```json
"liability:niirs": {
  "overall": 6,
  "variants": {
    "visible": 6,
    "radar": null,
    "infrared": null,
    "multispectral": null
  },
  "evaluation_method": "subjective_analyst_rating",
  "tasks_verified": [
    "Identify vehicle spare tires (NIIRS 6)",
    "Distinguish antenna shapes (NIIRS 6)"
  ],
  "giqe_predicted": 5.8,
  "confidence": "high"
}
```

### Documentation

- **README.md**: Comprehensive NIIRS documentation with usage examples
- **examples/item-niirs-visible.json**: NIIRS 6 visible imagery example
- **examples/item-niirs-multiband.json**: Multi-sensor SAR + IR example  
- **examples/collection-niirs-requirements.json**: Collection-level NIIRS summaries

### Technical Details

- **Added** `{"required": ["liability:niirs"]}` to schema `require_any_field` (line 113)
- **Added** full `liability:niirs` object definition (lines 245-354)
- **Supports** all four NIIRS variants: visible (1994), radar (1992), infrared (1996), multispectral (1995)
- **Integrates** GIQE methodology for predicted NIIRS calculations
- **Maintains** backward compatibility with v1.4.0 (NIIRS is optional)

### Backward Compatibility

✅ **Fully backward compatible with v1.4.0**

- All v1.4.0 items remain valid in v1.5.0
- `liability:niirs` is optional (included in `require_any_field`, not unconditionally required)
- No changes to existing fields
- No breaking schema modifications

### Migration Guide

**From v1.4.0 to v1.5.0:**

1. Update extension URL in `stac_extensions`:
   ```diff
   - "https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json"
   + "https://luciocola.github.io/stac-extension-liability-claims/v1.5.0/schema.json"
   ```

2. Optionally add NIIRS metadata:
   ```json
   "properties": {
     "datetime": "2024-01-15T12:00:00Z",
     "liability:niirs": {
       "overall": 6,
       "evaluation_method": "subjective_analyst_rating"
     }
   }
   ```

No other changes required for existing STAC items.

---

## [v1.4.0] - 2024-01-XX

### Changed

- **Aligned with EOVOC v0.0.2 ISO schemas**
- Fixed `stepDateTime` validation issues in `dq:lineage`
- Updated ISO 19157 quality element references
- Enhanced `ard:specifications` structure

### Documentation

- Updated schema $id to v1.4.0
- Improved definition descriptions
- Enhanced examples

---

## [v1.3.0] - 2023-XX-XX

### Changed

- **Adopted canonical ISO 19157 and ISO 19115 schemas**
- Transitioned from inline quality definitions to referenced OGC Building Blocks
- Improved interoperability with STAC EO and ARD extensions

### Fixed

- Resolved circular reference issues in quality metadata
- Improved schema validation performance

---

## [v1.2.0] - 2023-XX-XX

### Added

- **ISO TC211 Geographic Metadata Integration**
- `dq:lineage` field for data lineage tracking
- `dq:quality` comprehensive quality metadata
- `mdj:qualityInfo` extended quality information

### Enhanced

- Provenance tracking with `liability:prov`
- ARD specifications support

---

## [v1.1.0] - 2023-XX-XX

### Added

- **Initial stable release**
- Liability claim tracking fields
- Basic quality metadata
- Provenance foundations

### Technical Foundation

- STAC 1.0.0 compliance
- JSON Schema Draft-07
- Extensible architecture

---

## Version Comparison Matrix

| Feature | v1.1.0 | v1.2.0 | v1.3.0 | v1.4.0 | v1.5.0 |
|---------|--------|--------|--------|--------|--------|
| **Basic Liability Claims** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **ISO 19157 Quality** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Canonical Schemas** | ❌ | ❌ | ✅ | ✅ | ✅ |
| **EOVOC Alignment** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **NIIRS Support** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Sensor-Specific NIIRS** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **GIQE Integration** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Task Verification** | ❌ | ❌ | ❌ | ❌ | ✅ |

## Links

- **GitHub Repository:** https://github.com/luciocola/stac-extension-liability-claims
- **Schema v1.5.0:** https://luciocola.github.io/stac-extension-liability-claims/v1.5.0/schema.json
- **NIIRS Reference:** https://irp.fas.org/imint/niirs.htm
