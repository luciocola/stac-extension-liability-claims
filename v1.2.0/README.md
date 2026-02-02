# Liability and Claims Extension Specification v1.2.0

- **Title:** Liability and Claims
- **Identifier:** <https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json>
- **Field Name Prefix:** liability
- **Scope:** Item, Collection
- **Extension [Maturity Classification](https://github.com/radiantearth/stac-spec/tree/master/extensions/README.md#extension-maturity):** Pilot
- **Owner**: @luciocola
- **Version**: 1.2.0

This document explains the Liability and Claims Extension to the [SpatioTemporal Asset Catalog](https://github.com/radiantearth/stac-spec) (STAC) specification.

Version 1.2.0 adds:
- **ISO TC211 Official Schema Alignment**: Hybrid approach supporting both v1.1.0 style and ISO TC211 official schemas
- **CEOS-ARD Extension Integration**: Basic certification fields for Analysis Ready Data compliance
- **Schema Formalization**: Queryable ARD quality fields at top level
- **Semantic Lifting**: RDF/OWL ontology support via context.jsonld

## Item Properties and Collection Fields

| Field Name                    | Type                       | Description |
| ----------------------------- | -------------------------- | ----------- |
| liability:responsible_party   | string                     | **REQUIRED**. Organization or entity responsible for the data quality and potential liabilities. |
| liability:origin              | string                     | **REQUIRED**. Source or origin of the data (e.g., mission name, sensor platform). |
| liability:quality             | [Quality Object](#quality-object) | Quality metadata following ISO 19157-1:2023. |
| liability:prov                | [Provenance Object](#provenance-object) | Provenance information following W3C PROV. |
| liability:security            | [Security Object](#security-object) | Security classification and handling instructions. |
| liability:notes               | string                     | Additional notes about liability, usage restrictions, or disclaimers. |

### Quality Object

ISO 19157-1:2023 compliant quality metadata. Supports both v1.1.0 style and ISO TC211 official schema style.

**v1.2.0 Hybrid Approach:**
- ConformanceResult accepts both `"type": "ConformanceResult"` and `"resultType": "conformance"`
- Quality elements support optional `type` field alongside `category`
- 100% backward compatible with v1.1.0

See [ISO-TC211-ALIGNMENT.md](../../ISO-TC211-ALIGNMENT.md) for migration guide.

### Provenance Object

W3C PROV-JSON compliant provenance information tracking data lineage and processing history.

### CEOS-ARD Integration (v1.2.0)

Basic certification fields for Analysis Ready Data compliance:

| Field Name                    | Type    | Description |
| ----------------------------- | ------- | ----------- |
| ard:geometric_accuracy        | number  | Geometric accuracy in meters (RMSE or CE90) |
| ard:geometric_accuracy_type   | string  | Accuracy metric type (RMSE, CE90, LE90) |
| ard:radiometric_accuracy      | number  | Radiometric accuracy (percentage or reflectance units) |
| ard:cloud_coverage            | number  | Cloud coverage percentage (optical sensors) |
| ard:data_mask_coverage        | number  | Data mask coverage percentage (radar sensors) |
| ard:specification_compliance  | boolean | True if meets CEOS-ARD PFS threshold requirements |

## Examples

- [Item with ISO 19157 Quality](examples/item-with-iso19157-quality.json)
- [Item with W3C PROV](examples/item-with-prov.json)
- [Item with CEOS-ARD (Optical)](examples/item-with-ceos-ard-optical.json)
- [Item with CEOS-ARD (Radar)](examples/item-with-ceos-ard-radar.json)
- [Collection with Quality](examples/collection-with-quality.json)

## Schema

- **[JSON Schema](schema.json)**
- [ISO 19157 Quality Schema](iso19157-quality.json)
- [W3C PROV Schema](prov-ref.json)
- [ISO 19115 Quality Schema](iso19115-quality.json)
- [ISO 19157 Lineage Schema](iso19157-lineage.json)
- [ISO 19157 Scope Schema](iso19157-scope.json)

## Relation to other extensions

This extension is complementary to:

- **[CEOS-ARD Extension](https://github.com/stac-extensions/ceos-ard)** - Analysis Ready Data certification
- **[Satellite Extension](https://github.com/stac-extensions/sat)** - Satellite-specific metadata
- **[Scientific Citation Extension](https://github.com/stac-extensions/scientific)** - Publication references
- **[Processing Extension](https://github.com/stac-extensions/processing)** - Processing lineage

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

## Changelog

See [CHANGELOG.md](../../CHANGELOG.md) for version history.

## License

This work is licensed under [Apache License 2.0](../../LICENSE).
