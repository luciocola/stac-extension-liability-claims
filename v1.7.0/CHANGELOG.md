# Changelog - v1.7.0

## [v1.7.0] — May 2026

### Added — OGC 17-003r2 & OGC 17-084r1 EO Imagery Metadata Alignment

Implements full ISO 19115-2 MI_Metadata support and OGC conformance declarations, enabling
EOF-EOS product quality and lineage metadata in the data model aligned with ISO 19115-4.

#### New Field: `liability:eo_metadata`

Full ISO 19115-2 `MI_Metadata` object — extends `MD_Metadata` with `MI_AcquisitionInformation`.
Carries sensor, platform, band radiometry, and mission metadata for EO imagery products.
Conforms to **OGC 17-084r1** (EO Dataset Metadata GeoJSON-LD Encoding).

Key sub-objects added to `mdj.json`:
- `MI_Metadata` — root EO metadata class (allOf MD_Metadata + acquisitionInformation)
- `MI_AcquisitionInformation` — platform, instrument, operation, environmentalConditions
- `MI_Platform` — platform ID, orbit type, instrument list
- `MI_Sensor` — instrument ID, sensor type (optical/radar/lidar/SAR), operational mode
- `MI_Operation` — orbit pass, acquisition objective, status
- `MI_Band` — spectral band radiometry (peak response, nominal resolution, bitsPerValue, polarisation)
- `MI_GeoRectified` — georectified grid spatial representation
- `MI_Georeferenceable` — raw georeferencing parameters

#### New Field: `liability:conformsTo`

Declares OGC / ISO conformance class URIs for the STAC item. Enables explicit
alignment statements such as:
- `http://www.opengis.net/spec/eo-geojson/1.0` → **OGC 17-003r2** GeoJSON encoding of ISO 19115 quality
- `http://www.opengis.net/spec/eo-dataset-json/1.0` → **OGC 17-084r1** EO Dataset Metadata GeoJSON-LD

Asset links: `metadata_ogc17003r2` (MIME `application/geo+json;profile=...`) and
`metadata_ogc17084r1` (`application/ld+json`) patterns shown in new example.

#### Canonical DQ_* Class Aliases in `iso19157-quality.json`

Added 16 canonical ISO 19157-1 / OGC 17-003r2 class name aliases alongside
existing snake_case definitions:
`DQ_DataQuality`, `DQ_Element`, `DQ_QuantitativeResult`, `DQ_ConformanceResult`,
`DQ_DescriptiveResult`, `DQ_CoverageResult`, `DQ_Completeness`, `DQ_LogicalConsistency`,
`DQ_PositionalAccuracy`, `DQ_TemporalQuality`, `DQ_ThematicQuality`, `DQ_Metaquality`,
`DQ_MeasureReference`, `DQ_EvaluationMethod`, `QE_Usability`, `QE_MetaqualityElement`.

Validators targeting ISO canonical class names now resolve correctly alongside
the existing STAC-idiomatic snake_case names.

#### New Example: `item-eo-imagery-mi-metadata.json`

Demonstrates:
- `liability:conformsTo` with OGC 17-003r2 and OGC 17-084r1 URIs
- `liability:eo_metadata` with `MI_AcquisitionInformation`, `MI_Platform`, `MI_Sensor`
- `liability:quality` with ISO 19157 completeness and positional accuracy reports and lineage
- Asset roles `metadata_ogc17003r2` and `metadata_ogc17084r1` with correct MIME types
- `describedby` links to OGC conformance class URIs

---

# Changelog - v1.6.0

## [v1.6.0] — March 2026

### Added — ISO 20151 Data Spaces Support

#### Compatibility Analysis

A comprehensive compatibility analysis document has been added:
[ISO20151-DATASPACE-COMPATIBILITY.md](../ISO20151-DATASPACE-COMPATIBILITY.md)

It maps all ISO/IEC 20151 data spaces concepts to existing and new Liability Claims
fields, identifies gaps (3.5/5 coverage in v1.5.0), and proposes the resolutions
implemented in v1.6.0 (full coverage).

#### New Field: `liability:data_space`

Identifies the data space ecosystem in which this STAC asset is shared.

- `id` (required): Unique URI/DID of the data space
- `participant_role` (required): `provider`, `consumer`, `intermediary`, or `operator`
- `name`, `operator`, `connector_url`, `self_description_url` (optional)

Enables integration with GAIA-X, IDS connectors, and Eclipse Dataspace Components (EDC).

#### New Field: `liability:usage_policy`

Machine-readable usage policy using the **W3C ODRL 2.2** vocabulary as mandated by
ISO 20151 §8.

- `permission`, `prohibition`, `obligation` arrays of ODRL rules
- Each rule carries `action` and optional `constraint` triples (leftOperand, operator, rightOperand)
- `policy_type`: `Set` (template), `Offer` (from provider), or `Agreement` (bilateral)
- `assigner` and `assignee` expressed as DIDs

Directly consumed by EDC policy engine and IDS protocol negotiators during data transfer.

#### New Field: `liability:data_contract`

Reference to the formally executed data contract (ISO 20151 §9).

- `contract_id` (required): URN/UUID/URI
- `contract_date`, `expiry_date`: ISO 8601 datetimes
- `signed_by`: array of signatory DIDs
- `status`: `pending`, `active`, `expired`, `terminated`

#### New Field: `liability:sovereignty`

Data sovereignty constraints (ISO 20151 §7), aligned with GDPR Art. 5 and GAIA-X
Trust Framework §4.3.

- `data_residency`: ISO 3166-1 alpha-2 or regional codes (e.g. `EU`)
- `purpose`: W3C DPV purpose URI (e.g. `https://w3id.org/dpv#EmergencyManagement`)
- `retention_days`: maximum consumer retention period
- `export_restrictions`: country codes to which re-export is prohibited
- `redistribution_allowed`, `anonymisation_required`: boolean flags
- `gdpr_basis`: GDPR Art. 6 legal basis enum
- `data_classification`: classification level string

#### New Schema Definition: `odrl_rule`

Internal helper definition for ODRL rule objects (`$ref: #/definitions/odrl_rule`),
referenced by `liability:usage_policy` permission/prohibition/obligation arrays.

#### New Example

`examples/item-dataspace-sentinel2.json` — full Sentinel-2 L2A STAC Item with all
four new data spaces fields plus quality (ISO 19157), provenance (W3C PROV),
legal jurisdiction, and responsible party fields.

### Backward Compatibility

✅ **Fully backward compatible with v1.5.0**

All four new fields are optional. No existing fields were modified or removed.

### Alignment Summary

| Standard | v1.5.0 | v1.6.0 |
|----------|--------|--------|
| ISO 20151 Data Spaces | 3.5/5 | 5/5 |
| W3C ODRL 2.2 | ❌ | ✅ |
| W3C DPV 2.0 (purposes) | ❌ | ✅ |
| GAIA-X Trust Framework | Partial | ✅ |
| IDS / EDC Connector | ❌ | ✅ |
| GDPR Art. 5 compliance | Partial | ✅ |
| ISO 19157-1:2023 | ✅ | ✅ |
| W3C PROV | ✅ | ✅ |
| NIIRS | ✅ | ✅ |
