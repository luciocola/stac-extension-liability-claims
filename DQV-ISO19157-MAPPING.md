# W3C Data Quality Vocabulary (DQV) - ISO 19157 Mapping

## Overview

This document describes the semantic lifting strategy for mapping ISO 19157 data quality concepts to the **W3C Data Quality Vocabulary (DQV)** for RDF/Linked Data interoperability.

### Purpose

The semantic lifting enables:
- **Linked Data** representation of geospatial quality metadata
- **SPARQL querying** of quality information across datasets  
- **Semantic interoperability** with other DQV-compliant systems
- **Ontology alignment** between ISO and W3C standards

### Standards Alignment

| Standard | Version | Purpose |
|----------|---------|---------|
| **ISO 19157-1** | 2023 | Geographic information - Data quality - General requirements |
| **ISO 19157-3** | 2026 (expected) | Data quality measures register |
| **W3C DQV** | 2016 | Data Quality Vocabulary (W3C Note) |
| **W3C PROV-O** | 2013 | Provenance Ontology |
| **W3C DCAT** | 2020 | Data Catalog Vocabulary |

---

## Core Mapping Principles

### 1. Quality Categories → DQV Dimensions

ISO 19157 quality categories map to `dqv:Dimension` class:

| ISO 19157 Category | DQV Dimension | RDF Type |
|-------------------|---------------|----------|
| `completeness` | `dqv:Dimension` + `dqv:CompletenessMetric` | Category + Metric type |
| `logicalConsistency` | `dqv:Dimension` + `dqv:ConsistencyMetric` | Category + Metric type |
| `positionalAccuracy` | `dqv:Dimension` + `dqv:AccuracyMetric` | Category + Metric type |
| `thematicQuality` | `dqv:Dimension` + `dqv:AccuracyMetric` | Category + Metric type |
| `temporalQuality` | `dqv:Dimension` + `dqv:TemporalAccuracyMetric` | Category + Metric type |
| `usability` | `dqv:Dimension` + `dqv:UsabilityMetric` | Category + Metric type |
| `metaquality` | `dqv:Dimension` (custom) | New dimension |

**JSON-LD Context:**
```jsonld
{
  "completeness": "dqv:CompletenessMetric",
  "logicalConsistency": "dqv:ConsistencyMetric",
  "positionalAccuracy": "dqv:AccuracyMetric",
  "temporalQuality": "dqv:TemporalAccuracyMetric"
}
```

### 2. Quality Measures → DQV Metrics

ISO 19157 quality measures (e.g., Measure 28, Measure 47) map to `dqv:Metric` instances:

```turtle
# ISO 19157 Measure 28 - Mean value of positional uncertainties
iso19157:Measure28 a dqv:Metric ;
    rdfs:label "Mean value of positional uncertainties" ;
    dqv:inDimension dqv:AccuracyMetric ;
    dqv:expectedDataType xsd:decimal ;
    dcterms:source <https://def.isotc211.org/dataqualitymeasures/28> .
```

**JSON Representation:**
```json
{
  "measure": {
    "measureIdentification": {
      "code": "28",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Mean value of positional uncertainties"]
  }
}
```

**DQV Lifting:**
- `measureIdentification.code` → `dqv:Metric` instance identifier
- `nameOfMeasure` → `rdfs:label`
- `measureDescription` → `dcterms:description`

### 3. Quality Results → DQV Quality Measurements

ISO 19157 quality results map to `dqv:QualityMeasurement` class:

```turtle
:PositionalAccuracyMeasurement a dqv:QualityMeasurement ;
    dqv:isMeasurementOf iso19157:Measure28 ;
    dqv:value "12.3"^^xsd:decimal ;
    sdmx-attribute:unitMeasure <http://qudt.org/vocab/unit/M> ;
    dqv:computedOn :SentinelImagery2025 ;
    prov:generatedAtTime "2025-06-16T14:00:00Z"^^xsd:dateTime .
```

**JSON Representation:**
```json
{
  "resultType": "quantitative",
  "value": [12.3],
  "valueUnit": "meter",
  "errorStatistic": "RMSE"
}
```

**DQV Lifting:**
- `resultType` → DQV result class (`dqv:QualityMeasurement`)
- `value` → `dqv:value`
- `valueUnit` → `sdmx-attribute:unitMeasure` (or `qudt:unit`)
- ISO measure → `dqv:isMeasurementOf`

### 4. Quality Evaluation → DQV Quality Annotations

ISO 19157 evaluation methods map to `dqv:QualityAnnotation`:

```turtle
:QualityEvaluation a dqv:QualityAnnotation ;
    dqv:hasQualityMeasurement :PositionalAccuracyMeasurement ;
    oa:hasBody [
        rdf:value "Positional accuracy assessed using ground control points" ;
        dcterms:created "2025-06-16T14:00:00Z"^^xsd:dateTime ;
        dcterms:creator :ProcessorOrganization
    ] ;
    oa:motivatedBy dqv:qualityAssessment .
```

**JSON Representation:**
```json
{
  "evaluationMethod": {
    "evaluationMethodType": "directExternal",
    "evaluationMethodDescription": "RMSE calculation using ground control points",
    "dateTime": "2025-06-16T14:00:00Z"
  }
}
```

---

## Detailed Component Mappings

### DQ_Scope → dqv:inCategory

ISO 19157 scope levels map to DQV category contexts:

```turtle
:DatasetQualityScope a dqv:QualityPolicy ;
    dqv:inCategory dqv:Dimension ;
    dcterms:type "dataset" ;
    dcterms:description "Quality assessment applies to entire dataset" .
```

**JSON-LD:**
```json
{
  "scope": {
    "level": "dataset",
    "@context": {
      "level": "dcterms:type",
      "scope": "dqv:inCategory"
    }
  }
}
```

### DQ_Result Types → DQV Value Types

| ISO 19157 Result | DQV Mapping | RDF Type |
|-----------------|-------------|----------|
| `dq_quantitative_result` | `dqv:value` | `xsd:decimal`, `xsd:integer` |
| `dq_conformance_result` | `dqv:conformsTo` + `dqv:isSuccessful` | `xsd:boolean` |
| `dq_descriptive_result` | `rdf:value` (literal) | `xsd:string` |
| `dq_coverage_result` | Custom (spatial data) | `geo:Feature` or raster reference |

**Example - Conformance Result:**
```turtle
:ConformanceMeasurement a dqv:QualityMeasurement ;
    dqv:conformsTo <https://inspire.ec.europa.eu/id/ats/ad/3.1> ;
    dqv:isSuccessful true ;
    dcterms:description "Meets INSPIRE positional accuracy requirement" .
```

### Lineage → PROV-O

ISO 19115/19157 lineage elements map to W3C PROV-O:

| ISO Element | PROV-O Class | Mapping |
|-------------|--------------|---------|
| `LI_Lineage.statement` | `prov:value` | Textual description |
| `LI_ProcessStep` | `prov:Activity` | Processing activity |
| `LI_Source` | `prov:Entity` | Source data entity |
| `LE_Processing` | `prov:Plan` | Processing procedure |
| `LE_Algorithm` | `prov:SoftwareAgent` | Algorithm/software |

**Example:**
```turtle
:AtmosphericCorrectionActivity a prov:Activity ;
    prov:startedAtTime "2025-06-16T08:00:00Z"^^xsd:dateTime ;
    prov:endedAtTime "2025-06-16T08:30:00Z"^^xsd:dateTime ;
    prov:used :SentinelL1CImagery ;
    prov:wasAssociatedWith :Sen2CorProcessor ;
    prov:qualifiedUsage [
        a prov:Usage ;
        prov:entity :SentinelL1CImagery ;
        prov:hadRole :SourceImagery
    ] .
```

---

## Semantic Lifting Examples

### Example 1: Complete Quality Measurement with DQV

**ISO 19157 JSON:**
```json
{
  "category": "positionalAccuracy",
  "subcategory": "absoluteExternalPositionalAccuracy",
  "measure": {
    "measureIdentification": {
      "code": "28",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Mean value of positional uncertainties"]
  },
  "evaluationMethod": {
    "evaluationMethodType": "directExternal",
    "evaluationMethodDescription": "Ground control point comparison",
    "dateTime": "2025-06-16T14:00:00Z"
  },
  "result": [{
    "resultType": "quantitative",
    "value": [12.3],
    "valueUnit": "meter",
    "errorStatistic": "RMSE"
  }]
}
```

**DQV RDF (Turtle):**
```turtle
@prefix dqv: <http://www.w3.org/ns/dqv#> .
@prefix iso19157: <https://def.isotc211.org/dataqualitymeasures/> .
@prefix qudt: <http://qudt.org/vocab/unit/> .
@prefix prov: <http://www.w3.org/ns/prov#> .

:PositionalAccuracyMeasurement a dqv:QualityMeasurement ;
    rdfs:label "Positional Accuracy Assessment - June 2025" ;
    dqv:isMeasurementOf iso19157:Measure28 ;
    dqv:inDimension dqv:AccuracyMetric ;
    dqv:value "12.3"^^xsd:decimal ;
    sdmx-attribute:unitMeasure qudt:M ;
    dqv:computedOn :SentinelImagery2025 ;
    prov:wasGeneratedBy :QualityAssessmentActivity ;
    prov:generatedAtTime "2025-06-16T14:00:00Z"^^xsd:dateTime .

:QualityAssessmentActivity a prov:Activity ;
    prov:used :GroundControlPoints ;
    rdfs:comment "Ground control point comparison using RMSE calculation" ;
    prov:wasAssociatedWith :GeospatialQualityTeam .

iso19157:Measure28 a dqv:Metric ;
    rdfs:label "Mean value of positional uncertainties" ;
    dqv:inDimension dqv:AccuracyMetric ;
    dqv:expectedDataType xsd:decimal ;
    dcterms:source <https://def.isotc211.org/dataqualitymeasures/28> .
```

### Example 2: Metaquality (Confidence) with DQV

ISO 19157-3 introduces metaquality for quality-of-quality assessments. Map to DQV custom dimension:

**ISO 19157 JSON:**
```json
{
  "category": "metaquality",
  "subcategory": "confidence",
  "measure": {
    "measureIdentification": {
      "code": "129",
      "codeSpace": "ISO 19157",
      "version": "2023"
    },
    "nameOfMeasure": ["Confidence in data quality result"]
  },
  "result": [{
    "resultType": "quantitative",
    "value": [0.95],
    "valueUnit": "probability"
  }]
}
```

**DQV RDF:**
```turtle
:ConfidenceMeasurement a dqv:QualityMeasurement ;
    dqv:isMeasurementOf iso19157:Measure129 ;
    dqv:inDimension :MetaqualityDimension ;
    dqv:value "0.95"^^xsd:decimal ;
    sdmx-attribute:unitMeasure :Probability ;
    prov:wasDerivedFrom :SensorCalibrationCertificate .

:MetaqualityDimension a dqv:Dimension ;
    rdfs:label "Metaquality - Confidence in Quality Assessment" ;
    rdfs:comment "Dimension representing confidence in the quality measurement itself" .
```

### Example 3: Lineage with PROV-O

**ISO 19157 Lineage JSON:**
```json
{
  "lineage": {
    "statement": "Sentinel-2 L2A atmospherically corrected surface reflectance",
    "processStep": [{
      "description": "Atmospheric correction using Sen2Cor v2.10",
      "dateTime": "2025-06-16T08:30:00Z",
      "processor": {
        "organisationName": "ESA Copernicus"
      },
      "processingInformation": {
        "identifier": "Sen2Cor v2.10",
        "algorithm": [{
          "citation": {
            "title": "Sen2Cor Algorithm Theoretical Basis Document"
          },
          "description": "MODTRAN-based radiative transfer model"
        }]
      }
    }]
  }
}
```

**PROV-O RDF:**
```turtle
:Sentinel2L2AProduct a prov:Entity ;
    prov:wasGeneratedBy :AtmosphericCorrectionActivity ;
    prov:wasDerivedFrom :Sentinel2L1CProduct ;
    rdfs:comment "Sentinel-2 L2A atmospherically corrected surface reflectance" .

:AtmosphericCorrectionActivity a prov:Activity ;
    rdfs:label "Atmospheric Correction - Sen2Cor v2.10" ;
    prov:startedAtTime "2025-06-16T08:00:00Z"^^xsd:dateTime ;
    prov:endedAtTime "2025-06-16T08:30:00Z"^^xsd:dateTime ;
    prov:wasAssociatedWith :ESACopernicusProgram ;
    prov:used :Sentinel2L1CProduct ;
    prov:qualifiedAssociation [
        a prov:Association ;
        prov:agent :Sen2CorSoftware ;
        prov:hadPlan :MODTRANAlgorithm
    ] .

:Sen2CorSoftware a prov:SoftwareAgent ;
    rdfs:label "Sen2Cor v2.10" ;
    prov:actedOnBehalfOf :ESACopernicusProgram .

:MODTRANAlgorithm a prov:Plan ;
    rdfs:label "MODTRAN-based Radiative Transfer Model" ;
    dcterms:description "Sen2Cor Algorithm Theoretical Basis Document" .
```

---

## JSON-LD Context Extensions

Complete JSON-LD context for DQV semantic lifting:

```jsonld
{
  "@context": {
    "dqv": "http://www.w3.org/ns/dqv#",
    "prov": "http://www.w3.org/ns/prov#",
    "iso19157": "https://def.isotc211.org/dataqualitymeasures/",
    "qudt": "http://qudt.org/vocab/unit/",
    
    "liability:quality": {
      "@id": "dqv:hasQualityMeasurement",
      "@type": "@json"
    },
    "liability:dataQualityInfo": {
      "@id": "dqv:hasQualityAnnotation",
      "@type": "@json"
    },
    "liability:lineage": {
      "@id": "prov:has_provenance",
      "@type": "@json"
    },
    
    "category": "dqv:inCategory",
    "subcategory": "dqv:inDimension",
    "measure": "dqv:isMeasurementOf",
    "result": {
      "@id": "dqv:value",
      "@type": "@json"
    },
    "value": "dqv:value",
    "valueUnit": "sdmx-attribute:unitMeasure",
    
    "completeness": "dqv:CompletenessMetric",
    "logicalConsistency": "dqv:ConsistencyMetric",
    "positionalAccuracy": "dqv:AccuracyMetric",
    "temporalQuality": "dqv:TemporalAccuracyMetric",
    "thematicQuality": "dqv:AccuracyMetric",
    "usability": "dqv:UsabilityMetric",
    
    "evaluationMethod": "dqv:computedOn",
    "conformanceResult": "dqv:conformsTo",
    "pass": "dqv:isSuccessful",
    
    "lineage": "prov:has_provenance",
    "processStep": {
      "@id": "prov:Activity",
      "@container": "@list"
    },
    "source": {
      "@id": "prov:Entity",
      "@container": "@list"
    }
  }
}
```

---

## Implementation Guidelines

### 1. For Data Producers

**Include DQV metadata in STAC items:**
```json
{
  "stac_version": "1.0.0",
  "type": "Feature",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "liability:dataQualityInfo": [{
      "scope": {"level": "dataset"},
      "report": [{
        "category": "positionalAccuracy",
        "measure": {
          "measureIdentification": {
            "code": "28",
            "codeSpace": "ISO 19157"
          }
        },
        "result": [{
          "resultType": "quantitative",
          "value": [12.3],
          "valueUnit": "meter"
        }]
      }]
    }]
  }
}
```

### 2. For Linked Data Consumers

**SPARQL Query Example - Find datasets with high positional accuracy:**
```sparql
PREFIX dqv: <http://www.w3.org/ns/dqv#>
PREFIX iso19157: <https://def.isotc211.org/dataqualitymeasures/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?dataset ?accuracyValue
WHERE {
  ?dataset dqv:hasQualityMeasurement ?measurement .
  ?measurement dqv:isMeasurementOf iso19157:Measure28 ;
               dqv:value ?accuracyValue .
  FILTER (?accuracyValue < 10.0)
}
ORDER BY ?accuracyValue
```

### 3. For Application Developers

Use JSON-LD processors to convert JSON to RDF:
```javascript
const jsonld = require('jsonld');

const doc = {
  "@context": "https://stac-extensions.github.io/liability-claims/v1.1.0/context.jsonld",
  "properties": {
    "liability:quality": [/* quality data */]
  }
};

const rdf = await jsonld.toRDF(doc, {format: 'application/n-quads'});
```

---

## Benefits of Semantic Lifting

### 1. **Cross-Domain Interoperability**
- Quality metadata works with non-geospatial DQV systems
- Integration with broader Linked Open Data ecosystem

### 2. **Advanced Querying**
- SPARQL queries across multiple datasets
- Federated quality assessment
- Quality-based discovery and filtering

### 3. **Semantic Reasoning**
- Inference of quality implications
- Quality dimension relationships
- Automated quality policy compliance checking

### 4. **Standards Alignment**
- ISO 19157 + W3C DQV + PROV-O unified model
- Future-proof for ISO 19157-3 (2026)
- Compatible with OGC API standards

---

## Related Documentation

- [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) - Complete ISO 19157 integration guide
- [ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md](ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md) - Compatibility analysis
- [json-schema/iso19157-quality.json](json-schema/iso19157-quality.json) - ISO 19157 JSON Schema
- [json-schema/iso19157-lineage.json](json-schema/iso19157-lineage.json) - Lineage JSON Schema
- [json-schema/iso19157-scope.json](json-schema/iso19157-scope.json) - Scope and extent schema
- [context.jsonld](context.jsonld) - JSON-LD context with DQV mappings

## References

- **W3C DQV**: https://www.w3.org/TR/vocab-dqv/
- **W3C PROV-O**: https://www.w3.org/TR/prov-o/
- **ISO 19157-3 Development Register**: https://defs-hosted.opengis.net/prez-hosted/catalogs/hosted:iso-19157-3
- **OGC Testbed-21 DQ4IPT**: Data Quality for Imagery and Point Clouds

---

**Version**: 1.0  
**Date**: 2026-01-22  
**Author**: luciocol@gmail.com
