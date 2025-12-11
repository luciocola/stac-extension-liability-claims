# W3C PROV and ISO 19115 Lineage Mapping

This document describes the relationship between the W3C PROV provenance model (`liability:prov`) and ISO 19115 lineage (`liability:quality.elements[].detail.lineage`) in the Liability and Claims STAC extension.

## Overview

Both provenance models serve complementary purposes:

- **ISO 19115 Lineage**: Geospatial metadata standard focused on data quality and processing history
- **W3C PROV**: General-purpose provenance model for the semantic web

The extension supports **both models simultaneously** to maximize interoperability across different communities.

## Conceptual Mapping

### Core Type Mappings

| ISO 19115 Concept | W3C PROV Type | Description |
|------------------|---------------|-------------|
| `source` | `prov:Entity` | Source datasets, reference data, input files |
| `processStep` | `prov:Activity` | Processing steps, transformations, analyses |
| `processor` | `prov:Agent` (Person/Organization) | Individuals or organizations responsible for processing |
| Software (in `processingInformation`) | `prov:Agent` (SoftwareAgent) | Software tools and applications |

### Relationship Mappings

| ISO 19115 Relationship | W3C PROV Relation | Description |
|------------------------|-------------------|-------------|
| processStep uses source | `prov:used` | Activity consumed Entity |
| processStep produces output | `prov:wasGeneratedBy` | Entity was created by Activity |
| output derived from source | `prov:wasDerivedFrom` | Entity derived from another Entity |
| processor performs processStep | `prov:wasAssociatedWith` | Activity performed by Agent |
| output attributed to processor | `prov:wasAttributedTo` | Entity created by Agent |
| processor works for organization | `prov:actedOnBehalfOf` | Agent acted on behalf of another Agent |

### Temporal Information

| ISO 19115 Field | W3C PROV Property | Notes |
|----------------|-------------------|-------|
| `processStep.stepDateTime` | `prov:startTime` / `prov:endTime` | ISO 19115 has single timestamp; PROV separates start/end |
| `source.sourceExtent.temporalElement` | Entity temporal attributes | Custom properties on prov:Entity |

### Descriptive Information

| ISO 19115 Field | W3C PROV Property | Notes |
|----------------|-------------------|-------|
| `source.description` | `prov:label` | Human-readable description |
| `processStep.description` | `prov:label` | Human-readable description |
| `processor.name` | `prov:label` or `foaf:name` | Agent identification |
| `processStep.rationale` | Custom property | Add as `ex:rationale` on Activity |
| `processingInformation.procedureDescription` | Custom property | Add as `ex:procedure` on Activity |

## Example: Side-by-Side Comparison

### ISO 19115 Lineage

```json
{
  "liability:quality": {
    "elements": [{
      "elementType": "lineage",
      "detail": {
        "type": "lineage",
        "statement": "Dataset derived from Sentinel-2 imagery via atmospheric correction",
        "processStep": [{
          "description": "Atmospheric correction using FLAASH",
          "stepDateTime": "2025-11-15T10:00:00Z",
          "processor": [{
            "name": "Dr. Jane Smith",
            "organizationName": "Remote Sensing Institute"
          }],
          "processingInformation": {
            "softwareReference": [{
              "title": "ENVI",
              "version": "5.6.3"
            }]
          }
        }],
        "source": [{
          "description": "Sentinel-2 Level-1C imagery",
          "sourceCitation": {
            "title": "Sentinel-2A MSI L1C",
            "identifier": "S2A_MSIL1C_20251110"
          }
        }]
      }
    }]
  }
}
```

### W3C PROV Equivalent

```json
{
  "liability:prov": {
    "prefix": {
      "ex": "http://example.org/",
      "prov": "http://www.w3.org/ns/prov#"
    },
    "entity": {
      "ex:output_dataset": {
        "prov:type": "prov:Dataset",
        "prov:label": "Atmospherically corrected imagery"
      },
      "ex:sentinel2_l1c": {
        "prov:type": "prov:Dataset",
        "prov:label": "Sentinel-2A MSI L1C",
        "ex:identifier": "S2A_MSIL1C_20251110"
      }
    },
    "activity": {
      "ex:atmos_correction": {
        "prov:type": "ex:AtmosphericCorrection",
        "prov:label": "Atmospheric correction using FLAASH",
        "prov:startTime": "2025-11-15T10:00:00Z",
        "prov:endTime": "2025-11-15T10:45:00Z"
      }
    },
    "agent": {
      "ex:jane_smith": {
        "prov:type": "prov:Person",
        "prov:label": "Dr. Jane Smith"
      },
      "ex:rs_institute": {
        "prov:type": "prov:Organization",
        "prov:label": "Remote Sensing Institute"
      },
      "ex:envi": {
        "prov:type": "prov:SoftwareAgent",
        "prov:label": "ENVI 5.6.3"
      }
    },
    "wasGeneratedBy": {
      "_:wgb1": {
        "prov:entity": "ex:output_dataset",
        "prov:activity": "ex:atmos_correction"
      }
    },
    "used": {
      "_:u1": {
        "prov:activity": "ex:atmos_correction",
        "prov:entity": "ex:sentinel2_l1c"
      }
    },
    "wasDerivedFrom": {
      "_:wdf1": {
        "prov:generatedEntity": "ex:output_dataset",
        "prov:usedEntity": "ex:sentinel2_l1c"
      }
    },
    "wasAssociatedWith": {
      "_:waw1": {
        "prov:activity": "ex:atmos_correction",
        "prov:agent": "ex:jane_smith"
      },
      "_:waw2": {
        "prov:activity": "ex:atmos_correction",
        "prov:agent": "ex:envi"
      }
    },
    "actedOnBehalfOf": {
      "_:aobo1": {
        "prov:delegate": "ex:jane_smith",
        "prov:responsible": "ex:rs_institute"
      }
    }
  }
}
```

## Conversion Guidelines

### ISO 19115 → W3C PROV

When converting ISO 19115 lineage to PROV:

1. **Create Entities**:
   - One entity for each `source`
   - One entity for the output dataset (implicit in ISO 19115)

2. **Create Activities**:
   - One activity for each `processStep`
   - Use `stepDateTime` as `prov:startTime` (estimate `endTime` if needed)

3. **Create Agents**:
   - One Person agent for each `processor`
   - One Organization agent for each `processor.organizationName`
   - One SoftwareAgent for each software in `processingInformation`

4. **Create Relations**:
   - `used`: Connect activity to each source
   - `wasGeneratedBy`: Connect output entity to activity
   - `wasDerivedFrom`: Connect output to each source
   - `wasAssociatedWith`: Connect activity to processor and software agents
   - `actedOnBehalfOf`: Connect person to organization

5. **Handle Custom Properties**:
   - Add ISO 19115-specific fields as custom properties with appropriate namespaces
   - Example: `ex:rationale`, `ex:procedureDescription`, `ex:algorithm`

### W3C PROV → ISO 19115

When converting PROV to ISO 19115 lineage:

1. **Extract Sources**:
   - Find all entities that are `used` by activities
   - Create `source` entries with `sourceCitation`

2. **Extract Process Steps**:
   - One `processStep` for each activity
   - Use `prov:startTime` as `stepDateTime`
   - Extract `prov:label` as `description`

3. **Extract Processors**:
   - Find agents via `wasAssociatedWith`
   - Person agents → `processor.name`
   - Organization agents → `processor.organizationName`
   - SoftwareAgent agents → `processingInformation.softwareReference`

4. **Handle Multiple Agents**:
   - ISO 19115 supports arrays of processors
   - Map all Person/Organization agents to processor array
   - Map all SoftwareAgent agents to softwareReference array

5. **Derive Statement**:
   - Generate `statement` from PROV graph structure
   - Example: "Dataset derived from [sources] via [activities]"

## Use Cases for Each Model

### Use ISO 19115 Lineage When:

- Working primarily with GIS/geospatial tools
- Need to comply with ISO metadata standards
- Generating metadata for OGC services (WMS, WCS, WFS)
- Integrating with existing geospatial metadata catalogs
- Users expect traditional geospatial metadata formats

### Use W3C PROV When:

- Need semantic web integration (RDF, SPARQL, Linked Data)
- Complex provenance graphs with multiple derivation chains
- Cross-domain provenance (beyond geospatial)
- Integration with W3C PROV tools and visualizers
- Need explicit attribution and responsibility tracking
- Publishing to LOD (Linked Open Data) platforms

### Use Both When:

- Maximum interoperability is required
- Supporting multiple user communities (geospatial + semantic web)
- Need both quality-focused (ISO) and attribution-focused (PROV) provenance
- Archival purposes where multiple representations ensure long-term access

## Tool Support

### PROV Tools

- **ProvToolbox** (Java): Convert between PROV formats (PROV-N, PROV-O, PROV-JSON, PROV-XML)
- **prov Python library**: Create and manipulate PROV documents programmatically
- **ProvStore**: Online repository for provenance documents
- **PROV-O-Viz**: Visualize PROV graphs as SVG diagrams
- **SPARQL endpoints**: Query PROV-O RDF graphs

### ISO 19115 Tools

- **pygeometa**: Generate ISO 19115 metadata from YAML
- **GeoNetwork**: ISO 19115 metadata catalog
- **GDAL**: Extract/embed ISO 19115 metadata in geospatial files
- **ArcGIS/QGIS**: Native support for ISO 19115 metadata

## References

### W3C PROV Specifications

- [PROV-Overview](https://www.w3.org/TR/prov-overview/) - Overview of PROV family
- [PROV-DM](https://www.w3.org/TR/prov-dm/) - PROV Data Model
- [PROV-JSON](https://www.w3.org/Submission/prov-json/) - JSON serialization
- [PROV-O](https://www.w3.org/TR/prov-o/) - PROV Ontology (OWL/RDF)
- [PROV-Primer](https://www.w3.org/TR/prov-primer/) - Tutorial and examples

### ISO 19115 Standards

- [ISO 19115-1:2014](https://www.iso.org/standard/53798.html) - Metadata fundamentals
- [ISO 19115-2:2019](https://www.iso.org/standard/67039.html) - Extensions for imagery and gridded data
- [ISO 19115-4](https://github.com/ISO-TC211/XML/tree/master/schemas.isotc211.org/json/19115/-4) - JSON schema for lineage

### Mapping References

- [PROV-DC](https://www.w3.org/TR/prov-dc/) - Dublin Core to PROV mapping (analogous approach)
- [ISO 19115 to DCAT](https://www.w3.org/TR/vocab-dcat-2/) - Related metadata mapping patterns

## Future Work

Potential enhancements for PROV-ISO integration:

1. **Automated Conversion Tools**: Bidirectional converters between formats
2. **Validation Rules**: Ensure consistency when both models are present
3. **Extended Mappings**: Handle more ISO 19115 quality elements in PROV
4. **PROV-O Assets**: Support RDF/JSON-LD serialization as STAC assets
5. **SHACL Shapes**: Define PROV shapes for validation
6. **Graph Visualization**: Auto-generate PROV diagrams from ISO lineage

## Contributing

Feedback on this mapping is welcome. Please open issues or pull requests at:
https://github.com/stac-extensions/liability-claims

---

**Document Version:** 1.0  
**Last Updated:** 2025-12-11  
**Extension Version:** 1.1.0
