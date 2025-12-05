# STAC Liability-Claims Extension - Schema Diagram

## Overall Structure

```mermaid
graph TD
    A[STAC Item/Collection] --> B[liability:* fields]
    A --> C[liability:quality]
    
    B --> B1[liability:claim_id]
    B --> B2[liability:claim_type]
    B --> B3[liability:claim_status]
    B --> B4[liability:responsible_party]
    B --> B5[liability:damages_estimated]
    B --> B6[liability:origin]
    B --> B7[... 14 other fields]
    
    C --> D[ISO 19115 Quality Report]
    
    D --> D1[reportId]
    D --> D2[scope]
    D --> D3[date]
    D --> D4[version]
    D --> D5[summary]
    D --> D6[elements array]
    
    D6 --> E[Quality Elements]
    
    E --> F1[ISO 19115 Core]
    E --> F2[ISO 19115-4 Imagery]
    E --> F3[DGIWG Defence]
    
    F1 --> G1[completeness]
    F1 --> G2[logicalConsistency]
    F1 --> G3[positionalAccuracy]
    F1 --> G4[thematicAccuracy]
    F1 --> G5[temporalAccuracy]
    F1 --> G6[attributeAccuracy]
    F1 --> G7[topologicalConsistency]
    F1 --> G8[lineage]
    
    F2 --> H1[radiometricAccuracy]
    F2 --> H2[sensorQuality]
    F2 --> H3[cloudCoverage]
    F2 --> H4[snowCoverage ⭐NEW]
    F2 --> H5[processingLevel]
    F2 --> H6[usabilityAssessment]
    
    F3 --> I1[absoluteExternalPositionalAccuracy]
    F3 --> I2[relativeInternalPositionalAccuracy]
    F3 --> I3[griddedDataPositionalAccuracy]
    F3 --> I4[nonQuantitativeAttributeCorrectness]
    F3 --> I5[quantitativeAttributeAccuracy]
    F3 --> I6[formatConsistency]
    F3 --> I7[domainConsistency]
    F3 --> I8[temporalValidity]
    
    style C fill:#e1f5ff
    style D fill:#fff4e1
    style F2 fill:#e8f5e9
    style H4 fill:#ffeb3b
```

## Quality Element Structure

```mermaid
classDiagram
    class QualityReport {
        +string reportId
        +string scope
        +string date
        +string version
        +string summary
        +QualityElement[] elements
    }
    
    class QualityElement {
        +string elementType
        +string summary
        +object detail
        +ConformanceResult conformance
    }
    
    class CloudCoverage {
        +string type = "cloudCoverage"
        +number coveragePercentage (0-100)
        +string assessmentMethod
        +Measure measure
    }
    
    class SnowCoverage {
        +string type = "snowCoverage"
        +number coveragePercentage (0-100)
        +string assessmentMethod
        +Measure measure
    }
    
    class PositionalAccuracy {
        +string type = "positionalAccuracy"
        +number accuracyValue
        +string units
        +string method
        +Measure measure
    }
    
    class Measure {
        +string description
        +number|string value
        +string valueType
        +string units
        +string method
        +string reference
    }
    
    class ConformanceResult {
        +string specification
        +boolean pass
        +string explanation
    }
    
    QualityReport "1" *-- "*" QualityElement
    QualityElement "1" *-- "1" CloudCoverage
    QualityElement "1" *-- "1" SnowCoverage
    QualityElement "1" *-- "1" PositionalAccuracy
    QualityElement "0..1" *-- "0..1" ConformanceResult
    CloudCoverage "1" *-- "1" Measure
    SnowCoverage "1" *-- "1" Measure
    PositionalAccuracy "1" *-- "1" Measure
```

## Cloud & Snow Coverage Detail

```mermaid
graph LR
    A[Quality Element] --> B{elementType}
    
    B -->|cloudCoverage| C[Cloud Coverage Detail]
    B -->|snowCoverage| D[Snow Coverage Detail]
    
    C --> C1[type: cloudCoverage]
    C --> C2[coveragePercentage: 0-100]
    C --> C3[assessmentMethod: string]
    C --> C4[measure: object]
    
    D --> D1[type: snowCoverage]
    D --> D2[coveragePercentage: 0-100]
    D --> D3[assessmentMethod: string]
    D --> D4[measure: object]
    
    C4 --> M[Measure Object]
    D4 --> M
    
    M --> M1[description]
    M --> M2[value]
    M --> M3[valueType: percentage]
    M --> M4[units: %]
    
    style D fill:#e3f2fd
    style D1 fill:#ffeb3b
    style D2 fill:#ffeb3b
    style D3 fill:#ffeb3b
    style D4 fill:#ffeb3b
```

## DGIWG Quality Elements

```mermaid
graph TB
    A[DGIWG Quality Elements] --> B[Positional Accuracy]
    A --> C[Attribute Accuracy]
    A --> D[Logical Consistency]
    A --> E[Temporal Quality]
    
    B --> B1[absoluteExternalPositionalAccuracy<br/>- horizontalAccuracy<br/>- verticalAccuracy<br/>- units<br/>- method]
    B --> B2[relativeInternalPositionalAccuracy<br/>- accuracyValue<br/>- units<br/>- method]
    B --> B3[griddedDataPositionalAccuracy<br/>- accuracyValue<br/>- units<br/>- method]
    
    C --> C1[quantitativeAttributeAccuracy<br/>- attribute<br/>- accuracyValue<br/>- units]
    C --> C2[nonQuantitativeAttributeCorrectness<br/>- attribute<br/>- correctnessRate]
    
    D --> D1[formatConsistency<br/>- description<br/>- conformanceRate]
    D --> D2[domainConsistency<br/>- description<br/>- conformanceRate]
    
    E --> E1[temporalValidity<br/>- validFrom<br/>- validTo]
    
    style A fill:#fff3e0
    style B fill:#e8f5e9
    style C fill:#f3e5f5
    style D fill:#e1f5fe
    style E fill:#fce4ec
```

## Complete Property Hierarchy

```
STAC Item/Collection
│
├── Standard STAC Properties
│   ├── type
│   ├── stac_version
│   ├── stac_extensions
│   ├── id
│   ├── geometry
│   ├── bbox
│   ├── properties
│   ├── assets
│   └── links
│
└── Liability-Claims Extension (liability:*)
    │
    ├── Core Claim Fields
    │   ├── liability:claim_id
    │   ├── liability:claim_type (environmental|property_damage|personal_injury|financial|operational|other)
    │   ├── liability:claim_status (pending|under_investigation|accepted|rejected|settled|closed)
    │   ├── liability:responsible_party
    │   ├── liability:claim_date
    │   ├── liability:incident_date
    │   ├── liability:resolution_date
    │   └── liability:resolution_status
    │
    ├── Damages & Insurance
    │   ├── liability:damages_estimated
    │   ├── liability:damages_currency (ISO 4217)
    │   ├── liability:insurance_provider
    │   └── liability:policy_number
    │
    ├── Parties & Jurisdiction
    │   ├── liability:affected_parties[]
    │   │   ├── name
    │   │   ├── role
    │   │   └── contact
    │   ├── liability:legal_jurisdiction
    │   └── liability:coverage_area (GeoJSON Geometry)
    │
    ├── Documentation
    │   ├── liability:evidence_refs[] (URIs or Asset keys)
    │   ├── liability:notes
    │   └── liability:origin
    │
    └── Quality Reporting (liability:quality)
        │
        ├── reportId
        ├── scope (dataset|feature|series)
        ├── date (RFC 3339)
        ├── version
        ├── summary
        │
        └── elements[] (Quality Elements)
            │
            ├── elementType (enum)
            ├── summary
            ├── detail (type-specific structure)
            │   │
            │   ├── ISO 19115 Core
            │   │   ├── completeness
            │   │   ├── logicalConsistency
            │   │   ├── positionalAccuracy
            │   │   ├── thematicAccuracy
            │   │   ├── temporalAccuracy
            │   │   ├── attributeAccuracy
            │   │   ├── topologicalConsistency
            │   │   └── lineage
            │   │
            │   ├── ISO 19115-4 Imagery/Gridded Data
            │   │   ├── radiometricAccuracy
            │   │   ├── sensorQuality
            │   │   ├── cloudCoverage ⛅
            │   │   ├── snowCoverage ❄️ NEW
            │   │   ├── processingLevel
            │   │   └── usabilityAssessment
            │   │
            │   └── DGIWG Defence Geospatial
            │       ├── absoluteExternalPositionalAccuracy
            │       ├── relativeInternalPositionalAccuracy
            │       ├── griddedDataPositionalAccuracy
            │       ├── nonQuantitativeAttributeCorrectness
            │       ├── quantitativeAttributeAccuracy
            │       ├── formatConsistency
            │       ├── domainConsistency
            │       └── temporalValidity
            │
            └── conformance (optional)
                ├── specification
                ├── pass (boolean)
                └── explanation
```

## Asset-Level Security Fields

```
STAC Asset
│
└── Liability-Claims Security (asset-level)
    ├── liability:security_classification (public|internal|confidential|restricted|classified)
    ├── liability:access_restrictions[] (array of restriction types)
    ├── liability:access_control (deprecated in v1.1.0)
    │   ├── required_auth
    │   ├── auth_methods[]
    │   └── auth_schemes{}
    │
    └── liability:required_roles[] (v1.1.0 - for API-level enforcement)
```

## Usage Flow

```mermaid
sequenceDiagram
    participant User
    participant STAC Item
    participant Quality Report
    participant Element Detail
    
    User->>STAC Item: Access liability:quality
    STAC Item->>Quality Report: Get quality information
    Quality Report->>Quality Report: Check reportId, scope, date
    Quality Report->>Element Detail: Iterate through elements[]
    
    loop For each quality element
        Element Detail->>Element Detail: Check elementType
        alt cloudCoverage
            Element Detail->>Element Detail: Get coveragePercentage
            Element Detail->>Element Detail: Get assessmentMethod
        else snowCoverage
            Element Detail->>Element Detail: Get coveragePercentage
            Element Detail->>Element Detail: Get assessmentMethod
        else positionalAccuracy
            Element Detail->>Element Detail: Get accuracyValue & units
        else other types
            Element Detail->>Element Detail: Get type-specific fields
        end
        Element Detail->>Element Detail: Get measure object
        Element Detail->>Element Detail: Check conformance (optional)
    end
    
    Quality Report->>User: Return complete quality assessment
```

## Key Relationships

1. **STAC Item/Collection** `1:1` **liability:quality** (quality can be object or array)
2. **Quality Report** `1:*` **Quality Elements**
3. **Quality Element** `1:1` **Element Detail** (type-specific)
4. **Element Detail** `1:1` **Measure** (quantitative assessment)
5. **Element Detail** `0:1` **Conformance Result** (optional validation)

## Standards Compliance

```mermaid
graph LR
    A[STAC Liability-Claims] --> B[ISO 19115:2014]
    A --> C[ISO 19115-4:2015]
    A --> D[DGIWG Standards]
    
    B --> B1[Core Quality Elements]
    B --> B2[Lineage & Provenance]
    
    C --> C1[Imagery Quality]
    C --> C2[Sensor Metadata]
    C --> C3[Cloud Coverage ⛅]
    C --> C4[Snow Coverage ❄️]
    
    D --> D1[Defence Positional Accuracy]
    D --> D2[Attribute Correctness]
    D --> D3[Temporal Validity]
    
    style A fill:#4caf50,color:#fff
    style C3 fill:#2196f3,color:#fff
    style C4 fill:#ffeb3b
```

---

**Note:** Diagrams are in Mermaid format. View this file in:
- GitHub (native Mermaid rendering)
- VS Code with Mermaid preview extension
- https://mermaid.live (paste diagram code)
- Any Markdown viewer with Mermaid support
