# GeoDCAT-AP 3.0.0 Compatibility Analysis
## STAC Liability & Claims Extension v1.6.0

**Specification Reference:** [GeoDCAT-AP 3.0.0](https://semiceu.github.io/GeoDCAT-AP/releases/3.0.0/)  
**Base Vocabulary:** [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/)  
**Analysis Date:** 2025  
**Extension Namespace:** `https://stac-extensions.github.io/liability-claims/`

---

## 1. Executive Summary

The STAC Liability & Claims extension v1.6.0 has **strong structural alignment** with GeoDCAT-AP 3.0.0 in the following areas:

| Domain | Alignment Level |
|---|---|
| Usage policies (ODRL) | Strong |
| Quality metadata (ISO 19157 / DQV) | Strong |
| Provenance (PROV-O) | Strong |
| Spatial coverage | Partial |
| Responsible parties / Agent roles | Partial |
| Temporal metadata | Gap |
| Applicable legislation / legal resources | Gap |
| Contact points | Gap |

The primary gaps are **missing namespace prefixes** in `context.jsonld` and a few **semantic alignment substitutions** needed for the `liability:sovereignty` and `liability:legal_jurisdiction` fields. No structural redesign of the extension is required.

---

## 2. GeoDCAT-AP Namespace Requirements

GeoDCAT-AP 3.0.0 is built on the following namespace stack. The right-hand column shows the current status in `context.jsonld`.

| Prefix | URI | In context.jsonld |
|---|---|---|
| `dcat:` | `http://www.w3.org/ns/dcat#` | ✅ Present |
| `dqv:` | `http://www.w3.org/ns/dqv#` | ✅ Present |
| `prov:` | `http://www.w3.org/ns/prov#` | ✅ Present |
| `foaf:` | `http://xmlns.com/foaf/0.1/` | ✅ Present |
| `schema:` | `http://schema.org/` | ✅ Present |
| `dct:` / `dcterms:` | `http://purl.org/dc/terms/` | ❌ Missing |
| `odrl:` | `http://www.w3.org/ns/odrl/2/` | ❌ Missing |
| `vcard:` | `http://www.w3.org/2006/vcard/ns#` | ❌ Missing |
| `locn:` | `http://www.w3.org/ns/locn#` | ❌ Missing |
| `gsp:` | `http://www.opengis.net/ont/geosparql#` | ❌ Missing |
| `eli:` | `http://data.europa.eu/eli/ontology#` | ❌ Missing |
| `geodcatap:` | `http://data.europa.eu/930/` | ❌ Missing |
| `adms:` | `http://www.w3.org/ns/adms#` | ❌ Missing |
| `skos:` | `http://www.w3.org/2004/02/skos/core#` | ❌ Missing |

The single most critical missing prefix is **`dct:`** (Dublin Core Terms), used pervasively for title, description, dates, license, publisher, spatial coverage, temporal coverage, provenance, and conformance. Its absence is the root cause of most partial alignments.

---

## 3. Full Compatibility Matrix

### 3.1 Core Liability Fields

| Extension Field | GeoDCAT-AP Property | Alignment | Notes |
|---|---|---|---|
| `liability:claim_id` | `dct:identifier` | ⚠️ Partial | `dct:` missing from context |
| `liability:claim_date` | `dct:issued` | ⚠️ Partial | `dct:` missing from context |
| `liability:incident_date` | `dct:temporal` / `dcat:startDate` | ⚠️ Partial | `dct:` + `dcat:` (present) |
| `liability:resolution_date` | `dcat:endDate` | ✅ Good | `dcat:` present |
| `liability:claim_status` | `adms:status` | ❌ Gap | `adms:` missing; ADMS status values (`Completed`, `UnderDevelopment`, `Deprecated`, `Withdrawn`) are DCAT 3 / GeoDCAT-AP aligned for Distribution status |
| `liability:claim_type` | `dct:type` | ⚠️ Partial | `dct:` missing; SKOS Concept expected as value |
| `liability:legal_jurisdiction` | `dcatap:applicableLegislation` → `eli:LegalResource` | ❌ Gap | Requires `eli:` prefix; no direct STAC equivalent |
| `liability:coverage_area` | `dct:spatial` → `dct:Location` + `dcat:bbox` + `locn:geometry` | ⚠️ Partial | `dct:` and `locn:` missing; `dcat:bbox` literal available once `dct:` added |
| `liability:affected_parties` | `dcat:contactPoint` → `vcard:Kind` | ⚠️ Partial | `vcard:` missing |
| `liability:damages_estimated` | `schema:amount` + `schema:currency` | ✅ Good | `schema:` already present |
| `liability:damages_currency` | `schema:currency` | ✅ Good | — |

### 3.2 Responsible Party (`liability:responsible_party`)

GeoDCAT-AP 3.0.0 defines 11 agent roles from ISO 19115 mapped to specific properties:

| Role | GeoDCAT-AP Property | Extension Sub-field |
|---|---|---|
| publisher | `dct:publisher` | `liability:responsible_party` where `role = publisher` |
| creator / originator | `dct:creator` / `geodcatap:originator` | `role = originator` |
| custodian | `geodcatap:custodian` | `role = custodian` |
| distributor | `geodcatap:distributor` | `role = distributor` |
| contact point | `dcat:contactPoint` → `vcard:Organization` | `role = pointOfContact` |
| rights holder | `dct:rightsHolder` | `role = owner` |
| processor | `geodcatap:processor` | `role = processor` |
| principal investigator | `geodcatap:principalInvestigator` | `role = principalInvestigator` |

**Current gap:** The extension encodes `responsible_party` as a plain JSON object with a `role` string. GeoDCAT-AP expects role-specific RDF properties (`dct:publisher`, `geodcatap:custodian`, etc.). To align, the extension would need a role-to-property mapping in `context.jsonld` using a `@type` qualifier or a JSON-LD term definition.

### 3.3 Usage Policy (`liability:usage_policy`)

This is the **strongest alignment area**.

| liability-claims | GeoDCAT-AP / DCAT 3 | Alignment |
|---|---|---|
| `liability:usage_policy` object | `odrl:hasPolicy` → `odrl:Policy` | ✅ Strong |
| `policy_type: "Set"/"Offer"/"Agreement"` | `odrl:Set`, `odrl:Offer`, `odrl:Agreement` | ✅ Strong |
| `permission` array | `odrl:permission` | ✅ Strong |
| `prohibition` array | `odrl:prohibition` | ✅ Strong |
| `obligation` array | `odrl:obligation` | ✅ Strong |
| `assigner` / `assignee` | `odrl:assigner` / `odrl:assignee` | ✅ Strong |
| `target` | `odrl:target` | ✅ Strong |
| `action` values | ODRL Action vocabulary | ✅ Strong |

**One gap:** `odrl:` prefix is not in `context.jsonld`. Once added, the usage_policy block can be expressed as a valid `odrl:Policy`.

Additionally:
- Access restrictions → `dct:accessRights` → `dct:RightsStatement`
- License terms → `dct:license` → `dct:LicenseDocument`

Both require `dct:` in context.

### 3.4 Data Space (`liability:data_space`)

ISO 20151 data spaces map cleanly to GeoDCAT-AP's Data Service model:

| liability-claims | GeoDCAT-AP Property | Alignment |
|---|---|---|
| `data_space.id` (URI) | `dcat:DataService` subject IRI | ✅ Strong — `dcat:` present |
| `data_space.connector_url` | `dcat:endpointURL` | ✅ Strong |
| `data_space.self_description_url` | `dcat:endpointDescription` | ✅ Strong |
| `data_space.participant_role` | `geodcatap:serviceType` (INSPIRE SDS type controlled vocabulary) | ⚠️ Partial — `geodcatap:` missing |
| `data_space.operator` (DID) | `dct:publisher` or `geodcatap:custodian` for the connector service | ⚠️ Partial — `dct:` missing |

The connector abstraction in ISO 20151 corresponds directly to a `dcat:DataService` with `dcat:endpointURL` and `dcat:endpointDescription`. This mapping is clean and addable without breaking changes.

### 3.5 Data Sovereignty (`liability:sovereignty`)

| liability-claims | GeoDCAT-AP/DCAT | Alignment |
|---|---|---|
| `sovereignty.data_residency` | `dct:spatial` → `dct:Location` (jurisdiction as location) | ⚠️ Partial |
| `sovereignty.gdpr_article` | `dcatap:applicableLegislation` → `eli:LegalResource` | ❌ Gap — requires `eli:` |
| `sovereignty.processing_purpose` | `odrl:purpose` (ODRL action context) | ✅ Good via ODRL |
| `sovereignty.retention_period` | `dcat:temporalResolution` or `dct:temporal` end-only | ⚠️ Partial |
| `sovereignty.export_restrictions` | `dct:accessRights` + `dct:rights` | ⚠️ Partial — `dct:` missing |
| `sovereignty.gaia_x_compliance` | `dct:conformsTo` → `dct:Standard` (GAIA-X as standard URI) | ⚠️ Partial — `dct:` missing |

### 3.6 Data Contract (`liability:data_contract`)

| liability-claims | GeoDCAT-AP Property | Alignment |
|---|---|---|
| `data_contract.contract_reference` | `dct:identifier` | ⚠️ Partial |
| `data_contract.contract_expiry` | `dcat:endDate` in `dct:temporal` | ✅ Good |
| `data_contract.signatories` | `prov:wasAttributedTo` → `prov:Attribution` + `prov:hadRole` | ✅ Good — `prov:` present |

### 3.7 Quality Metadata (`liability:quality` + `dq:lineage`)

This is another **strong alignment area**.

| liability-claims | GeoDCAT-AP Property | Alignment |
|---|---|---|
| `liability:quality` block | `dqv:hasQualityMeasurement` → `dqv:QualityMeasurement` | ✅ Strong — `dqv:` present |
| ISO 19157 quality elements | `dqv:isMeasurementOf` → `dqv:Metric` | ✅ Strong |
| `dq:lineage` | `dct:provenance` → `dct:ProvenanceStatement` | ⚠️ Partial — `dct:` missing |
| `dq:extended_lineage` (LE_Lineage) | `prov:wasDerivedFrom` / `prov:wasGeneratedBy` | ✅ Strong — `prov:` present |
| NIIRS / GSD metrics | `dqv:QualityMeasurement` + `dqv:isMeasurementOf` geodcatap spatial resolution metrics | ✅ Strong |
| `quality_report.prov:*` fields | `prov:Activity`, `prov:wasUsedBy` (conformance test pattern) | ✅ Strong |

GeoDCAT-AP's conformance test pattern using `prov:wasUsedBy` / `prov:Activity` / `prov:generated` / `prov:qualifiedAssociation` matches the PROV-O fields already embedded in the extension's quality_report sub-schema.

**Note:** GeoDCAT-AP currently provides binding only for conformity/conformance results (via `dct:conformsTo` / PROV-O), and not for general ISO 19157 quality elements beyond spatial resolution (via `dqv:hasQualityMeasurement`). The extension already goes further than GeoDCAT-AP in this area and is fully backward compatible.

### 3.8 STAC Item as GeoDCAT-AP Dataset

A STAC Item is the fundamental unit. Its fields map to GeoDCAT-AP `dcat:Dataset` as follows:

| STAC Field | GeoDCAT-AP / DCAT 3 | Notes |
|---|---|---|
| `id` | `dct:identifier` | Map as claim identifier |
| `geometry` | `dct:spatial` / `locn:geometry` (WKT) / `dcat:bbox` | `locn:` missing |
| `bbox` | `dcat:bbox` (in `dct:Location`) | `dct:` missing |
| `properties.datetime` | `dct:issued` / `dct:temporal` | `dct:` missing |
| `links` | `dcat:distribution` / `dcat:accessURL` | ✅ `dcat:` present |
| `assets` | `dcat:Distribution` | ✅ |
| `assets[*].href` | `dcat:downloadURL` | ✅ |
| `assets[*].type` (media type) | `dcat:mediaType` | ✅ |
| `stac_extensions` | `dct:conformsTo` (array of standards) | `dct:` missing |

---

## 4. Gap Summary

### 4.1 Critical Gaps (blocking full GeoDCAT-AP conformance)

1. **Missing `dct:` prefix** — Dublin Core Terms is the backbone of DCAT-AP/GeoDCAT-AP. Used for: title, description, identifier, issued, modified, spatial, temporal, publisher, license, accessRights, rights, conformsTo, provenance. This is the single most impactful gap.

2. **Missing `odrl:` prefix** — Required to correctly express `liability:usage_policy` as an `odrl:Policy` with `odrl:hasPolicy` linkage from the dataset.

3. **Missing `locn:` prefix** — Required for `locn:geometry` (WKT/GML spatial coverage beyond bbox).

4. **Missing `vcard:` prefix** — Required for `dcat:contactPoint` → `vcard:Organization` for contact parties.

### 4.2 Secondary Gaps (limiting semantic precision)

5. **Missing `eli:` prefix** — Required to model `liability:legal_jurisdiction` and GDPR articles as `eli:LegalResource` instances (the `dcatap:applicableLegislation` range type in GeoDCAT-AP 3.0.0).

6. **Missing `geodcatap:` prefix** — Required for GeoDCAT-AP-specific agent roles (`geodcatap:custodian`, `geodcatap:originator`, `geodcatap:processor`, etc.) and resource type declarations.

7. **Missing `adms:` prefix** — Required for `adms:status` (claim lifecycle: Completed/Deprecated/UnderDevelopment/Withdrawn).

8. **Missing `gsp:`/`geosparql:` prefix** — Required for WKT/GML typed geometry literals (`gsp:wktLiteral`, `gsp:gmlLiteral`) in `dct:Location` / `dcat:bbox`.

9. **Missing `skos:` prefix** — Required for coding claim types, jurisdiction codes, and controlled vocabulary terms as `skos:Concept` references.

### 4.3 Modelling Gaps (schema design)

10. **`liability:responsible_party.role` → Agent role mapping** — The extension encodes the role as a string enum. GeoDCAT-AP maps each role to a distinct RDF property. A JSON-LD `@context` term definition (or v1.7.0 sub-schema) is needed to bridge this.

11. **`liability:legal_jurisdiction` as ELI URI** — Currently a plain string. Should reference a URI from EU Legislation Identifier registry or INSPIRE registry for interoperability.

12. **`liability:data_space` → `dcat:DataService`** — The connector is described inline but not typed as `dcat:DataService`. A `@type` alias would resolve this.

---

## 5. Backward Compatibility Analysis

Applying GeoDCAT-AP conformance touches three independent layers — JSON Schema (`schema.json`), JSON-LD context (`context.jsonld`), and RDF semantics — and each has a different risk profile. They are assessed separately below.

### 5.1 Pre-existing Issues (Independent of GeoDCAT-AP)

Two bugs exist in v1.6.0 that must be tracked regardless of GeoDCAT-AP work:

| Issue | Detail | Impact |
|---|---|---|
| **`@vocab` version mismatch** | `context.jsonld` line 4 declares `@vocab` as `v1.1.0/schema.json#`, but the deployed schema is v1.6.0. All `liability:`, `dq:`, `ard:` term IRIs resolve to v1.1.0. | Low for JSON consumers; breaks RDF round-tripping and canonical IRI resolution for JSON-LD consumers. Fix: update the three `v1.1.0` occurrences in `context.jsonld` to `v1.6.0`. |
| **`responsible_party` type mismatch** | `schema.json` (line 219) declares `"type": "string"`, but the example (`item-dataspace-sentinel2.json`) uses an object with `name`, `role`, `email`, `did`. Existing JSON Schema validators will reject the example against the schema. | Medium — any STAC validator running against the schema will fail on the example. Fix independently before GeoDCAT-AP work. |

### 5.2 JSON Schema Layer (`schema.json`)

JSON Schema is the STAC validation surface. Changes here are what STAC clients and validators observe.

| Proposed Change | Breaking? | Notes |
|---|---|---|
| Add optional `geodcat-ap.json` sub-schema file | ✅ Safe | Opt-in via `stac_extensions`. Existing items without it are unaffected. |
| Keep all existing field names and types unchanged | ✅ Safe | GeoDCAT-AP alignment requires no field removal or rename. |
| Change `responsible_party` from `type: string` to `type: object` | ⚠️ **Breaking** | Schema definition currently says string; examples already use object. Any code relying on the schema definition (not the example) will break. **Verdict:** This is a schema bug fix, not a GeoDCAT-AP change. Should be tagged as a minor breaking fix in a v1.6.1 patch. |
| Add `format: uri` validation to `legal_jurisdiction` for ELI alignment | ⚠️ **Breaking** | Existing values like `"EU"` and `"AU"` are not valid URIs. **Mitigation:** Do NOT add `format: uri` constraint. Add SHOULD-level guidance only in docs. Reserve hard validation for v2.0.0. |
| Add `format: uri` guidance for `data_space.id` | ✅ Safe | Already has `"format": "uri"` in schema — no change needed. |

### 5.3 JSON-LD Context Layer (`context.jsonld`)

JSON-LD context changes affect only consumers that process the STAC item as JSON-LD. STAC-native (JSON-only) consumers are completely unaffected.

| Proposed Change | Breaking for JSON-LD Consumers? | Notes |
|---|---|---|
| **Add new namespace prefixes** (`dct:`, `odrl:`, `vcard:`, `locn:`, `gsp:`, `eli:`, `geodcatap:`, `adms:`, `skos:`) | ✅ **Safe** | Purely additive. New prefix declarations never alter how existing terms expand. Existing documents re-processed with the new context produce the same triples plus new vocabulary availability. |
| **Add `@type: "@id"` coercion for URI-typed fields** (`connector_url`, `self_description_url`, `data_space.id`) | ✅ **Safe** | These fields already carry `"format": "uri"` in `schema.json`. All valid existing values are already URIs. The coercion changes JSON-LD expansion of these from `xsd:string` literals to IRI nodes — this is the semantically correct representation and does not break any existing data values. |
| **Add `@type: dcat:DataService`** to `liability:data_space` via scoped context | ⚠️ **Soft-breaking for RDF consumers** | Adds a new `rdf:type` triple to the expanded graph. Consumers doing type-based routing (e.g., SPARQL `?x a dcat:DataService`) will start matching previously unmatched nodes. This is semantically correct and desirable, but changes the RDF graph shape. **Mitigation:** Only apply in the opt-in `geodcat-ap.json` sub-schema, not in the base `context.jsonld`. |
| **Add `"role": { "@id": "dcat:hadRole", "@type": "@vocab" }` scoped term** | ❌ **Breaking for JSON-LD consumers** | `@type: "@vocab"` expands the role string to an IRI against `@vocab`. Currently `"role": "originator"` produces `"originator"^^xsd:string`; with the coercion it would produce `<https://...#originator>`. This changes triple structure. **Mitigation:** Exclude this from base `context.jsonld`. Include only in opt-in `geodcat-ap.json` with a clearly documented v1.7.0 annotation. |
| **Add `@id` mappings for `permission`/`prohibition`/`obligation` → `odrl:` terms** | ⚠️ **Soft-breaking for RDF consumers** | Changes IRI expansion of ODRL fields. Non-breaking for JSON consumers; changes RDF graph structure. **Mitigation:** Same opt-in sub-schema pattern. |

### 5.4 RDF Semantic Layer

Even with context-only changes, JSON-LD expansion changes what triples are produced from existing documents:

| Scenario | Before | After (base context update) | Verdict |
|---|---|---|---|
| Existing item processed with updated `context.jsonld` | 0 `dct:` triples | `dct:spatial` / `dct:temporal` / etc. triples now resolvable | ✅ Additive only |
| `connector_url` value in expanded graph | `"https://..."^^xsd:string` | `<https://...>` (IRI node) | ✅ Correct fix |
| `legal_jurisdiction: "EU"` | `"EU"^^xsd:string` | `"EU"^^xsd:string` (unchanged — no coercion without term def) | ✅ Unchanged |
| `role: "originator"` (if scoped context applied) | `"originator"^^xsd:string` | `<https://...#originator>` IRI | ❌ Breaking — opt-in only |

### 5.5 Backward Compatibility Decision Matrix

| Change | Apply in base `context.jsonld` now (v1.6.x)? | Apply in opt-in `geodcat-ap.json` (v1.7.0)? |
|---|---|---|
| Add 9 missing namespace prefixes | ✅ Yes | — |
| Fix `@vocab` version v1.1.0 → v1.6.0 | ✅ Yes (bug fix) | — |
| `@type: "@id"` for URI fields | ✅ Yes | — |
| `dcat:DataService` type for data_space | ❌ No | ✅ Yes |
| Agent role `@type: "@vocab"` coercion | ❌ No | ✅ Yes |
| ODRL term `@id` mappings | ❌ No | ✅ Yes |
| Fix `responsible_party` string→object schema | ✅ Yes (bug fix, v1.6.1) | — |
| `legal_jurisdiction` ELI URI guidance | Documentation only | ✅ Yes |

### 5.6 Correction to Section 3.4 (`participant_role`)

The compatibility matrix in section 3.4 contained an error: `data_space.participant_role` was listed as mapping to `geodcatap:serviceType`. That mapping is incorrect.

- `geodcatap:serviceType` is for the OGC/INSPIRE spatial data service type (e.g., download, view, discovery service)
- `participant_role` (`provider`/`consumer`/`intermediary`/`operator`) is an ISO 20151 data space role

The correct GeoDCAT-AP mapping for participant role is `dcat:hadRole` (qualified attribution pattern) on the `dcat:DataService` representing the connector, with a role value from an ISO 20151 or IDS/Gaia-X role vocabulary:

```turtle
<https://connector.example.org/> a dcat:DataService ;
  prov:qualifiedAttribution [
    a prov:Attribution ;
    prov:agent <did:web:4113engineering.com> ;
    dcat:hadRole <https://w3id.org/idsa/code/PROVIDER>
  ] .
```

---

## 6. Recommended `context.jsonld` Additions

The following additions to `context.jsonld` resolve all critical and secondary namespace gaps (all Safe/non-breaking per the matrix in §5.5):

```json
{
  "@context": {
    "@version": 1.1,
    "@vocab": "https://stac-extensions.github.io/liability-claims/v1.6.0/schema.json#",

    "xsd":     "http://www.w3.org/2001/XMLSchema#",
    "dcat":    "http://www.w3.org/ns/dcat#",
    "dqv":     "http://www.w3.org/ns/dqv#",
    "prov":    "http://www.w3.org/ns/prov#",
    "foaf":    "http://xmlns.com/foaf/0.1/",
    "schema":  "http://schema.org/",
    "fibo-fnd":"https://spec.edmcouncil.org/fibo/ontology/FND/",
    "legal":   "http://www.w3.org/ns/legal#",
    "ceosard": "https://ceos.org/ard/ontology#",
    "iso19157":"https://def.isotc211.org/iso19157/-3/dqm/1.0/",

    "dct":      "http://purl.org/dc/terms/",
    "odrl":     "http://www.w3.org/ns/odrl/2/",
    "vcard":    "http://www.w3.org/2006/vcard/ns#",
    "locn":     "http://www.w3.org/ns/locn#",
    "gsp":      "http://www.opengis.net/ont/geosparql#",
    "eli":      "http://data.europa.eu/eli/ontology#",
    "geodcatap":"http://data.europa.eu/930/",
    "adms":     "http://www.w3.org/ns/adms#",
    "skos":     "http://www.w3.org/2004/02/skos/core#",

    "liability":"https://stac-extensions.github.io/liability-claims/v1.6.0/schema.json#liability:",
    "ard":      "https://stac-extensions.github.io/liability-claims/v1.6.0/schema.json#ard:",
    "dq":       "https://stac-extensions.github.io/liability-claims/v1.6.0/schema.json#dq:"
  }
}
```

---

## 7. Worked Mapping Examples

### 6.1 STAC Item → GeoDCAT-AP Dataset (Turtle)

```turtle
@prefix dcat:    <http://www.w3.org/ns/dcat#> .
@prefix dct:     <http://purl.org/dc/terms/> .
@prefix dqv:     <http://www.w3.org/ns/dqv#> .
@prefix prov:    <http://www.w3.org/ns/prov#> .
@prefix odrl:    <http://www.w3.org/ns/odrl/2/> .
@prefix vcard:   <http://www.w3.org/2006/vcard/ns#> .
@prefix locn:    <http://www.w3.org/ns/locn#> .
@prefix gsp:     <http://www.opengis.net/ont/geosparql#> .
@prefix eli:     <http://data.europa.eu/eli/ontology#> .
@prefix geodcatap: <http://data.europa.eu/930/> .
@prefix adms:    <http://www.w3.org/ns/adms#> .
@prefix xsd:     <http://www.w3.org/2001/XMLSchema#> .

<https://example.org/claims/claim-001> a dcat:Dataset ;
  # -- Core identification -------------------------------------------------
  dct:identifier   "claim-001" ;
  dct:title        "Flood damage claim – 2023 Red River event"@en ;
  dct:description  "Insurance liability claim for agricultural losses."@en ;
  dct:issued       "2023-09-15"^^xsd:date ;

  # -- Temporal coverage ---------------------------------------------------
  dct:temporal [ a dct:PeriodOfTime ;
    dcat:startDate "2023-08-01"^^xsd:date ;
    dcat:endDate   "2023-09-14"^^xsd:date ] ;

  # -- Spatial coverage (liability:coverage_area) -------------------------
  dct:spatial [ a dct:Location ;
    dcat:bbox """POLYGON((96.0 -44.0, 96.0 -10.0, 
                          168.0 -10.0, 168.0 -44.0, 
                          96.0 -44.0))"""^^gsp:wktLiteral ] ;

  # -- Claim status (liability:claim_status) --------------------------------
  adms:status <http://publications.europa.eu/resource/authority/dataset-status/COMPLETED> ;
  dct:type    <https://stac-extensions.github.io/liability-claims/vocab/claim-type/agricultural> ;

  # -- Responsible party (liability:responsible_party) --------------------
  dct:publisher [ a foaf:Organization ;
    foaf:name "Australian Insurance Authority"@en ] ;
  geodcatap:custodian [ a foaf:Organization ;
    foaf:name "Department of Agriculture"@en ] ;
  dcat:contactPoint [ a vcard:Organization ;
    vcard:fn "Claims Team"@en ;
    vcard:hasEmail <mailto:claims@example.org> ] ;

  # -- Applicable legislation (liability:legal_jurisdiction) ---------------
  dct:conformsTo <https://www.legislation.gov.au/Series/C2004A01468> ;  # Insurance Act 1973

  # -- Usage policy (liability:usage_policy) --------------------------------
  odrl:hasPolicy [
    a odrl:Agreement ;
    odrl:permission [ odrl:action odrl:read ;
      odrl:assignee <https://example.org/parties/insurer-001> ] ;
    odrl:prohibition [ odrl:action odrl:distribute ] ] ;

  # -- Access rights -------------------------------------------------------
  dct:accessRights <http://publications.europa.eu/resource/authority/access-right/RESTRICTED> ;
  dct:license     <https://creativecommons.org/licenses/by/4.0/> ;

  # -- Quality / Lineage (dq:lineage) ----------------------------------------
  dct:provenance [ a dct:ProvenanceStatement ;
    dct:description "Derived from field survey GPS data, DEM analysis and hydrological modelling."@en ] ;

  dqv:hasQualityMeasurement [ a dqv:QualityMeasurement ;
    dqv:isMeasurementOf geodcatap:spatialResolutionAsDistance ;
    dqv:value "10.0"^^xsd:decimal ] ;

  # -- Provenance conformance test (quality_report.prov) -------------------
  prov:wasUsedBy [ a prov:Activity ;
    prov:generated [ a prov:Entity ;
      dct:type <http://inspire.ec.europa.eu/metadata-codelist/DegreeOfConformity/conformant> ;
      dct:description "Conforms to ISO 19157:2023 completeness threshold"@en ] ;
    prov:qualifiedAssociation [ a prov:Association ;
      prov:hadPlan [ a prov:Plan ;
        prov:wasDerivedFrom [ a dct:Standard ;
          dct:title "ISO 19157:2023 Geographic information — Data quality"@en ] ] ] ] ;

  # -- Asset / Distribution ------------------------------------------------
  dcat:distribution [ a dcat:Distribution ;
    dcat:accessURL <https://example.org/claims/claim-001/assets/damage-assessment.geojson> ;
    dct:format <http://publications.europa.eu/resource/authority/file-type/JSON> ;
    dcat:mediaType <http://www.iana.org/assignments/media-types/application/geo+json> ] .
```

### 6.2 Data Space Connector → `dcat:DataService` (Turtle)

```turtle
@prefix dcat:    <http://www.w3.org/ns/dcat#> .
@prefix dct:     <http://purl.org/dc/terms/> .
@prefix geodcatap: <http://data.europa.eu/930/> .

<https://connector.dataspace-claims.example.org/> a dcat:DataService ;
  dct:title           "Claims Data Space Connector"@en ;
  dcat:endpointURL    <https://connector.dataspace-claims.example.org/api/v1/> ;
  dcat:endpointDescription <https://connector.dataspace-claims.example.org/api/v1/openapi.json> ;
  geodcatap:serviceType <https://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/download> ;
  dcat:servesDataset  <https://example.org/claims/claim-001> .
```

---

## 8. Recommendations for v1.7.0

### 7.1 Add GeoDCAT-AP Annotation Sub-Schema

Create `v1.7.0/geodcat-ap.json` as an optional sub-schema. This is the safe container for all breaking JSON-LD coercions identified in §5.3. Declared via:

```json
"stac_extensions": [
  "https://stac-extensions.github.io/liability-claims/v1.7.0/schema.json",
  "https://stac-extensions.github.io/liability-claims/v1.7.0/geodcat-ap.json"
]
```

### 7.2 Add JSON-LD Term Definitions for Agent Role Mapping

In `context.jsonld`, add scoped term definitions so that `liability:responsible_party` role values expand to the correct GeoDCAT-AP properties:

```json
"liability:responsible_party": {
  "@context": {
    "role": {
      "@id": "dcat:hadRole",
      "@type": "@vocab"
    }
  }
}
```

Combined with a `@type: prov:Attribution` alias, this enables the qualified attribution pattern from DCAT 3 / GeoDCAT-AP.

### 7.3 Add ELI URI Guidance for `liability:legal_jurisdiction`

Document that `liability:legal_jurisdiction` values SHOULD be ELI-compliant URIs (e.g., `http://data.europa.eu/eli/reg/2016/679/oj` for GDPR) and add `eli:` to `context.jsonld`. This makes the field directly interpretable as `dcatap:applicableLegislation`.

### 7.4 Add `dcat:DataService` Type to `liability:data_space`

Add a `@type` alias in context so that `liability:data_space` automatically types its connector as `dcat:DataService`:

```json
"liability:data_space": {
  "@context": {
    "connector_url": { "@id": "dcat:endpointURL", "@type": "@id" },
    "self_description_url": { "@id": "dcat:endpointDescription", "@type": "@id" }
  }
}
```

### 7.5 Declare GeoDCAT-AP Conformance

Once `context.jsonld` is updated with the namespaces in Section 5, add the following to item and collection examples:

```json
"conformsTo": ["http://data.europa.eu/930/"]
```

This declares conformance to GeoDCAT-AP in GeoDCAT-AP's own metadata pattern (`dct:conformsTo`).

---

## 9. Conformance Level Assessment

Using GeoDCAT-AP's own conformance tiers:

| Conformance Level | Status | Blocking Issues |
|---|---|---|
| **DCAT 3 Core** | ⚠️ Partial | `dct:` namespace missing; assets are not typed as `dcat:Distribution` explicitly |
| **DCAT-AP 3** | ⚠️ Partial | `dct:publisher` (mandatory), `dct:title`, `dct:description` not mapped in context |
| **GeoDCAT-AP 3.0.0 Core** | ⚠️ Partial | `dct:spatial`, `dct:temporal` for STAC geometry/datetime not mapped; `locn:` missing |
| **GeoDCAT-AP 3.0.0 Extended** | ❌ Not conformant | Agent roles, legal resources, quality binding via `dqv:` (partially met), `prov:` conformance test pattern (partially met) |

With the namespace additions from §6 and the bug fixes from §5.5 (v1.6.1 patch), the extension reaches **GeoDCAT-AP 3.0.0 Core conformance** without breaking changes to any existing STAC or JSON-LD consumers.

Full **GeoDCAT-AP 3.0.0 Extended conformance** requires the opt-in sub-schema work items in §8.

---

## 10. Standards Alignment Summary

| Standard | Current Status | After §6 Fixes + §5.5 Bug Fixes (v1.6.1) |
|---|---|---|
| DCAT 3 (W3C) | Partial | ✅ Core conformant |
| DCAT-AP 3 (EU) | Partial | ✅ Core conformant |
| GeoDCAT-AP 3.0.0 Core | Partial | ✅ Core conformant |
| GeoDCAT-AP 3.0.0 Extended | Not conformant | Partial (v1.7.0 needed for full) |
| ISO 19115-1:2014 | ✅ (via existing fields) | ✅ (unchanged) |
| ISO 19157-1:2023 | ✅ (via `dqv:`) | ✅ (unchanged) |
| ISO 20151 Data Spaces | ✅ (via ODRL + data_space) | ✅ (DataService typing added) |
| W3C PROV-O | ✅ (via `prov:`) | ✅ (unchanged) |
| ODRL | Strong (structural) | ✅ Formally typed |
| ELI (Legal Resource) | ❌ | ✅ (with `eli:` prefix) |

---

*Document generated from GeoDCAT-AP 3.0.0 specification analysis (https://semiceu.github.io/GeoDCAT-AP/releases/3.0.0/) and DCAT 3 (https://www.w3.org/TR/vocab-dcat-3/).*
