# STAC Extension Liability Claims — ISO 20151 Data Spaces Compatibility Analysis

**Version:** 1.0  
**Date:** March 2026  
**Applies to:** STAC Extension Liability Claims v1.5.0 → v1.6.0 roadmap  
**Reference standard:** ISO/IEC 20151 — Information technology — Data spaces — Framework and concepts  

---

## 1. Executive Summary

ISO/IEC 20151 defines the conceptual framework and normative vocabulary for **data spaces** — federated data-sharing ecosystems in which multiple participants (providers, consumers, intermediaries) exchange data under negotiated terms while preserving **data sovereignty** and **usage policy enforcement**.

The STAC Liability Claims Extension already implements several data-space-relevant
mechanisms: W3C PROV-JSON provenance, ISO 19157 quality declarations, DID-based
identity, and Verifiable Credentials for content integrity. However, critical
ISO 20151 constructs — notably **Usage Policies (ODRL)**, **Data Offerings**, formal
**Data Contracts**, **Data Space identity**, and **Sovereignty constraints** — are
not yet represented in the extension schema.

This document maps existing fields to ISO 20151 concepts, identifies gaps, and
defines the new fields proposed for **v1.6.0**.

### Compatibility Score: 3.5 / 5 ⭐

| Category | Score | Notes |
|----------|-------|-------|
| Data provenance | ✅ 5/5 | `liability:prov` (W3C PROV) fully covers lineage |
| Data quality | ✅ 5/5 | `liability:quality` (ISO 19157) fully covers quality assurance |
| Identity & trust | ✅ 4/5 | VCs + DIDs present; Role vocabulary absent |
| Legal jurisdiction | ✅ 4/5 | `liability:legal_jurisdiction` present |
| Usage policy | ❌ 0/5 | ODRL-based usage policy entirely absent |
| Data offering / contract | ❌ 0/5 | No data offering or contract reference fields |
| Data sovereignty | ❌ 1/5 | Jurisdiction exists; residency/purpose/retention absent |
| Data space identity | ❌ 0/5 | No data space URI or connector endpoint fields |

---

## 2. ISO 20151 Framework — Key Concepts

ISO/IEC 20151 organises a data space around seven conceptual pillars:

### 2.1 Participants and Roles

| Role | Description |
|------|-------------|
| **Data Provider** | Owns and makes data available; sets terms of use |
| **Data Consumer** | Requests and uses data under agreed terms |
| **Data Intermediary** | Facilitates matching, brokering, or cataloguing between parties |
| **Data Space Operator** | Deploys and maintains the data space infrastructure (connectors, registry) |
| **Identity Provider** | Issues and verifies participant credentials (DID/VC ecosystem) |

### 2.2 Data Offering and Contract

A **Data Offering** is the formal description of a dataset made available, including:

- Asset identification (URI/DID)
- Quality declaration
- Applicable usage policies (ODRL)
- Access conditions (who can consume)
- Certification anchors (VCs)

A **Data Contract** is the machine-readable agreement between a provider and a
consumer, referencing the offering, the ODRL policy agreed upon, the contract
period, and the signatories (DIDs).

### 2.3 Usage Policy (ODRL)

ISO 20151 mandates or strongly recommends **ODRL (W3C Open Digital Rights Language)**
for expressing usage policies, consisting of:

- `permission` — actions the consumer may perform (e.g., `use`, `reproduce`, `distribute`)
- `prohibition` — actions the consumer may NOT perform (e.g., `commercialize`, `sublicense`)
- `obligation` — required actions (e.g., `attribute`, `report`, `delete after N days`)
- `constraint` — conditions on permissions (e.g., spatial extent, time window, purpose)

### 2.4 Data Sovereignty

Data sovereignty requires that the data provider retains **effective control** over
data after transfer. Relevant constraints include:

- **Data residency**: geographic location where data may be stored and processed
- **Purpose limitation**: the explicit declared purpose for which data is accessed
- **Retention period**: maximum duration for which the consumer may retain the data
- **Export restrictions**: jurisdictions to which data may not be re-exported

### 2.5 Data Space Identity

Each data space has a unique identifier (`data_space_id`). Each participant registers
a **Connector** (IDS/EDC-compatible endpoint) and a **Self-Description** that
references their verifiable credentials. The Self-Description is typically expressed
in JSON-LD.

### 2.6 Trust Framework

Participants establish trust via:

- **Trust Anchors** — accredited Certification Authority or DID method
- **Verifiable Credentials** (VC 1.0/2.0) — issued by Identity Providers
- **Connector Certificates** — TLS/mTLS certificates tied to participant DID

---

## 3. Field Mapping: ISO 20151 → Liability Claims Extension v1.5.0

### 3.1 Covered Concepts (existing fields)

| ISO 20151 Concept | Liability Claims Field | Coverage | Notes |
|------------------|----------------------|----------|-------|
| Data Provider identity | `liability:responsible_party` | ✅ Partial | Name/role present; DID reference not structured |
| Participant credentials (trust) | VCs (via `liability:integrity`) | ✅ Covered | VC 1.0/2.0 wrapping STAC Items |
| Asset identity | STAC Item `id` + `liability:claim_id` | ✅ Covered | |
| Data quality declaration | `liability:quality` (ISO 19157) | ✅ Covered | Full ISO 19157-1:2023 support |
| Data provenance | `liability:prov` (W3C PROV-JSON) | ✅ Covered | Full lineage tracing |
| Legal jurisdiction | `liability:legal_jurisdiction` | ✅ Covered | Free text; ISO 3166-1 recommended |
| Legal claims (liability/insurance) | `liability:claim_*` fields | ✅ Covered | Core extension purpose |
| Imagery interpretability | `liability:niirs` | ✅ Covered | v1.5.0 addition |
| ARD compliance | `ard:*` fields | ✅ Covered | |

### 3.2 Gaps (missing ISO 20151 concepts)

| ISO 20151 Concept | Gap Description | Priority |
|------------------|----------------|----------|
| **Usage Policy (ODRL)** | No field for machine-readable ODRL policy (permissions, prohibitions, obligations) | 🔴 High |
| **Data Offering** | No structured formal offering record with policy and access terms | 🔴 High |
| **Data Contract reference** | No contract ID, contract date, expiry, or signatory DIDs | 🔴 High |
| **Data Space identity** | No data space URI or operator reference | 🟡 Medium |
| **Connector endpoint** | No IDS/EDC connector URL for protocol negotiation | 🟡 Medium |
| **Participant role** | `liability:responsible_party.role` exists but does not use ISO 20151 role vocabulary | 🟡 Medium |
| **Data residency constraints** | `liability:legal_jurisdiction` exists but does not cover storage location | 🟡 Medium |
| **Data purpose** | No declared purpose field (required by GDPR Art. 5 + ISO 20151) | 🔴 High |
| **Retention period** | No maximum retention duration field | 🟡 Medium |
| **Export restrictions** | No re-export restriction declarations | 🟡 Medium |
| **Self-description reference** | No JSON-LD self-description URI for the participant | 🟢 Low |
| **Catalog / Connector ID** | No reference to data space catalog entry | 🟢 Low |

---

## 4. Proposed New Fields for v1.6.0

### 4.1 `liability:data_space`

Identifies the data space ecosystem in which this STAC Item is shared.

```json
"liability:data_space": {
  "id": "https://gaia-x.eu/spaces/sentinel-consortium",
  "name": "Sentinel Data Space — OGC Testbed-21",
  "operator": "did:web:dataspaceoperator.example.org",
  "connector_url": "https://connector.provider.example.org/ids/data",
  "participant_role": "provider",
  "self_description_url": "https://provider.example.org/.well-known/self-description.jsonld"
}
```

Schema definition:

```json
"liability:data_space": {
  "type": "object",
  "title": "Data Space Participation",
  "description": "ISO 20151 — identifies the data space ecosystem and the participant role for this STAC asset",
  "required": ["id", "participant_role"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uri",
      "description": "Unique URI/DID identifier of the data space"
    },
    "name": {
      "type": "string",
      "description": "Human-readable name of the data space"
    },
    "operator": {
      "type": "string",
      "description": "DID or URL of the data space operator"
    },
    "connector_url": {
      "type": "string",
      "format": "uri",
      "description": "IDS / EDC connector endpoint URL for protocol negotiation"
    },
    "participant_role": {
      "type": "string",
      "enum": ["provider", "consumer", "intermediary", "operator"],
      "description": "ISO 20151 participant role for this asset record"
    },
    "self_description_url": {
      "type": "string",
      "format": "uri",
      "description": "URL of the participant JSON-LD self-description document"
    }
  }
}
```

---

### 4.2 `liability:usage_policy`

ODRL-aligned usage policy declaring what a data consumer may and may not do with
this asset. Directly maps to ISO 20151 §8 (Usage Policy Requirements) and the
W3C ODRL Information Model.

```json
"liability:usage_policy": {
  "policy_id": "https://provider.example.org/policies/sentinel-s2/public-research-2026",
  "policy_type": "Set",
  "target": "https://provider.example.org/assets/NOAA_AVHRR_L1B_001",
  "assigner": "did:web:provider.example.org",
  "permission": [
    {
      "action": "use",
      "constraint": [
        {
          "leftOperand": "purpose",
          "operator": "isA",
          "rightOperand": "https://w3id.org/dpv#ResearchAndDevelopment"
        }
      ]
    },
    {
      "action": "reproduce",
      "constraint": [
        {
          "leftOperand": "spatialArea",
          "operator": "isPartOf",
          "rightOperand": "ISO3166:EU"
        }
      ]
    }
  ],
  "prohibition": [
    { "action": "commercialize" },
    { "action": "sublicense" }
  ],
  "obligation": [
    {
      "action": "attribute",
      "target": "did:web:provider.example.org"
    },
    {
      "action": "delete",
      "constraint": [
        {
          "leftOperand": "elapsedTime",
          "operator": "lteq",
          "rightOperand": "P365D"
        }
      ]
    }
  ]
}
```

Schema definition:

```json
"liability:usage_policy": {
  "type": "object",
  "title": "Usage Policy (ODRL)",
  "description": "ISO 20151 §8 — machine-readable usage policy for this asset using W3C ODRL vocabulary",
  "properties": {
    "policy_id": {
      "type": "string",
      "format": "uri",
      "description": "Unique URI identifying this policy"
    },
    "policy_type": {
      "type": "string",
      "enum": ["Set", "Offer", "Agreement"],
      "description": "ODRL policy type: Set (template), Offer (from provider), Agreement (bilateral)"
    },
    "target": {
      "type": "string",
      "description": "URI/DID of the asset this policy governs"
    },
    "assigner": {
      "type": "string",
      "description": "DID/URI of the data provider (policy issuer)"
    },
    "assignee": {
      "type": "string",
      "description": "DID/URI of the data consumer; omit for open/public policies"
    },
    "permission": {
      "type": "array",
      "items": { "$ref": "#/definitions/odrl_rule" },
      "description": "Permitted actions"
    },
    "prohibition": {
      "type": "array",
      "items": { "$ref": "#/definitions/odrl_rule" },
      "description": "Prohibited actions"
    },
    "obligation": {
      "type": "array",
      "items": { "$ref": "#/definitions/odrl_rule" },
      "description": "Required actions (duties)"
    }
  }
}
```

---

### 4.3 `liability:data_contract`

Machine-readable reference to the formally executed Data Contract between provider
and consumer as defined in ISO 20151 §9.

```json
"liability:data_contract": {
  "contract_id": "urn:uuid:8a3d1f2c-994a-4e1b-b887-029fa3e21d7a",
  "contract_date": "2026-01-15T09:00:00Z",
  "expiry_date": "2027-01-14T23:59:59Z",
  "policy_ref": "https://provider.example.org/policies/sentinel-s2/public-research-2026",
  "signed_by": [
    "did:web:provider.example.org",
    "did:web:consumer.research-institute.eu"
  ],
  "status": "active"
}
```

Schema definition:

```json
"liability:data_contract": {
  "type": "object",
  "title": "Data Contract",
  "description": "ISO 20151 §9 — reference to the executed data contract governing use of this asset",
  "required": ["contract_id"],
  "properties": {
    "contract_id": {
      "type": "string",
      "description": "Unique contract identifier (URN, UUID, or URI)"
    },
    "contract_date": {
      "type": "string",
      "format": "date-time",
      "description": "Date and time the contract was executed"
    },
    "expiry_date": {
      "type": "string",
      "format": "date-time",
      "description": "Contract expiry; consumer must delete or re-negotiate after this date"
    },
    "policy_ref": {
      "type": "string",
      "format": "uri",
      "description": "URI of the ODRL usage policy agreed upon in this contract"
    },
    "signed_by": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Array of DIDs of signatories (provider first, then consumers)"
    },
    "status": {
      "type": "string",
      "enum": ["pending", "active", "expired", "terminated"],
      "description": "Current contract status"
    }
  }
}
```

---

### 4.4 `liability:sovereignty`

Extends the existing `liability:legal_jurisdiction` with the full set of data
sovereignty constraints required by ISO 20151 §7 and aligned with GDPR Art. 5
and GAIA-X Trust Framework §4.3.

```json
"liability:sovereignty": {
  "data_residency": ["EU", "US-CA"],
  "purpose": "https://w3id.org/dpv#ResearchAndDevelopment",
  "purpose_description": "Scientific research into flood extent mapping using multi-temporal SAR imagery",
  "retention_days": 365,
  "export_restrictions": ["RU", "CN", "KP"],
  "redistribution_allowed": false,
  "anonymisation_required": false,
  "gdpr_basis": "legitimate_interest",
  "data_classification": "official-sensitive"
}
```

Schema definition:

```json
"liability:sovereignty": {
  "type": "object",
  "title": "Data Sovereignty Constraints",
  "description": "ISO 20151 §7 — data sovereignty constraints governing where, how and for how long this asset may be used",
  "properties": {
    "data_residency": {
      "type": "array",
      "items": { "type": "string" },
      "description": "ISO 3166-1 alpha-2 country codes or regional codes (e.g. 'EU') where data may reside and be processed"
    },
    "purpose": {
      "type": "string",
      "format": "uri",
      "description": "Machine-readable purpose URI, preferably from W3C DPV (https://w3id.org/dpv)"
    },
    "purpose_description": {
      "type": "string",
      "description": "Human-readable description of the declared purpose of data use"
    },
    "retention_days": {
      "type": "integer",
      "minimum": 1,
      "description": "Maximum number of days the consumer may retain this data after transfer"
    },
    "export_restrictions": {
      "type": "array",
      "items": { "type": "string" },
      "description": "ISO 3166-1 alpha-2 country codes to which this data may NOT be exported"
    },
    "redistribution_allowed": {
      "type": "boolean",
      "description": "Whether the consumer may redistribute this data to third parties"
    },
    "anonymisation_required": {
      "type": "boolean",
      "description": "Whether personal data must be anonymised before use or storage"
    },
    "gdpr_basis": {
      "type": "string",
      "enum": [
        "consent", "contract", "legal_obligation", "vital_interest",
        "public_task", "legitimate_interest", "not_applicable"
      ],
      "description": "GDPR Article 6 legal basis, if personal data is involved"
    },
    "data_classification": {
      "type": "string",
      "description": "Data classification level (e.g. official-sensitive, confidential, public)"
    }
  }
}
```

---

## 5. ISO 20151 Concept → Liability Claims v1.6.0 Full Mapping

| ISO 20151 Concept | Standard Reference | v1.5.0 Field | v1.6.0 Field | Status |
|------------------|-------------------|-------------|-------------|--------|
| Data Provider identity | §6.2 | `liability:responsible_party` | (extended with `did` subfield) | 🔶 Extend |
| Data Consumer identity | §6.3 | — | `liability:data_contract.signed_by[1+]` | ✅ New |
| Participant role | §6.4 | — | `liability:data_space.participant_role` | ✅ New |
| Data Space identifier | §5.1 | — | `liability:data_space.id` | ✅ New |
| Connector endpoint | §10.3 | — | `liability:data_space.connector_url` | ✅ New |
| Self-description | §10.4 | — | `liability:data_space.self_description_url` | ✅ New |
| Data Offering | §8.1 | — | `liability:usage_policy` (policy_type: Offer) | ✅ New |
| Usage Policy — permission | §8.2 | — | `liability:usage_policy.permission` | ✅ New |
| Usage Policy — prohibition | §8.3 | — | `liability:usage_policy.prohibition` | ✅ New |
| Usage Policy — obligation | §8.4 | — | `liability:usage_policy.obligation` | ✅ New |
| Data Contract | §9 | — | `liability:data_contract` | ✅ New |
| Data residency | §7.2 | — | `liability:sovereignty.data_residency` | ✅ New |
| Purpose limitation | §7.3 | — | `liability:sovereignty.purpose` | ✅ New |
| Retention period | §7.4 | — | `liability:sovereignty.retention_days` | ✅ New |
| Export restrictions | §7.5 | — | `liability:sovereignty.export_restrictions` | ✅ New |
| GDPR legal basis | (implicit §7) | — | `liability:sovereignty.gdpr_basis` | ✅ New |
| Data quality | ISO 19157 | `liability:quality` | (unchanged) | ✅ Covered |
| Provenance | W3C PROV | `liability:prov` | (unchanged) | ✅ Covered |
| Trust / integrity | VC 1.0 | `liability:integrity` (implicit via VCs) | (unchanged) | ✅ Covered |
| Legal jurisdiction | §7.1 | `liability:legal_jurisdiction` | (unchanged) | ✅ Covered |
| Insurance/claims | (implicit §9) | `liability:claim_*` fields | (unchanged) | ✅ Covered |

---

## 6. Integration with Data Space Connectors

ISO 20151-compliant data space connectors (IDS Connector, Eclipse Dataspace
Components — EDC) perform **policy negotiation** at the protocol level before
transferring data. The STAC Item with Liability Claims fields provides the
**catalog-level metadata** that connectors can read to:

1. Advertise the asset in the data space catalog with its quality (ISO 19157) and
   sovereignty constraints (`liability:sovereignty`)
2. Present the usage policy (`liability:usage_policy`) during ODRL policy negotiation
3. Reference the executed contract (`liability:data_contract`) once negotiation completes
4. Verify provider/asset trust via the embedded VC / DID fields

### Connector Integration Diagram

```
Data Consumer                  Data Space Connector              STAC Catalog
     │                               │                               │
     │──── catalog query ────────────────────────────────────→       │
     │                               │                               │
     │←─── STAC Items (with ─────────────────────────────────        │
     │     liability:data_space,     │                               │
     │     liability:usage_policy,   │                               │
     │     liability:quality) ───────────────────────────────        │
     │                               │                               │
     │──── contract negotiation ──→  │                               │
     │     (ODRL policy from         │                               │
     │      liability:usage_policy)  │                               │
     │                               │                               │
     │←─── Data Contract ────────────│                               │
     │     (liability:data_contract) │                               │
     │                               │                               │
     │──── data transfer request ──→ │                               │
     │     (connector_url)           │                               │
     │                               │                               │
     │←─── asset (+ VC integrity) ── │                               │
```

---

## 7. OGC / GAIA-X / IDS Alignment

| Framework | Alignment | Notes |
|-----------|-----------|-------|
| **ISO 20151** | 🔶 Partial (v1.5.0) / ✅ Full (v1.6.0) | Core gaps addressed by new fields |
| **GAIA-X Trust Framework 22.10** | ✅ (v1.6.0) | `liability:data_space`, `liability:sovereignty`, VCs align with GAIA-X Self-Description |
| **IDS Reference Architecture Model 4.2** | ✅ (v1.6.0) | `connector_url` enables IDS Connector integration |
| **Eclipse Dataspace Components (EDC)** | ✅ (v1.6.0) | ODRL fields map directly to EDC policy engine input |
| **W3C ODRL 2.2** | ✅ (v1.6.0) | `liability:usage_policy` follows ODRL Information Model |
| **W3C DPV 2.0** | ✅ (v1.6.0) | `liability:sovereignty.purpose` uses DPV purpose taxonomy |
| **GDPR** | ✅ (v1.6.0) | `liability:sovereignty.gdpr_basis` + `purpose` + `retention_days` |
| **OGC API – Records** | ✅ | STAC Items with `liability:data_space` discoverable by OGC catalog |
| **STAC Liability Claims v1.5.0** | ✅ | Fully backward compatible; all new fields are optional |

---

## 8. References

- ISO/IEC 20151 — Information technology — Data spaces — Framework and concepts
- W3C ODRL Information Model 2.2: https://www.w3.org/TR/odrl-model/
- W3C ODRL Vocabulary & Expression 2.2: https://www.w3.org/TR/odrl-vocab/
- W3C Data Privacy Vocabulary (DPV) 2.0: https://w3id.org/dpv
- GAIA-X Trust Framework 22.10: https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/
- IDS Reference Architecture Model 4.2: https://internationaldataspaces.org/download/19008/
- Eclipse Dataspace Components (EDC): https://eclipse-edc.github.io/docs/
- W3C Verifiable Credentials Data Model 2.0: https://www.w3.org/TR/vc-data-model-2.0/
- W3C Decentralized Identifiers 1.0: https://www.w3.org/TR/did-core/
- GDPR Article 5 — Principles relating to processing of personal data
- STAC Liability Claims Extension v1.5.0 schema: https://luciocola.github.io/stac-extension-liability-claims/v1.5.0/schema.json
