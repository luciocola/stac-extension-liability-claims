# SHACL Validation Rules

This directory contains SHACL (Shapes Constraint Language) validation rules for semantic validation of STAC Liability and Claims Extension provenance graphs.

## Overview

**Purpose**: Validate W3C PROV-O provenance graphs for semantic correctness beyond JSON Schema validation

**Specification**: W3C SHACL - https://www.w3.org/TR/shacl/

## Files

### `liability-claims-shapes.ttl`

Comprehensive SHACL shapes covering:

1. **Core Extension Validation**
   - `liability:ExtensionShape` - Validates required extension properties
   - Ensures `liability_framework`, `jurisdiction`, `liability_terms` are present and well-formed

2. **PROV Document Structure**
   - `liability:ProvDocumentShape` - Validates overall provenance graph structure
   - Ensures at least one entity and one activity/agent exists

3. **PROV Entities**
   - `liability:ProvEntityShape` - Validates entity properties
   - Checks `wasGeneratedBy`, `wasAttributedTo`, `wasDerivedFrom` relationships

4. **PROV Activities**
   - `liability:ProvActivityShape` - Validates activity properties
   - Temporal constraints (start/end times)
   - Required agent associations

5. **PROV Agents**
   - `liability:ProvAgentShape` - Validates agent types
   - Ensures Person, Organization, or SoftwareAgent classification
   - Requires name/label

6. **Quality Metadata**
   - `liability:QualityMetadataShape` - Validates DQV quality measurements
   - Links to ISO 19115 quality metrics

7. **Advanced Constraints**
   - `liability:ProvenanceChainShape` - Validates complete provenance chains
   - `liability:ActivityDependenciesShape` - Validates activity input/output relationships
   - `liability:TemporalConsistencyShape` - Validates temporal ordering
   - `liability:AgentAttributionShape` - Validates delegation chains

## Usage

### Prerequisites

Install SHACL validation tools:

```bash
# Python: pyshacl
pip install pyshacl

# Node.js: shacl-js
npm install -g shacl

# Java: Apache Jena SHACL
# Download from: https://jena.apache.org/download/
```

### Validation Examples

#### Using pyshacl (Python)

```bash
# Validate RDF data against SHACL shapes
pyshacl -s shacl/liability-claims-shapes.ttl \
        -df json-ld \
        -sf turtle \
        data.jsonld
```

#### Using Node.js

```javascript
const shacl = require('shacl');
const fs = require('fs');

const shapes = fs.readFileSync('shacl/liability-claims-shapes.ttl', 'utf8');
const data = fs.readFileSync('data.ttl', 'utf8');

shacl.validate(data, shapes).then(report => {
  console.log(report.conforms);
  console.log(report.results);
});
```

#### Using Apache Jena

```bash
shacl validate --shapes=shacl/liability-claims-shapes.ttl \
               --data=data.ttl
```

### Validation Workflow

1. **Convert STAC JSON to JSON-LD**
   ```bash
   # Use context.jsonld to uplift JSON to RDF
   riot --syntax=jsonld \
        --base=https://example.org/ \
        --context=context.jsonld \
        item-with-prov.json > item.ttl
   ```

2. **Run SHACL Validation**
   ```bash
   pyshacl -s shacl/liability-claims-shapes.ttl \
           -df turtle \
           -sf turtle \
           item.ttl
   ```

3. **Interpret Results**
   - `sh:conforms true` - Data is valid
   - `sh:conforms false` - Violations detected
   - `sh:result` array contains violation details

## Validation Rules Summary

### Entity Rules
- ✓ Every entity has a type
- ✓ Generated entities link to activities
- ✓ Attributed entities link to agents
- ✓ Derived entities reference source entities
- ✓ Source entities exist in graph

### Activity Rules
- ✓ Activities have start/end times (if temporal)
- ✓ End time ≥ start time
- ✓ Activities associated with at least one agent
- ✓ Used entities exist in graph
- ✓ Associated agents exist in graph

### Agent Rules
- ✓ Agents have type (Person, Organization, SoftwareAgent)
- ✓ Agents have name or label
- ✓ Delegation targets exist in graph

### Temporal Rules
- ✓ Derived entities generated after source entities
- ✓ Entity usage occurs during activity execution
- ✓ Activity sequences respect temporal ordering

### Quality Rules
- ✓ Quality metadata has measurements
- ✓ Measurements reference valid metrics
- ✓ Measurements have values

## Example Violations

### Missing Entity Type
```turtle
# INVALID: Entity without type
ex:dataset1 a prov:Entity .
```

**Violation**: `Every prov:Entity should have at least one prov:type`

### Temporal Inconsistency
```turtle
# INVALID: Activity ends before it starts
ex:activity1 a prov:Activity ;
  prov:startedAtTime "2023-01-02T00:00:00Z"^^xsd:dateTime ;
  prov:endedAtTime "2023-01-01T00:00:00Z"^^xsd:dateTime .
```

**Violation**: `Activity end time must be after or equal to start time`

### Broken Provenance Chain
```turtle
# INVALID: References non-existent source
ex:dataset2 a prov:Entity ;
  prov:wasDerivedFrom ex:nonexistent .
```

**Violation**: `Derived entity references non-existent source entity`

## Integration with CI/CD

See `.github/workflows/validate.yml` for automated SHACL validation in GitHub Actions.

## SPARQL Queries

SHACL rules use SPARQL for complex constraints:

```sparql
# Temporal consistency check
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT $this
WHERE {
  $this prov:wasDerivedFrom ?source ;
        prov:wasGeneratedBy/prov:endedAtTime ?thisTime .
  ?source prov:wasGeneratedBy/prov:endedAtTime ?sourceTime .
  FILTER (?thisTime < ?sourceTime)
}
```

## Benefits

1. **Semantic Correctness**: Validates RDF semantics beyond JSON structure
2. **Graph Consistency**: Ensures provenance chains are complete and valid
3. **Temporal Ordering**: Validates time-based constraints
4. **Quality Assurance**: Links quality metadata to measurements
5. **Standards Compliance**: Enforces W3C PROV-O and DQV specifications

## References

- **W3C SHACL**: https://www.w3.org/TR/shacl/
- **W3C PROV-O**: https://www.w3.org/TR/prov-o/
- **pyshacl Documentation**: https://github.com/RDFLib/pySHACL
- **Apache Jena SHACL**: https://jena.apache.org/documentation/shacl/

## Support

For issues with SHACL validation:
- Check shape syntax with SHACL validator
- Verify data is valid RDF (Turtle/JSON-LD)
- Review violation messages for specific constraint failures

**Contact**: luciocol@gmail.com
