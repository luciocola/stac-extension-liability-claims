# STAC Liability and Claims Extension

## Overview

The Liability and Claims Extension provides comprehensive fields for documenting liability information, legal claims, and insurance matters associated with geospatial data assets. This extension is particularly valuable for:

- **Environmental Monitoring**: Track environmental incidents, spills, and habitat damage
- **Insurance Industry**: Link geospatial data with insurance claims and coverage
- **Legal Compliance**: Document jurisdictions, responsible parties, and legal proceedings
- **Government Agencies**: Maintain records of public liability and damage assessments
- **Emergency Response**: Track incident responses and affected geographic areas

## Key Features

### Claim Documentation

Track complete lifecycle of liability claims:
- Unique claim identifiers and types (environmental, property, injury, financial, operational)
- Status tracking (pending, investigation, accepted, rejected, settled, closed)
- Resolution outcomes and dates
- Affected parties and roles
- Geographic coverage areas (GeoJSON geometries)

### Financial Information

Document monetary aspects:
- Estimated damages with ISO 4217 currency codes
- Insurance provider and policy numbers
- Legal jurisdiction
- Settlement information

### Data Quality and Provenance

#### ISO 19115/19115-4 Support

Complete implementation of international geospatial metadata standards:
- **Core Quality Elements**: Completeness, logical consistency, positional accuracy, temporal accuracy, thematic accuracy
- **Imagery Quality**: Radiometric accuracy, sensor quality, cloud coverage, processing levels
- **DGIWG Extensions**: Defence geospatial quality requirements
- **Lineage**: Multi-step processing documentation with source traceability

#### W3C PROV Integration

Full W3C Provenance model support via PROV-JSON:
- Entities, Activities, and Agents
- All PROV relations (wasGeneratedBy, used, wasDerivedFrom, etc.)
- Delegation and attribution chains
- Semantic web compatibility

### Semantic Web Integration

JSON-LD context enables:
- RDF uplift and knowledge graph integration
- SPARQL queries
- Ontology mappings to Schema.org, W3C Legal, FIBO (financial), DQV (data quality)

## Dependencies

This building block extends and depends on:

- **ogc.contrib.stac.item** - Base STAC Item schema
- **ogc.contrib.stac.collection** - Base STAC Collection schema
- **ogc.ogc-utils.prov** - W3C PROV utilities

## Scope

- Items: ✓ Full support
- Collections: ✓ Full support
- Assets: ✓ Security classification and access restrictions
- Catalogs: ✗ Not applicable
- Links: ✗ Not applicable

## Field Prefix

All fields in this extension use the `liability:` prefix.

## Maturity

**Status**: Under Development  
**Maturity Classification**: Proposal

This extension is actively maintained and undergoing community review. It has been validated against:
- STAC 1.0.0 specification
- ISO 19115-1:2014 and ISO 19115-4:2021
- W3C PROV-DM and PROV-JSON
- OGC Building Blocks standards

## Use Cases

### Environmental Liability Tracking

Document oil spills, chemical releases, habitat destruction, and associated claims with:
- Geographic extent of environmental impact
- Affected species or ecosystems (via affected_parties)
- Cleanup costs and responsible parties
- Regulatory jurisdiction and compliance status

### Insurance Claims Management

Link satellite imagery, damage assessments, and sensor data to insurance claims:
- Policy numbers and providers
- Estimated vs. actual damages
- Evidence references (imagery, reports, assessments)
- Settlement tracking and resolution dates

### Legal Compliance

Maintain geospatial records for legal proceedings:
- Court jurisdictions
- Responsible party identification
- Evidence chain of custody (via PROV provenance)
- Resolution status and outcomes

### Data Quality Assurance

Provide comprehensive quality metadata for decision-making:
- Positional accuracy assessments
- Thematic accuracy (classification quality)
- Processing lineage and methodology
- Source data citations and references

## Interoperability

### NASA UMM Compatibility

High compatibility (5/5) with NASA's Unified Metadata Model through shared ISO 19115 foundation. See extension documentation for detailed crosswalk.

### OGC TrainingDML-AI

Good compatibility (4/5) for ML training data quality and provenance metadata. Supports training dataset lineage and quality assessment.

## Example Usage

### Basic Environmental Claim

```json
{
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "liability:claim_id": "ENV-2025-001",
    "liability:claim_type": "environmental",
    "liability:claim_status": "under_investigation",
    "liability:incident_date": "2025-12-08T09:15:00Z",
    "liability:responsible_party": "Maritime Transport Company XYZ",
    "liability:damages_estimated": 2500000.00,
    "liability:damages_currency": "USD",
    "liability:legal_jurisdiction": "California State Court"
  }
}
```

### With W3C PROV Provenance

```json
{
  "properties": {
    "liability:claim_id": "CLM-PROV-001",
    "liability:prov": {
      "prefix": {
        "ex": "http://example.org/claims/",
        "prov": "http://www.w3.org/ns/prov#"
      },
      "entity": {
        "ex:landcover_map": {
          "prov:type": "prov:Dataset",
          "prov:label": "Land Cover Classification"
        }
      },
      "activity": {
        "ex:classification": {
          "prov:type": "prov:Activity",
          "prov:label": "Random Forest Classification"
        }
      },
      "wasGeneratedBy": {
        "_:gen1": {
          "prov:entity": "ex:landcover_map",
          "prov:activity": "ex:classification"
        }
      }
    }
  }
}
```

### With ISO 19115 Quality

```json
{
  "properties": {
    "liability:quality": {
      "reportId": "QA-2025-001",
      "scope": "dataset",
      "elements": [
        {
          "elementType": "positionalAccuracy",
          "summary": "Positional accuracy within 10 meters CE90",
          "detail": {
            "type": "positionalAccuracy",
            "absoluteExternalPositionalAccuracy": 10.0,
            "units": "meters",
            "datum": "WGS84"
          }
        },
        {
          "elementType": "lineage",
          "detail": {
            "type": "lineage",
            "statement": "Derived from Sentinel-2 imagery",
            "processStep": [
              {
                "description": "Atmospheric correction",
                "dateTime": "2025-11-15T00:00:00Z",
                "processingInformation": {
                  "softwareReference": [
                    {
                      "title": "Sen2Cor",
                      "version": "2.11"
                    }
                  ]
                }
              }
            ]
          }
        }
      ]
    }
  }
}
```

## Validation

### JSON Schema Validation

All examples pass JSON Schema validation. The extension includes:
- Valid examples demonstrating correct usage patterns
- Invalid examples showing common validation errors
- Automated validation scripts for CI/CD integration

### SHACL Semantic Validation

**NEW in v1.1.0:** The extension includes comprehensive SHACL (Shapes Constraint Language) validation rules for semantic correctness:

#### SHACL Validation Rules

- **Core Extension Properties**: Validates required fields (liability_framework, jurisdiction, liability_terms)
- **PROV Provenance Graphs**: Complete validation of W3C PROV entities, activities, and agents
- **Temporal Consistency**: Ensures activity start/end times are logically ordered
- **Graph Completeness**: Validates that all referenced entities and agents exist
- **Quality Metadata**: Validates ISO 19115 quality measurements and metrics
- **Provenance Chains**: Ensures derivation relationships are complete and valid

#### Running SHACL Validation

```bash
# Install pyshacl
pip install pyshacl rdflib

# Convert JSON-LD to Turtle
riot --syntax=jsonld --output=turtle examples/item-with-prov.json > item.ttl

# Run SHACL validation
pyshacl -s shacl/liability-claims-shapes.ttl -df turtle -sf turtle item.ttl
```

### CI/CD Automation

Automated validation runs on every push and pull request via GitHub Actions:
- JSON Schema validation across Python 3.9-3.12
- SHACL semantic validation with detailed reports
- OGC Building Blocks compliance verification
- Security scanning with Trivy
- Documentation completeness checks
- Test coverage reporting

See `.github/workflows/validate.yml` for the complete CI/CD pipeline.

## References

- [Extension Specification](https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json)
- [GitHub Repository](https://github.com/luciocola/stac-extension-liability-claims)
- [ISO 19115-1:2014](https://www.iso.org/standard/53798.html)
- [ISO 19115-4:2021](https://www.iso.org/standard/77867.html)
- [W3C PROV-DM](https://www.w3.org/TR/prov-dm/)
- [W3C PROV-JSON](https://www.w3.org/Submission/prov-json/)

## License

Apache License 2.0

## Maintainer

Lucio Colaiacomo (@luciocola)  
Secure Dimensions GmbH  
luciocol@gmail.com
