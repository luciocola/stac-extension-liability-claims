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
