# Provenance & Lineage RDF Graphs

This directory contains W3C PROV-O compliant RDF/Turtle graphs describing provenance and lineage for STAC items using the Liability and Claims extension.

## Files

- **`liability-claims-provenance.ttl`** - Complete provenance graph for a land cover classification workflow with liability tracking

## Overview

The provenance graph demonstrates how to track the complete lineage of geospatial data products that may have legal or liability implications. It follows W3C PROV-O (Provenance Ontology) and integrates with the STAC Liability and Claims extension.

## Graph Structure

### 1. Entities (Data Products)
- **Primary Output**: `ex:LandCoverMap2025` - Final classified land cover map
- **Intermediate Products**:
  - `ex:AtmosphericallyCorrectedImagery` - Surface reflectance data
  - `ex:GeometricallyCorrectedImagery` - Orthorectified imagery
  - `ex:Sentinel2L1C` - Source satellite imagery
- **Training Data**: `ex:TrainingDataset` - Ground truth samples
- **Model**: `ex:ClassificationModel` - Trained machine learning model
- **Quality Assessment**: `ex:QualityReport` - Validation results

### 2. Activities (Processing Steps)
- **`ex:AtmosphericCorrectionActivity`** - FLAASH atmospheric correction
  - Input: Raw satellite imagery
  - Output: Surface reflectance
  - Parameters: Atmospheric model, aerosol type, visibility
  
- **`ex:GeometricCorrectionActivity`** - RPC orthorectification
  - Input: Atmospherically corrected imagery
  - Output: Geometrically corrected imagery
  - Uses: SRTM DEM, Ground Control Points
  
- **`ex:ClassificationActivity`** - Random Forest classification
  - Inputs: Corrected imagery, training data, model
  - Output: Land cover map
  
- **`ex:ModelTrainingActivity`** - Model development
- **`ex:FieldSurveyActivity`** - Ground truth collection
- **`ex:QualityAssessmentActivity`** - Independent validation

### 3. Agents (People, Organizations, Software)
- **People**: Analysts, data scientists, QA specialists
- **Organizations**: Environmental Monitoring Agency, ESA Copernicus
- **Software**: ENVI, ERDAS IMAGINE, scikit-learn

### 4. Quality Measurements
- Overall accuracy: 92.5%
- Kappa coefficient: 0.89
- Linked to DQV (Data Quality Vocabulary)

## Key Provenance Relationships

```
Sentinel2L1C (ESA)
    ↓ prov:used
AtmosphericCorrectionActivity → AtmosphericallyCorrectedImagery
    ↓ prov:used                      ↓ prov:wasDerivedFrom
GeometricCorrectionActivity → GeometricallyCorrectedImagery
    ↓ prov:used                      ↓ prov:wasDerivedFrom
ClassificationActivity → LandCoverMap2025
    ↑ prov:used              ↓ prov:wasAttributedTo
TrainingDataset          EnvironmentalMonitoringAgency
```

## Liability and Claims Integration

The provenance graph includes STAC Liability Claims extension properties:

```turtle
ex:LandCoverMap2025
    liability:claim_id "CLM-PROV-001" ;
    liability:claim_type "environmental" ;
    liability:claim_status "open" ;
    liability:liability_framework "ISO 19157 Data Quality" ;
    liability:jurisdiction "US" ;
    liability:origin "Environmental Monitoring Agency" .
```

## PROV-O Classes Used

- **`prov:Entity`** - Physical, digital, conceptual things
- **`prov:Activity`** - Something that occurs over time
- **`prov:Agent`** - Person, organization, or software
- **`prov:Bundle`** - Named set of provenance descriptions
- **`prov:Plan`** - Set of actions or steps (e.g., algorithms)
- **`prov:Collection`** - Group of entities
- **`prov:Usage`** - Specific use of entity by activity
- **`prov:Role`** - Function of entity in activity

## PROV-O Properties Used

### Entity-Activity
- `prov:wasGeneratedBy` - Activity that created entity
- `prov:used` - Entity used by activity
- `prov:wasDerivedFrom` - Transformation relationship
- `prov:hadPrimarySource` - Original source attribution

### Agent Relations
- `prov:wasAttributedTo` - Agent responsible for entity
- `prov:wasAssociatedWith` - Agent involved in activity
- `prov:actedOnBehalfOf` - Delegation relationship

### Temporal
- `prov:startedAtTime` - Activity start timestamp
- `prov:endedAtTime` - Activity end timestamp
- `prov:generatedAtTime` - Entity creation timestamp

### Versioning
- `prov:wasRevisionOf` - Updated version relationship

## Usage Examples

### 1. Query All Processing Steps
```sparql
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX ex: <http://example.org/liability-claims/>

SELECT ?activity ?label ?startTime ?endTime
WHERE {
  ex:LandCoverMap2025 prov:wasGeneratedBy ?finalActivity .
  ?finalActivity prov:used* ?intermediate .
  ?intermediate prov:wasGeneratedBy ?activity .
  ?activity rdfs:label ?label ;
            prov:startedAtTime ?startTime ;
            prov:endedAtTime ?endTime .
}
ORDER BY ?startTime
```

### 2. Find All Responsible Parties
```sparql
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX ex: <http://example.org/liability-claims/>

SELECT DISTINCT ?name ?role ?org
WHERE {
  ?entity prov:wasAttributedTo ?agent .
  ?agent a prov:Person ;
         foaf:name ?name ;
         schema:jobTitle ?role ;
         schema:affiliation ?org .
}
```

### 3. Trace Lineage Back to Source
```sparql
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX ex: <http://example.org/liability-claims/>

SELECT ?entity ?label
WHERE {
  ex:LandCoverMap2025 prov:wasDerivedFrom+ ?entity .
  ?entity rdfs:label ?label .
}
```

### 4. Get Quality Metrics
```sparql
PREFIX dqv: <http://www.w3.org/ns/dqv#>
PREFIX ex: <http://example.org/liability-claims/>

SELECT ?metric ?value
WHERE {
  ex:LandCoverMap2025 dqv:hasQualityMeasurement ?measurement .
  ?measurement dqv:isMeasurementOf ?metricDef ;
               dqv:value ?value .
  ?metricDef rdfs:label ?metric .
}
```

## Integration with STAC

The provenance graph can be embedded in STAC items using the `liability:prov` property:

```json
{
  "type": "Feature",
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "liability:claim_id": "CLM-PROV-001",
    "liability:prov": {
      "@context": "https://www.w3.org/ns/prov",
      "entity": { ... },
      "activity": { ... },
      "agent": { ... }
    }
  }
}
```

Or referenced externally:
```json
{
  "properties": {
    "liability:prov_uri": "https://example.org/prov/CLM-PROV-001.ttl"
  }
}
```

## Validation

Validate the provenance graph using:

```bash
# Using rapper (from raptor RDF library)
rapper -i turtle -c liability-claims-provenance.ttl

# Using riot (from Apache Jena)
riot --validate liability-claims-provenance.ttl
```

## Visualization

Generate visual diagrams:

```bash
# Using PROV-O Viz (requires Node.js)
npm install -g prov-o-viz
prov-o-viz liability-claims-provenance.ttl -o provenance-diagram.svg
```

## Standards Compliance

- **W3C PROV-O**: https://www.w3.org/TR/prov-o/
- **W3C DQV**: https://www.w3.org/TR/vocab-dqv/
- **DCAT**: https://www.w3.org/TR/vocab-dcat-2/
- **Dublin Core**: http://purl.org/dc/terms/
- **FOAF**: http://xmlns.com/foaf/spec/
- **Schema.org**: https://schema.org/

## References

1. Moreau, L., & Groth, P. (2013). *Provenance: An Introduction to PROV*. Morgan & Claypool.
2. W3C PROV-O: https://www.w3.org/TR/prov-o/
3. STAC Liability Claims Extension: https://stac-extensions.github.io/liability-claims/
4. ISO 19115-2: Geographic information — Metadata — Part 2: Extensions for imagery and gridded data

## License

Same as parent project (see top-level LICENSE file).
