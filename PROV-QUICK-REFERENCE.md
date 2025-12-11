# W3C PROV Quick Reference

Quick guide for using the `liability:prov` field in STAC items.

## Minimal Example

```json
{
  "properties": {
    "liability:prov": {
      "prefix": {
        "ex": "http://example.org/",
        "prov": "http://www.w3.org/ns/prov#"
      },
      "entity": {
        "ex:output": {
          "prov:label": "Output dataset"
        },
        "ex:input": {
          "prov:label": "Input dataset"
        }
      },
      "activity": {
        "ex:processing": {
          "prov:label": "Data processing",
          "prov:startTime": "2025-12-11T10:00:00Z",
          "prov:endTime": "2025-12-11T12:00:00Z"
        }
      },
      "agent": {
        "ex:analyst": {
          "prov:type": "prov:Person",
          "prov:label": "Jane Doe"
        }
      },
      "wasGeneratedBy": {
        "_:wgb1": {
          "prov:entity": "ex:output",
          "prov:activity": "ex:processing"
        }
      },
      "used": {
        "_:u1": {
          "prov:activity": "ex:processing",
          "prov:entity": "ex:input"
        }
      },
      "wasAssociatedWith": {
        "_:waw1": {
          "prov:activity": "ex:processing",
          "prov:agent": "ex:analyst"
        }
      }
    }
  }
}
```

## Core Concepts

### Entity
A thing (dataset, file, document, etc.)

```json
"entity": {
  "ex:my_dataset": {
    "prov:type": "prov:Dataset",
    "prov:label": "My Dataset",
    "prov:location": "s3://bucket/data.tif",
    "ex:format": "GeoTIFF"
  }
}
```

### Activity
A process that acts on entities

```json
"activity": {
  "ex:my_process": {
    "prov:type": "ex:Processing",
    "prov:label": "Image Classification",
    "prov:startTime": "2025-12-11T10:00:00Z",
    "prov:endTime": "2025-12-11T12:00:00Z",
    "ex:software": "Python 3.11"
  }
}
```

### Agent
Something responsible (Person, Organization, Software)

```json
"agent": {
  "ex:person": {
    "prov:type": "prov:Person",
    "prov:label": "Dr. Jane Smith"
  },
  "ex:org": {
    "prov:type": "prov:Organization",
    "prov:label": "Research Institute"
  },
  "ex:software": {
    "prov:type": "prov:SoftwareAgent",
    "prov:label": "GDAL 3.7.0"
  }
}
```

## Common Relations

### wasGeneratedBy
"Output was created by processing"

```json
"wasGeneratedBy": {
  "_:wgb1": {
    "prov:entity": "ex:output",
    "prov:activity": "ex:processing",
    "prov:time": "2025-12-11T12:00:00Z"
  }
}
```

### used
"Processing consumed input"

```json
"used": {
  "_:u1": {
    "prov:activity": "ex:processing",
    "prov:entity": "ex:input",
    "prov:time": "2025-12-11T10:00:00Z"
  }
}
```

### wasDerivedFrom
"Output was derived from input"

```json
"wasDerivedFrom": {
  "_:wdf1": {
    "prov:generatedEntity": "ex:output",
    "prov:usedEntity": "ex:input"
  }
}
```

### wasAttributedTo
"Output was created by person"

```json
"wasAttributedTo": {
  "_:wat1": {
    "prov:entity": "ex:output",
    "prov:agent": "ex:person"
  }
}
```

### wasAssociatedWith
"Processing was done by person"

```json
"wasAssociatedWith": {
  "_:waw1": {
    "prov:activity": "ex:processing",
    "prov:agent": "ex:person"
  }
}
```

### actedOnBehalfOf
"Person acted for organization"

```json
"actedOnBehalfOf": {
  "_:aobo1": {
    "prov:delegate": "ex:person",
    "prov:responsible": "ex:organization"
  }
}
```

## Typical Patterns

### Simple Processing Chain

```
Input → Processing → Output
```

```json
{
  "entity": {
    "ex:input": {"prov:label": "Raw data"},
    "ex:output": {"prov:label": "Processed data"}
  },
  "activity": {
    "ex:proc": {"prov:label": "Processing"}
  },
  "wasGeneratedBy": {
    "_:wgb1": {"prov:entity": "ex:output", "prov:activity": "ex:proc"}
  },
  "used": {
    "_:u1": {"prov:activity": "ex:proc", "prov:entity": "ex:input"}
  },
  "wasDerivedFrom": {
    "_:wdf1": {"prov:generatedEntity": "ex:output", "prov:usedEntity": "ex:input"}
  }
}
```

### Multi-Stage Pipeline

```
Input → Stage1 → Intermediate → Stage2 → Output
```

```json
{
  "entity": {
    "ex:input": {"prov:label": "Input"},
    "ex:intermediate": {"prov:label": "Intermediate"},
    "ex:output": {"prov:label": "Output"}
  },
  "activity": {
    "ex:stage1": {"prov:label": "Stage 1"},
    "ex:stage2": {"prov:label": "Stage 2"}
  },
  "wasGeneratedBy": {
    "_:wgb1": {"prov:entity": "ex:intermediate", "prov:activity": "ex:stage1"},
    "_:wgb2": {"prov:entity": "ex:output", "prov:activity": "ex:stage2"}
  },
  "used": {
    "_:u1": {"prov:activity": "ex:stage1", "prov:entity": "ex:input"},
    "_:u2": {"prov:activity": "ex:stage2", "prov:entity": "ex:intermediate"}
  },
  "wasInformedBy": {
    "_:wib1": {"prov:informed": "ex:stage2", "prov:informant": "ex:stage1"}
  }
}
```

### With Attribution

```
Input → Processing → Output
           ↓
        Person
           ↓
      Organization
```

```json
{
  "entity": {"ex:output": {"prov:label": "Output"}},
  "activity": {"ex:proc": {"prov:label": "Processing"}},
  "agent": {
    "ex:person": {"prov:type": "prov:Person", "prov:label": "Jane"},
    "ex:org": {"prov:type": "prov:Organization", "prov:label": "Org"}
  },
  "wasGeneratedBy": {
    "_:wgb1": {"prov:entity": "ex:output", "prov:activity": "ex:proc"}
  },
  "wasAssociatedWith": {
    "_:waw1": {"prov:activity": "ex:proc", "prov:agent": "ex:person"}
  },
  "wasAttributedTo": {
    "_:wat1": {"prov:entity": "ex:output", "prov:agent": "ex:person"}
  },
  "actedOnBehalfOf": {
    "_:aobo1": {"prov:delegate": "ex:person", "prov:responsible": "ex:org"}
  }
}
```

## Namespace Prefixes

Always define prefixes:

```json
"prefix": {
  "ex": "http://example.org/",
  "prov": "http://www.w3.org/ns/prov#",
  "xsd": "http://www.w3.org/2001/XMLSchema#",
  "foaf": "http://xmlns.com/foaf/0.1/"
}
```

## Identifiers

Use qualified names:
- `ex:my_entity` - Custom namespace
- `prov:Dataset` - PROV type
- `_:wgb1` - Blank node (relation identifier)

## Custom Properties

Add domain-specific properties:

```json
"entity": {
  "ex:image": {
    "prov:label": "Satellite Image",
    "ex:satellite": "Sentinel-2A",
    "ex:resolution": "10m",
    "ex:bands": 13,
    "ex:cloudCover": 5.2
  }
}
```

## When to Use What

| Use Case | Relation |
|----------|----------|
| Output created by process | `wasGeneratedBy` |
| Process used input | `used` |
| Output derived from input | `wasDerivedFrom` |
| Process done by agent | `wasAssociatedWith` |
| Output created by agent | `wasAttributedTo` |
| Agent worked for org | `actedOnBehalfOf` |
| Process followed another | `wasInformedBy` |
| Entity is version of another | `specializationOf` |
| Two entities are alternates | `alternateOf` |

## See Also

- Complete example: `examples/item-with-prov.json`
- ISO 19115 mapping: `PROV-ISO19115-MAPPING.md`
- Full documentation: `README.md` → "W3C PROV Provenance Support"
- W3C PROV Primer: https://www.w3.org/TR/prov-primer/
