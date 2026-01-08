# Verifiable Credentials 2.0 Integration

This document describes how the Liability and Claims STAC Extension integrates with the W3C Verifiable Credentials Data Model 2.0 to provide cryptographically verifiable liability claims, quality reports, and provenance information.

## Overview

Verifiable Credentials (VCs) enable cryptographically verifiable assertions about STAC Items and Collections. The extension supports VC 2.0 through the `liability:verifiable_credentials` field, allowing:

- **Cryptographic Verification**: Digital signatures proving authenticity
- **Selective Disclosure**: Reveal only necessary information using SD-JWT or BBS+
- **Decentralized Trust**: No central authority required using DIDs
- **Tamper Evidence**: Detect unauthorized modifications
- **Compliance Evidence**: Verifiable proof of quality standards compliance

## Field Definition

### liability:verifiable_credentials

**Type**: Array of Verifiable Credential Objects  
**Scope**: Items, Collections, Assets  
**Description**: Array of W3C Verifiable Credentials 2.0 compliant credentials containing verifiable assertions about the STAC resource.

Each credential MUST conform to the [W3C Verifiable Credentials Data Model v2.0](https://www.w3.org/TR/vc-data-model-2.0/).

## Verifiable Credential Structure

```json
{
  "@context": [
    "https://www.w3.org/ns/credentials/v2",
    "https://stac-extensions.github.io/liability-claims/v1.1.0/vc-context.jsonld"
  ],
  "id": "https://example.org/credentials/3732",
  "type": ["VerifiableCredential", "DataQualityCredential"],
  "issuer": {
    "id": "did:web:example.org",
    "name": "National Geospatial Agency"
  },
  "validFrom": "2025-01-08T00:00:00Z",
  "validUntil": "2026-01-08T00:00:00Z",
  "credentialSubject": {
    "id": "https://api.example.org/stac/collections/sentinel2/items/S2A_20250108",
    "type": "STACItem",
    "qualityAssessment": {
      "overallQuality": "passed",
      "iso19157Conformance": true,
      "assessmentDate": "2025-01-08T10:30:00Z"
    }
  },
  "proof": {
    "type": "DataIntegrityProof",
    "cryptosuite": "eddsa-jcs-2022",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:web:example.org#key-1",
    "created": "2025-01-08T10:35:00Z",
    "proofValue": "z58DAdFfa9SkqZMVPxAQpic7ndSayn1PzZs6ZjWp1CktyGesjuTSwRdoWhAfGFCF5bppETSTojQCrfFPP2oumHKtz"
  }
}
```

## Use Cases

### 1. Verifiable Data Quality Reports

Issue cryptographically signed quality assessments conforming to ISO 19157-1:2023:

```json
{
  "liability:verifiable_credentials": [{
    "@context": [
      "https://www.w3.org/ns/credentials/v2",
      "https://stac-extensions.github.io/liability-claims/v1.1.0/vc-context.jsonld"
    ],
    "id": "urn:uuid:4f3a6d8c-9e2b-4a1d-8c7e-5f3a6d8c9e2b",
    "type": ["VerifiableCredential", "ISO19157QualityReport"],
    "issuer": {
      "id": "did:web:quality.gov",
      "name": "National Quality Assurance Laboratory"
    },
    "validFrom": "2025-01-08T00:00:00Z",
    "credentialSubject": {
      "id": "https://sentinel.esa.int/items/S2A_MSIL2A_20250108",
      "iso19157": {
        "qualityElements": [{
          "measure": "DQ_CompletenessCommission",
          "evaluationMethod": "DQ_FullInspection",
          "result": {
            "value": 0.002,
            "valueUnit": "percentage"
          }
        }]
      }
    },
    "proof": {
      "type": "DataIntegrityProof",
      "cryptosuite": "ecdsa-sd-2023",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:web:quality.gov#key-2023",
      "created": "2025-01-08T12:00:00Z",
      "proofValue": "..."
    }
  }]
}
```

### 2. Verifiable Liability Claims

Document legally binding liability claims with cryptographic proof:

```json
{
  "liability:verifiable_credentials": [{
    "@context": [
      "https://www.w3.org/ns/credentials/v2",
      "https://stac-extensions.github.io/liability-claims/v1.1.0/vc-context.jsonld"
    ],
    "id": "urn:uuid:claim-2025-001",
    "type": ["VerifiableCredential", "LiabilityClaimCredential"],
    "issuer": {
      "id": "did:web:insurance.example.com",
      "name": "Global Geospatial Insurance Inc."
    },
    "validFrom": "2025-01-08T00:00:00Z",
    "credentialSubject": {
      "id": "https://api.example.org/stac/items/flood-zone-2025",
      "claim": {
        "claimId": "CLM-2025-ENV-001",
        "claimType": "environmental",
        "claimStatus": "accepted",
        "claimDate": "2025-01-05T14:30:00Z",
        "responsibleParty": "did:web:municipality.example.gov",
        "damagesEstimated": 250000,
        "currency": "USD",
        "affectedArea": {
          "type": "Polygon",
          "coordinates": [[[-122.4, 37.8], [-122.3, 37.8], [-122.3, 37.7], [-122.4, 37.7], [-122.4, 37.8]]]
        }
      }
    },
    "proof": {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:web:insurance.example.com#legal-signing-key",
      "created": "2025-01-08T15:00:00Z",
      "proofValue": "..."
    }
  }]
}
```

### 3. Verifiable Provenance with W3C PROV

Sign provenance graphs to ensure integrity:

```json
{
  "liability:verifiable_credentials": [{
    "@context": [
      "https://www.w3.org/ns/credentials/v2",
      "http://www.w3.org/ns/prov#",
      "https://stac-extensions.github.io/liability-claims/v1.1.0/vc-context.jsonld"
    ],
    "id": "urn:uuid:prov-cert-001",
    "type": ["VerifiableCredential", "ProvenanceCredential"],
    "issuer": {
      "id": "did:web:processor.example.org",
      "name": "Dr. Jane Smith - Remote Sensing Institute"
    },
    "validFrom": "2025-01-08T00:00:00Z",
    "credentialSubject": {
      "id": "https://api.example.org/stac/items/corrected-imagery-001",
      "provenance": {
        "entity": {
          "ex:output_dataset": {
            "prov:type": "prov:Dataset",
            "prov:wasGeneratedBy": "ex:atmos_correction"
          }
        },
        "activity": {
          "ex:atmos_correction": {
            "prov:type": "ex:AtmosphericCorrection",
            "prov:used": "ex:sentinel2_l1c",
            "prov:wasAssociatedWith": "ex:jane_smith",
            "prov:startTime": "2025-01-07T10:00:00Z",
            "prov:endTime": "2025-01-07T10:45:00Z"
          }
        },
        "agent": {
          "ex:jane_smith": {
            "prov:type": "prov:Person",
            "prov:actedOnBehalfOf": "ex:rs_institute"
          }
        }
      }
    },
    "proof": {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:web:processor.example.org#jane-smith-key",
      "created": "2025-01-08T11:00:00Z",
      "proofValue": "..."
    }
  }]
}
```

### 4. Selective Disclosure with SD-JWT

Reveal only necessary information using Selective Disclosure JWT:

```json
{
  "liability:verifiable_credentials": [{
    "@context": "https://www.w3.org/ns/credentials/v2",
    "id": "urn:uuid:sd-quality-001",
    "type": ["VerifiableCredential", "SelectiveDisclosureCredential"],
    "issuer": "did:web:authority.example.org",
    "validFrom": "2025-01-08T00:00:00Z",
    "credentialSubject": {
      "id": "https://api.example.org/stac/items/classified-data-001",
      "_sd": [
        "sensitiveQualityMetric1_hash",
        "proprietaryMethod_hash", 
        "confidentialSource_hash"
      ],
      "publicQualityScore": 95.7,
      "conformanceLevel": "ISO19157-compliant"
    },
    "proof": {
      "type": "DataIntegrityProof",
      "cryptosuite": "ecdsa-sd-2023",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:web:authority.example.org#key-sd",
      "created": "2025-01-08T13:00:00Z",
      "proofValue": "..."
    }
  }]
}
```

## Cryptographic Suites

The extension supports multiple cryptographic suites from the [VC Data Integrity specification](https://www.w3.org/TR/vc-data-integrity/):

### Recommended Suites

| Cryptosuite | Use Case | Security Level |
|------------|----------|----------------|
| `eddsa-jcs-2022` | General-purpose signing | High (Ed25519) |
| `ecdsa-sd-2023` | Selective disclosure | High (ECDSA P-256/384) |
| `eddsa-rdfc-2022` | RDF canonical form | High (Ed25519) |
| `bbs-2023` | Zero-knowledge proofs | High (BBS+ signatures) |

### Legacy Support

| Cryptosuite | Status | Migration Path |
|------------|--------|----------------|
| `Ed25519Signature2020` | Deprecated | Use `eddsa-jcs-2022` |
| `EcdsaSecp256k1Signature2019` | Deprecated | Use `ecdsa-sd-2023` |

## Decentralized Identifiers (DIDs)

VCs use DIDs for issuer and subject identification. Supported DID methods:

### did:web
- **Best for**: Organizations with existing web infrastructure
- **Example**: `did:web:example.org` or `did:web:example.org:users:alice`
- **Resolution**: HTTPS GET to `https://example.org/.well-known/did.json`
- **Advantages**: Simple, uses existing PKI
- **Considerations**: Centralized (relies on DNS/TLS)

### did:key
- **Best for**: Self-sovereign keys, offline scenarios
- **Example**: `did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK`
- **Resolution**: Embedded in DID (no network lookup)
- **Advantages**: Fully decentralized, offline-capable
- **Considerations**: No key rotation

### did:ion (ION Sidetree on Bitcoin)
- **Best for**: Long-term persistent identifiers
- **Example**: `did:ion:EiClkZMDxPKqC9c-umQfTkR8vvZ9JPhl_xLDI9Nfk38w5w`
- **Resolution**: IPFS + Bitcoin blockchain
- **Advantages**: Highly decentralized, censorship-resistant
- **Considerations**: Resolution latency

## Verification Process

### 1. Fetch DID Document

```javascript
// For did:web:example.org
const didDoc = await fetch('https://example.org/.well-known/did.json');
```

### 2. Resolve Verification Method

```javascript
const verificationMethod = didDoc.verificationMethod.find(
  vm => vm.id === proof.verificationMethod
);
```

### 3. Verify Proof

```javascript
import { verify } from '@digitalbazaar/vc';
import { Ed25519VerificationKey2020 } from '@digitalbazaar/ed25519-verification-key-2020';

const result = await verify({
  credential,
  suite: new Ed25519VerificationKey2020(),
  documentLoader
});

if (result.verified) {
  console.log('Credential is valid!');
}
```

## Status Management

### VC Status List 2021

Track credential revocation/suspension using [Status List 2021](https://www.w3.org/TR/vc-status-list/):

```json
{
  "credentialStatus": {
    "id": "https://example.org/status/3#94567",
    "type": "StatusList2021Entry",
    "statusPurpose": "revocation",
    "statusListIndex": "94567",
    "statusListCredential": "https://example.org/status/3"
  }
}
```

### BitString Status List (VC 2.0)

New compressed status list format:

```json
{
  "credentialStatus": {
    "id": "https://example.org/status/2024#67890",
    "type": "BitstringStatusListEntry",
    "statusPurpose": "revocation",
    "statusListIndex": "67890",
    "statusListCredential": "https://example.org/status/2024"
  }
}
```

## JSON-LD Context

The extension provides a JSON-LD context at:
```
https://stac-extensions.github.io/liability-claims/v1.1.0/vc-context.jsonld
```

This context maps extension terms to semantic web URIs:

```json
{
  "@context": {
    "@version": 1.1,
    "@protected": true,
    "liability": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json#",
    "iso19157": "http://iso.org/tc211/iso19157/-/dq/1.0/",
    "prov": "http://www.w3.org/ns/prov#",
    "STACItem": "https://stac-spec.org/Item",
    "STACCollection": "https://stac-spec.org/Collection",
    "DataQualityCredential": "liability:DataQualityCredential",
    "LiabilityClaimCredential": "liability:LiabilityClaimCredential",
    "ProvenanceCredential": "liability:ProvenanceCredential"
  }
}
```

## Integration with Existing Fields

VCs can wrap existing extension fields for verification:

### Quality Reports
```json
{
  "liability:quality": { /* ISO 19157 quality data */ },
  "liability:verifiable_credentials": [{
    "credentialSubject": {
      "id": "<stac-item-id>",
      "qualityReport": { /* reference to liability:quality */ }
    },
    "proof": { /* cryptographic signature */ }
  }]
}
```

### PROV Provenance
```json
{
  "liability:prov": { /* W3C PROV data */ },
  "liability:verifiable_credentials": [{
    "credentialSubject": {
      "id": "<stac-item-id>",
      "provenance": { /* reference to liability:prov */ }
    },
    "proof": { /* cryptographic signature */ }
  }]
}
```

### Liability Claims
```json
{
  "liability:claim_id": "CLM-2025-001",
  "liability:claim_status": "accepted",
  "liability:verifiable_credentials": [{
    "type": ["VerifiableCredential", "LiabilityClaimCredential"],
    "credentialSubject": {
      "claim": {
        "claimId": "CLM-2025-001",
        "status": "accepted",
        /* other claim details */
      }
    },
    "proof": { /* insurance company signature */ }
  }]
}
```

## Validation

### Schema Validation

VCs must validate against the VC 2.0 JSON Schema:

```bash
jsonschema -i credential.json \
  https://www.w3.org/2018/credentials/v2/vc-data-model.json
```

### Cryptographic Verification

Use standard VC libraries:

- **JavaScript/Node.js**: `@digitalbazaar/vc`, `@digitalbazaar/vc-data-integrity`
- **Python**: `pyld`, `didkit`
- **Rust**: `ssi`, `didkit`
- **Go**: `go-vc-data-model`

### STAC Extension Validation

Validate VC within STAC context:

```bash
./validate-extension.sh examples/item-with-verifiable-credentials.json
```

## Best Practices

### 1. Key Management
- Use hardware security modules (HSMs) for issuer keys
- Implement key rotation policies
- Backup recovery seeds securely
- Use did:web for organizational identity

### 2. Credential Lifecycle
- Set appropriate `validFrom` and `validUntil` dates
- Implement status list for revocation
- Archive expired credentials with timestamps
- Version credential schemas

### 3. Privacy
- Use selective disclosure (SD-JWT/BBS+) for sensitive data
- Minimize credential subject information
- Implement zero-knowledge proofs where appropriate
- Consider GDPR/privacy regulations

### 4. Performance
- Cache DID documents (with TTL)
- Use compact representations for large datasets
- Batch verify multiple credentials
- Consider external proof format for large proofs

### 5. Interoperability
- Follow W3C VC 2.0 specifications strictly
- Use standard cryptosuites
- Provide JSON-LD contexts
- Support multiple DID methods

## Migration from VC 1.1

Key changes from Verifiable Credentials 1.1:

| VC 1.1 | VC 2.0 | Notes |
|--------|--------|-------|
| `issuanceDate` | `validFrom` | Renamed for clarity |
| `expirationDate` | `validUntil` | Renamed for clarity |
| `proof.jws` | `proof.proofValue` | Generalized proof value |
| `proof.proofPurpose` optional | `proof.proofPurpose` required | Must specify purpose |
| Linked Data Signatures | Data Integrity Proofs | New cryptographic framework |

### Migration Script Example

```javascript
function migrateVC_1_1_to_2_0(oldVC) {
  const newVC = {
    ...oldVC,
    '@context': [
      'https://www.w3.org/ns/credentials/v2',
      ...oldVC['@context'].slice(1)
    ]
  };
  
  // Rename date fields
  if (oldVC.issuanceDate) {
    newVC.validFrom = oldVC.issuanceDate;
    delete newVC.issuanceDate;
  }
  
  if (oldVC.expirationDate) {
    newVC.validUntil = oldVC.expirationDate;
    delete newVC.expirationDate;
  }
  
  // Update proof format
  if (oldVC.proof && oldVC.proof.jws) {
    newVC.proof.proofValue = oldVC.proof.jws;
    delete newVC.proof.jws;
  }
  
  return newVC;
}
```

## Tools and Libraries

### Issuance
- **Digital Bazaar VC Library** - JavaScript reference implementation
- **didkit** - Rust/WASM credential toolkit
- **Veramo** - TypeScript agent framework
- **MATTR Platform** - Commercial VC issuance platform

### Verification
- **vc-js** - JavaScript verification
- **DIF Universal Resolver** - Multi-method DID resolver
- **Verifiable Data Registry** - Store/query VCs
- **VC API** - HTTP API for VC operations

### Development
- **VC Playground** - https://playground.chapi.io/
- **DID Resolver** - https://dev.uniresolver.io/
- **JSON-LD Playground** - https://json-ld.org/playground/

## References

### W3C Specifications
- [Verifiable Credentials Data Model v2.0](https://www.w3.org/TR/vc-data-model-2.0/)
- [Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/)
- [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- [VC Status List v2021](https://www.w3.org/TR/vc-status-list/)

### Cryptographic Suites
- [EdDSA Cryptosuite 2022](https://www.w3.org/TR/vc-di-eddsa/)
- [ECDSA Cryptosuite 2023](https://www.w3.org/TR/vc-di-ecdsa/)
- [BBS Cryptosuite 2023](https://www.w3.org/TR/vc-di-bbs/)

### Implementation Guides
- [VC Implementation Guide](https://www.w3.org/TR/vc-imp-guide/)
- [DID Method Rubric](https://www.w3.org/TR/did-rubric/)
- [Securing VCs with JWT](https://www.w3.org/TR/vc-jose-cose/)

## Future Work

Potential enhancements:

1. **ZKP Integration**: Zero-knowledge proof protocols for privacy-preserving quality assertions
2. **Credential Chaining**: Link VCs across processing pipelines
3. **Smart Contracts**: On-chain verification for blockchain-based STAC catalogs
4. **Federated Trust**: Trust frameworks for credential ecosystem governance
5. **Automated Issuance**: CI/CD integration for automatic VC generation

## Contributing

Feedback on VC 2.0 integration is welcome. Please open issues or pull requests at:
https://github.com/stac-extensions/liability-claims

---

**Document Version:** 1.0  
**Last Updated:** 2026-01-08  
**Extension Version:** 1.2.0 (with VC 2.0 support)
**W3C VC Version:** 2.0
