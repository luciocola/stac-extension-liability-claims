# STAC Extension: Liability Claims v1.5.0

**Version:** 1.5.0  
**STAC Version:** 1.0.0  
**Extension Maturity:** Stable  
**Owner:** @luciocola

This extension provides fields for tracking legal liability claims, data quality, provenance, and **imagery interpretability (NIIRS)** within STAC Items and Collections.

## Major Features in v1.5.0

### 🆕 NIIRS Support (New in v1.5.0)

Version 1.5.0 adds comprehensive support for the **National Imagery Interpretability Rating Scale (NIIRS)**, enabling standardized assessment and documentation of imagery quality and interpretability.

**Key capabilities:**
- **Overall NIIRS rating** (0-9 scale)
- **Sensor-specific ratings** for visible, radar, infrared, and multispectral imagery
- **Evaluation method tracking** (analyst rating, GIQE prediction, automated assessment, etc.)
- **Task verification** - document which NIIRS tasks are achievable
- **GIQE integration** - predicted NIIRS from General Image Quality Equation
- **Confidence levels** - indicate assessment reliability

### Legacy Features

- **ISO 19157-1:2023 DQ Elements** - Comprehensive quality metadata
- **ISO 19115-2:2019 Quality Extensions** - Sensor quality metadata
- **W3C PROV** - Provenance tracking
- **EOVOC v0.0.2** - Earth Observation Vocabulary alignment
- **OGC Canonical Schemas** - ARD quality metadata compatibility

## NIIRS Field Documentation

### `liability:niirs` Object

The `liability:niirs` field provides structured metadata for National Imagery Interpretability Rating Scale assessments.

#### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `overall` | number (0-9) | **Yes** | Primary NIIRS rating for the imagery |
| `variants` | object | No | Sensor-specific NIIRS ratings (visible, radar, infrared, multispectral) |
| `evaluation_method` | string (enum) | No | Method used for NIIRS determination |
| `evaluation_date` | string (datetime) | No | When the assessment was performed |
| `evaluated_by` | string | No | Analyst/organization/system that performed evaluation |
| `tasks_verified` | array[string] | No | List of NIIRS tasks confirmed achievable |
| `giqe_predicted` | number (0-9) | No | NIIRS predicted by GIQE calculation |
| `giqe_parameters` | object | No | Physical sensor parameters used in GIQE |
| `confidence` | string (enum) | No | Assessment confidence (high/medium/low) |
| `notes` | string | No | Additional evaluation notes |

#### Evaluation Methods

- `subjective_analyst_rating` - Human expert evaluation
- `giqe_prediction` - General Image Quality Equation calculation
- `automated_assessment` - Algorithmic evaluation
- `comparative_analysis` - Comparison with reference imagery
- `operational_validation` - Field-verified tasks
- `vendor_specification` - Manufacturer-provided rating

#### GIQE Parameters

When `giqe_predicted` is provided, the `giqe_parameters` object documents the physical sensor characteristics:

- `gsd` - Ground Sample Distance (meters)
- `rer` - Relative Edge Response (0-1, sharpness metric)
- `snr` - Signal-to-Noise Ratio
- `overshoot` - Edge overshoot percentage (enhancement artifacts)

## Usage Examples

### Example 1: Visible Imagery with NIIRS 6

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.5.0/schema.json"
  ],
  "type": "Feature",
  "id": "high-res-visible-001",
  "properties": {
    "datetime": "2024-01-15T18:30:00Z",
    "gsd": 0.3,
    "liability:niirs": {
      "overall": 6,
      "variants": {
        "visible": 6,
        "radar": null,
        "infrared": null,
        "multispectral": null
      },
      "evaluation_method": "subjective_analyst_rating",
      "evaluation_date": "2024-01-16T10:00:00Z",
      "evaluated_by": "Imagery Analysis Team - DIA",
      "tasks_verified": [
        "Identify vehicle spare tires (NIIRS 6)",
        "Distinguish antenna shapes as parabolic/rectangular (NIIRS 6)",
        "Identify cable car-type (NIIRS 6)"
      ],
      "giqe_predicted": 5.8,
      "giqe_parameters": {
        "gsd": 0.3,
        "rer": 0.85,
        "snr": 45.0,
        "overshoot": 0.12
      },
      "confidence": "high",
      "notes": "Optimal lighting conditions, excellent atmospheric clarity"
    }
  }
}
```

### Example 2: Multi-Sensor Collection

```json
{
  "properties": {
    "liability:niirs": {
      "overall": 5,
      "variants": {
        "visible": null,
        "radar": 5,
        "infrared": 4,
        "multispectral": null
      },
      "evaluation_method": "giqe_prediction",
      "confidence": "medium",
      "notes": "SAR NIIRS 5 despite 85% cloud cover. IR limited by water vapor."
    }
  }
}
```

### Example 3: Collection with NIIRS Requirements

```json
{
  "type": "Collection",
  "id": "tactical-recon",
  "summaries": {
    "liability:niirs": {
      "overall": {
        "minimum": 4,
        "maximum": 7
      },
      "variants": {
        "visible": {"minimum": 5, "maximum": 7},
        "radar": {"minimum": 4, "maximum": 6}
      }
    }
  }
}
```

## NIIRS Rating Scale Reference

| Rating | Visible/Pan | Radar | Infrared | Multispectral |
|--------|-------------|-------|----------|---------------|
| **0** | Interpretability precluded | No usable detail | No thermal detail | No spectral utility |
| **1** | Detect large area features | Detect major landforms | Detect thermal anomalies | Detect large features |
| **2** | Detect large buildings | Detect airport runways | Identify large heat sources | Distinguish basic classes |
| **3** | Detect aircraft wing config | Detect large buildings | Distinguish vehicles/buildings | Identify crop types |
| **4** | Distinguish cars/trucks | Distinguish cars/trucks | Detect thermal signatures | Identify vegetation stress |
| **5** | Identify vehicle types | Identify railroad tracks | Identify cooling systems | Mineral identification |
| **6** | Identify spare tires | Identify antenna types | Detect exhaust plumes | Detailed spectral analysis |
| **7** | Identify windshield wipers | Identify cable diameter | Thermal anomaly < 1°C | Hyperspectral analysis |
| **8** | Identify automobile markings | Detect bridge cable fasteners | Sub-degree thermal detail | Chemical signatures |
| **9** | Identify railroad spikes | Detect fastener slot types | Ultra-precise thermal | Advanced spectral ID |

## Migration from v1.4.0

Version 1.5.0 is **fully backward compatible** with v1.4.0. No breaking changes.

### To Add NIIRS Support

1. Update your `stac_extensions` array:
   ```json
   "stac_extensions": [
     "https://luciocola.github.io/stac-extension-liability-claims/v1.5.0/schema.json"
   ]
   ```

2. Add the `liability:niirs` field to your item properties:
   ```json
   "properties": {
     "datetime": "2024-01-15T12:00:00Z",
     "liability:niirs": {
       "overall": 6,
       "evaluation_method": "subjective_analyst_rating",
       "confidence": "high"
     }
   }
   ```

3. Optionally specify sensor-specific ratings:
   ```json
   "liability:niirs": {
     "overall": 5,
     "variants": {
       "visible": 6,
       "radar": 5,
       "infrared": 4,
       "multispectral": 5
     }
   }
   ```

## Schema Reference

- **Schema:** [schema.json](./schema.json)
- **Examples:** [examples/](./examples/)
- **Changelog:** [CHANGELOG.md](./CHANGELOG.md)

## Related Standards

- **NIIRS Standards:**
  - Visible: March 1994 (IRETS-CIVVS)
  - Radar: August 1992 (IRRUS-SAR)
  - Infrared: April 1996 (IRRTIRS)
  - Multispectral: February 1995 (IRRMSS)
  
- **GIQE:** General Image Quality Equation (ITEK Corporation methodology)
- **ISO 19157-1:2023:** Geographic information - Data quality
- **ISO 19115-2:2019:** Geographic metadata extensions for imagery and gridded data

## Contributing

Issues and pull requests welcome at the [GitHub repository](https://github.com/luciocola/stac-extension-liability-claims).

## License

See [LICENSE](../LICENSE) file.
