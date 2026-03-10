# STAC Extension: Liability Claims v1.6.0

**Version:** 1.6.0  
**STAC Version:** 1.0.0  
**Extension Maturity:** Stable  
**Owner:** @luciocola

This version adds **ISO 20151 Data Spaces interoperability** to the existing
data quality (ISO 19157), provenance (W3C PROV), and interpretability (NIIRS)
features of v1.5.0. It enables STAC Items to participate in federated data
spaces (GAIA-X, IDS, Eclipse Dataspace Components) with machine-readable usage
policies, formal data contracts, and data sovereignty constraints.

---

## What's New in v1.6.0

### 🆕 ISO 20151 Data Spaces Support

Four new optional fields implement the ISO/IEC 20151 Data Spaces framework:

| Field | ISO 20151 Clause | Purpose |
|-------|-----------------|---------|
| `liability:data_space` | §5 / §6 | Data space ID, connector URL, participant role |
| `liability:usage_policy` | §8 | ODRL-based usage policy (permissions, prohibitions, obligations) |
| `liability:data_contract` | §9 | Executed contract reference with expiry and signatories |
| `liability:sovereignty` | §7 | Data residency, purpose, retention, export restrictions |

### Legacy Features (unchanged from v1.5.0)

- **ISO 19157-1:2023 DQ Elements** — data quality metadata
- **ISO 19115-2:2019 / ISO 19115-4** — sensor and lineage quality
- **W3C PROV** — provenance tracing
- **NIIRS** — National Imagery Interpretability Rating Scale
- **EOVOC v0.0.2** — Earth Observation Vocabulary alignment
- **ARD** — Analysis-Ready Data compliance fields
- **DGIWG** — Defence Geospatial Interoperability Working Group fields

---

## New Field Documentation

### `liability:data_space`

Identifies the data space ecosystem and the participant's role.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | string (URI) | **Yes** | Unique URI/DID of the data space |
| `participant_role` | enum | **Yes** | `provider`, `consumer`, `intermediary`, or `operator` |
| `name` | string | No | Human-readable data space name |
| `operator` | string | No | DID/URL of the data space operator |
| `connector_url` | string (URI) | No | IDS / EDC connector endpoint URL |
| `self_description_url` | string (URI) | No | Participant JSON-LD self-description |

```json
"liability:data_space": {
  "id": "https://gaia-x.eu/spaces/copernicus-emergency-data-space",
  "name": "Copernicus Emergency Management Data Space",
  "operator": "did:web:dataspace-operator.copernicus.eu",
  "connector_url": "https://connector.4113engineering.com/ids/data",
  "participant_role": "provider",
  "self_description_url": "https://4113engineering.com/.well-known/gaia-x-self-description.jsonld"
}
```

---

### `liability:usage_policy`

Machine-readable usage policy using W3C ODRL vocabulary (ISO 20151 §8).

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `policy_id` | string (URI) | No | Unique URI for this policy |
| `policy_type` | enum | No | `Set`, `Offer`, or `Agreement` |
| `target` | string | No | URI/DID of the governed asset |
| `assigner` | string | No | DID of the data provider |
| `assignee` | string | No | DID of the data consumer (omit for open policies) |
| `permission` | array | No | Permitted ODRL actions |
| `prohibition` | array | No | Prohibited ODRL actions |
| `obligation` | array | No | Required duties (delete after N days, attribute, etc.) |

Each rule in `permission`, `prohibition`, `obligation` takes:
- `action` (required): ODRL action string (e.g. `use`, `reproduce`, `commercialize`, `sublicense`, `distribute`, `attribute`, `delete`)
- `constraint` (optional): array of `{leftOperand, operator, rightOperand}` triples

**Common ODRL actions:**

| Action | Meaning |
|--------|---------|
| `use` | Access and process the asset |
| `reproduce` | Copy the asset |
| `distribute` | Share with third parties |
| `commercialize` | Use for commercial purposes |
| `sublicense` | Grant rights to others |
| `attribute` | Credit the data provider |
| `delete` | Delete after constraint period |

**Common ODRL constraints:**

| leftOperand | Example value |
|------------|---------------|
| `purpose` | `https://w3id.org/dpv#EmergencyManagement` |
| `spatialArea` | `ISO3166:EU` |
| `elapsedTime` | `P180D` (ISO 8601 duration) |
| `dateTime` | `2026-12-31T23:59:59Z` |

```json
"liability:usage_policy": {
  "policy_id": "https://provider.org/policies/flood-data-2026",
  "policy_type": "Offer",
  "assigner": "did:web:provider.org",
  "permission": [
    {
      "action": "use",
      "constraint": [
        {
          "leftOperand": "purpose",
          "operator": "isA",
          "rightOperand": "https://w3id.org/dpv#EmergencyManagement"
        }
      ]
    }
  ],
  "prohibition": [
    { "action": "commercialize" }
  ],
  "obligation": [
    {
      "action": "delete",
      "constraint": [
        { "leftOperand": "elapsedTime", "operator": "lteq", "rightOperand": "P180D" }
      ]
    }
  ]
}
```

---

### `liability:data_contract`

Reference to the formally executed data contract (ISO 20151 §9).

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `contract_id` | string | **Yes** | Unique contract identifier (URN/UUID/URI) |
| `contract_date` | string (datetime) | No | Execution timestamp |
| `expiry_date` | string (datetime) | No | Contract expiry |
| `policy_ref` | string (URI) | No | URI of the governing ODRL policy |
| `signed_by` | array[string] | No | DIDs of signatories (provider first) |
| `status` | enum | No | `pending`, `active`, `expired`, `terminated` |

```json
"liability:data_contract": {
  "contract_id": "urn:uuid:3f2504e0-4f89-11d3-9a0c-0305e82c3301",
  "contract_date": "2026-01-15T10:00:00Z",
  "expiry_date": "2026-07-14T23:59:59Z",
  "policy_ref": "https://provider.org/policies/flood-data-2026",
  "signed_by": [
    "did:web:provider.org",
    "did:web:consumer.research-institute.eu"
  ],
  "status": "active"
}
```

---

### `liability:sovereignty`

Data sovereignty constraints (ISO 20151 §7), aligned with GDPR Art. 5 and
GAIA-X Trust Framework §4.3.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `data_residency` | array[string] | No | ISO 3166-1 alpha-2 or regional codes (e.g. `EU`) |
| `purpose` | string (URI) | No | W3C DPV purpose URI |
| `purpose_description` | string | No | Human-readable declared purpose |
| `retention_days` | integer | No | Maximum retention period in days |
| `export_restrictions` | array[string] | No | Country codes data may NOT be exported to |
| `redistribution_allowed` | boolean | No | May the consumer redistribute? |
| `anonymisation_required` | boolean | No | Must personal data be anonymised? |
| `gdpr_basis` | enum | No | GDPR Art. 6 legal basis |
| `data_classification` | string | No | Classification level |

```json
"liability:sovereignty": {
  "data_residency": ["EU"],
  "purpose": "https://w3id.org/dpv#EmergencyManagement",
  "purpose_description": "Flood extent mapping for humanitarian emergency response",
  "retention_days": 180,
  "export_restrictions": ["RU", "KP"],
  "redistribution_allowed": false,
  "anonymisation_required": false,
  "gdpr_basis": "public_task",
  "data_classification": "official-sensitive"
}
```

---

## Framework Alignment

| Standard / Framework | Support |
|---------------------|---------|
| **ISO/IEC 20151** — Data Spaces Framework | ✅ v1.6.0 |
| **W3C ODRL 2.2** — Usage Policy language | ✅ v1.6.0 |
| **W3C DPV 2.0** — Data Privacy Vocabulary (purposes) | ✅ v1.6.0 |
| **GAIA-X Trust Framework 22.10** | ✅ v1.6.0 |
| **IDS Reference Architecture Model 4.2** | ✅ v1.6.0 |
| **Eclipse Dataspace Components (EDC)** | ✅ v1.6.0 |
| **GDPR Art. 5** — Data governance principles | ✅ v1.6.0 |
| **ISO 19157-1:2023** — Data quality | ✅ v1.5.0+ |
| **W3C PROV** — Provenance | ✅ v1.3.0+ |
| **NIIRS** | ✅ v1.5.0+ |

---

## Backward Compatibility

✅ **Fully backward compatible with v1.5.0**

All four new fields (`liability:data_space`, `liability:usage_policy`,
`liability:data_contract`, `liability:sovereignty`) are optional. Existing
v1.5.0 items remain valid under the v1.6.0 schema without any changes.

---

## Schema URL

```
https://luciocola.github.io/stac-extension-liability-claims/v1.6.0/schema.json
```

---

## References

- ISO/IEC 20151 — Information technology — Data spaces — Framework and concepts
- W3C ODRL Information Model 2.2: https://www.w3.org/TR/odrl-model/
- W3C ODRL Vocabulary & Expression 2.2: https://www.w3.org/TR/odrl-vocab/
- W3C Data Privacy Vocabulary (DPV) 2.0: https://w3id.org/dpv
- GAIA-X Trust Framework 22.10: https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/
- IDS Reference Architecture Model 4.2: https://internationaldataspaces.org/download/19008/
- Eclipse Dataspace Components: https://eclipse-edc.github.io/docs/
- GDPR Regulation (EU) 2016/679 Art. 5
