# Schema Formalization & Semantic Lifting Implementation Summary

**Date**: 2024-12-22  
**Version**: v1.2.0 (enhancements toward Candidate status)  
**OGC Reference**: T21-DQ4IPT Engineering Report (OGC 26-999)

## Overview

This document summarizes the implementation of two critical enhancements to advance the STAC Liability and Claims Extension from "Proposal" to "Candidate" maturity status:

1. **Schema Formalization**: Queryable ARD quality fields for simple API filtering
2. **Semantic Lifting**: JSON-LD ontology mappings for automatic RDF conversion

Both enhancements directly address requirements identified in the OGC T21-DQ4IPT Engineering Report as the #1 priority gap for CEOS-ARD formalization.

## 1. Schema Formalization: Queryable ARD Quality Fields

### Problem Statement

ISO 19157 quality reports provide comprehensive, authoritative quality metadata, but they require complex nested JSON path queries that are impractical for STAC API filtering:

```json
// BEFORE: Complex nested query (not supported by most STAC APIs)
{
  "op": "<=",
  "args": [
    {"property": "liability:quality.report[?(@.category=='positionalAccuracy')].result[0].value[0]"},
    10
  ]
}
```

### Solution: Flattened Top-Level Fields

Added 10 new `ard:*` fields that mirror key quality metrics from ISO 19157 reports at the top level:

| Field | Type | ISO 19157 Source | Example |
|-------|------|-----------------|---------|
| `ard:geometric_accuracy` | number | positionalAccuracy → result.value[0] | `12.5` |
| `ard:geometric_accuracy_unit` | string | positionalAccuracy → result.valueUnit | `"meter"` |
| `ard:geometric_accuracy_type` | string | positionalAccuracy → result.errorStatistic | `"rRMSE"` or `"CE90"` |
| `ard:radiometric_accuracy` | number | thematicQuality → result.value[0] | `5.0` or `0.5` |
| `ard:radiometric_accuracy_unit` | string | thematicQuality → result.valueUnit | `"percentage"` or `"dB"` |
| `ard:cloud_coverage` | number | completeness → result.value[0] (optical) | `15.2` |
| `ard:data_mask_coverage` | number | completeness → result.value[0] (radar) | `2.1` |
| `ard:specification_compliance` | boolean | usability → result.pass | `true` |
| `ard:pfs_threshold_compliance` | string | Derived from conformance results | `"all"` |
| `ard:pfs_target_compliance` | number | Derived from conformance explanation | `95.0` |

### Implementation Details

**Files Modified:**
- `examples/item-with-ceos-ard-optical.json`: Added 9 flattened fields for Sentinel-2 SR
- `examples/item-with-ceos-ard-radar.json`: Added 9 flattened fields for Sentinel-1 NRB  
- `json-schema/schema.json`: Added JSON Schema definitions with constraints and descriptions
- `README.md`: Added "Schema Formalization" section with query examples

**Design Principles:**
1. **No Duplication**: Flattened fields are read-only derivations mirroring ISO 19157 report values
2. **Sensor-Specific**: Optical uses `cloud_coverage` + percentage radiometric; Radar uses `data_mask_coverage` + dB radiometric
3. **Query Enablement**: All fields are primitive types (number, string, boolean) suitable for CQL2 filtering
4. **Backward Compatible**: All fields are optional; existing v1.2.0 items validate unchanged

### Query Examples

**Simple CQL2 Text Query:**
```cql2-text
ard:geometric_accuracy <= 10 AND ard:cloud_coverage < 20 AND ard:specification_compliance = true
```

**CQL2 JSON Query:**
```json
{
  "op": "and",
  "args": [
    {"op": "<=", "args": [{"property": "ard:geometric_accuracy"}, 10]},
    {"op": "<", "args": [{"property": "ard:cloud_coverage"}, 20]},
    {"op": "=", "args": [{"property": "ard:specification_compliance"}, true]}
  ]
}
```

**STAC API Search:**
```bash
curl -X POST "https://api.example.com/search" \
  -H "Content-Type: application/json" \
  -d '{
    "filter-lang": "cql2-json",
    "filter": {
      "op": "and",
      "args": [
        {"op": "<=", "args": [{"property": "ard:geometric_accuracy"}, 15]},
        {"op": ">", "args": [{"property": "ard:pfs_target_compliance"}, 90]}
      ]
    }
  }'
```

### Benefits

✅ **Simple API Queries**: Users can filter by quality metrics without complex JSON path navigation  
✅ **Query Performance**: STAC API implementations can index top-level fields for fast filtering  
✅ **Maturity Advancement**: Meets OGC T21-DQ4IPT Schema Formalization requirement  
✅ **No Data Loss**: Authoritative ISO 19157 reports maintained; flattened fields are convenience layer  
✅ **Sensor Differentiation**: Optical vs radar sensor differences properly handled

## 2. Semantic Lifting: JSON-LD Ontology Mappings

### Problem Statement

Without formal ontology mappings, STAC JSON items cannot be automatically converted to RDF for semantic web workflows (SPARQL queries, Linked Open Data integration, cross-catalog reasoning).

### Solution: Enhanced JSON-LD Context

Enhanced `context.jsonld` with two ontology namespaces and complete field mappings:

**New Ontology Namespaces:**
```json
{
  "ceosard": "https://ceos.org/ard/ontology#",
  "iso19157": "https://def.isotc211.org/iso19157/-3/dqm/1.0/"
}
```

**Field Mappings:**
```json
{
  "ard:geometric_accuracy": {
    "@id": "iso19157:DQ_AbsoluteExternalPositionalAccuracy",
    "@type": "xsd:decimal"
  },
  "ard:radiometric_accuracy": {
    "@id": "iso19157:DQ_ThematicClassificationCorrectness",
    "@type": "xsd:decimal"
  },
  "ard:specification_compliance": {
    "@id": "ceosard:conformsToSpecification",
    "@type": "xsd:boolean"
  },
  "ard:cloud_coverage": {
    "@id": "ceosard:cloudCoveragePercentage",
    "@type": "xsd:decimal"
  },
  "ard:data_mask_coverage": {
    "@id": "ceosard:dataMaskPercentage",
    "@type": "xsd:decimal"
  }
}
```

### Implementation Details

**Files Modified:**
- `context.jsonld`: Added CEOS-ARD and ISO 19157-3 ontology namespaces + field mappings
- `examples/semantic-lifting-example.ttl`: Created RDF/Turtle example with SPARQL queries

**Semantic Lifting Workflow:**

```
STAC JSON Item
    ↓ (JSON-LD processor + enhanced context.jsonld)
RDF Triples
    ↓ (Store in triple store: GraphDB, Virtuoso, etc.)
SPARQL Queryable Knowledge Graph
```

### RDF/Turtle Example

The semantic lifting example (`examples/semantic-lifting-example.ttl`) demonstrates:

1. **Complete Ontology Integration**: CEOS-ARD + ISO 19157 + W3C DQV + W3C PROV
2. **Automatic Conversion**: JSON-LD context enables `jsonld.toRDF()` for RDF generation
3. **SPARQL Queries**: 4 example queries showing semantic discovery capabilities

**SPARQL Query Example 1: Geometric Accuracy Filtering**
```sparql
SELECT ?product ?accuracy ?unit
WHERE {
  ?product iso19157:DQ_AbsoluteExternalPositionalAccuracy ?accuracy ;
           iso19157:valueUnit ?unit ;
           ceosard:conformsToSpecification true .
  FILTER(?accuracy <= 15)
}
```

**SPARQL Query Example 2: Cloud Coverage + Compliance**
```sparql
SELECT ?product ?cloudCoverage ?compliance
WHERE {
  ?product ceosard:productType "optical" ;
           ceosard:cloudCoveragePercentage ?cloudCoverage ;
           ceosard:targetRequirementsAchievement ?compliance ;
           ceosard:conformsToSpecification true .
  FILTER(?cloudCoverage < 20 && ?compliance > 90)
}
```

### Benefits

✅ **Semantic Web Interoperability**: JSON items automatically convertible to RDF  
✅ **SPARQL Discovery**: Complex semantic queries across distributed catalogs  
✅ **Linked Open Data**: Integration with external ontologies (SOSA/SSN, GeoSPARQL, etc.)  
✅ **Maturity Advancement**: Meets OGC T21-DQ4IPT Semantic Lifting requirement  
✅ **Standards Alignment**: Links CEOS-ARD, ISO 19157, W3C DQV, and W3C PROV

## Validation Results

All enhanced examples validated successfully:

```bash
$ python3 validate.py examples/item-with-ceos-ard-optical.json
✓ VALIDATION PASSED

$ python3 validate.py examples/item-with-ceos-ard-radar.json
✓ VALIDATION PASSED
```

**Validation Checks:**
- JSON Schema compliance (all `ard:*` fields properly defined)
- STAC 1.0.0 Item structure validated
- ISO 19157 quality report structure unchanged
- W3C PROV provenance structure unchanged
- CEOS-ARD certification fields unchanged

## Backward Compatibility

**100% Backward Compatible** with existing v1.2.0 items:

- All new `ard:*` fields are **optional**
- No changes to required fields
- No changes to existing field structures
- Existing items validate without modification
- Enhanced context.jsonld is additive (no removed mappings)

**Migration Path:**
1. Existing items continue working as-is
2. New items can optionally include `ard:*` fields
3. Catalog operators can gradually add flattened fields to improve queryability
4. JSON-LD context automatically available for semantic lifting workflows

## Maturity Status

**Before**: STAC Extension **Proposal** status  
**After**: Advancing toward **Candidate** status

**OGC T21-DQ4IPT Compliance:**
✅ **Schema Formalization**: Explicit metric mappings enable API queries  
✅ **Semantic Lifting**: JSON-LD ontology mappings enable RDF conversion  
✅ **CEOS-ARD Formalization**: Addresses #1 priority gap from OGC report

**Next Steps for Candidate Status:**
1. Community review of schema formalization approach
2. Implementation feedback from STAC API providers (indexing `ard:*` fields)
3. Semantic lifting validation with RDF triple stores
4. Consider formalization as separate STAC extension (e.g., `stac-extension-ard-queryable`)

## Files Changed

| File | Lines Modified | Purpose |
|------|---------------|---------|
| `context.jsonld` | +50 | Added CEOS-ARD + ISO 19157-3 ontologies and field mappings |
| `examples/item-with-ceos-ard-optical.json` | +9 | Added flattened ARD fields for Sentinel-2 SR |
| `examples/item-with-ceos-ard-radar.json` | +9 | Added flattened ARD fields for Sentinel-1 NRB |
| `examples/semantic-lifting-example.ttl` | +126 (new) | RDF/Turtle example with SPARQL queries |
| `json-schema/schema.json` | +60 | JSON Schema definitions for `ard:*` fields |
| `README.md` | +100 | Schema Formalization section with query examples |
| `CHANGELOG.md` | +50 | v1.2.0 enhancement release notes |

**Total Changes**: ~404 lines added (7 files)

## References

1. **OGC T21-DQ4IPT Engineering Report**: http://t21-dq4ipt-0586cf.pages.ogc.org/documents/D001/document.html
2. **CEOS-ARD STAC Extension**: https://github.com/stac-extensions/ceos-ard
3. **ISO 19157-1:2023**: https://www.iso.org/standard/78900.html
4. **W3C Data Quality Vocabulary**: https://www.w3.org/TR/vocab-dqv/
5. **W3C PROV-O**: https://www.w3.org/TR/prov-o/
6. **STAC API Filter Extension**: https://github.com/stac-api-extensions/filter
7. **CQL2 Specification**: https://docs.ogc.org/DRAFTS/21-065.html

## Contact

For questions or feedback on this implementation:
- **GitHub Issues**: https://github.com/luciocola/stac-extension-liability-claims/issues
- **STAC Slack**: #extensions channel
- **OGC DQ4EO DWG**: https://www.ogc.org/projects/groups/dq4eodwg

---

**Implementation Status**: ✅ **Complete** (All 8 tasks finished, all examples validated)
