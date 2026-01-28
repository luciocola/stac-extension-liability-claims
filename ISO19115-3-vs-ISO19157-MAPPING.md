# ISO 19115-3 vs ISO 19157 Metadata-Quality Integration Mapping

## Overview

This document provides a comprehensive mapping between **ISO 19115-3:2016** (Geographic information - Metadata - Part 3: XML schema implementation for fundamental concepts) and **ISO 19157-1:2023** (Geographic information - Data quality - Part 1: General requirements), with forward compatibility to **ISO 19157-3:2026**.

### Standards Summary

| Standard | Full Title | Primary Focus | Publication Status |
|----------|-----------|---------------|-------------------|
| **ISO 19115-1:2014** | Geographic information - Metadata - Part 1: Fundamentals | Core metadata model for geographic resources | Published |
| **ISO 19115-3:2016** | Geographic information - Metadata - Part 3: XML schema implementation | XML encoding of ISO 19115-1 concepts | Published |
| **ISO 19157-1:2023** | Geographic information - Data quality - Part 1: General requirements | Data quality framework and principles | Published (2023 revision) |
| **ISO 19157-3:2026** | Geographic information - Data quality - Part 3: Measures register | Standardized quality measures catalog | Expected April 2026 |

### Key Integration Points

| Aspect | ISO 19115-3 | ISO 19157-1 |
|--------|-------------|-------------|
| **Namespace** | `mdb:`, `mri:`, `mrd:`, `mrl:` (metadata) | `mdq:` (data quality) |
| **XML Root** | `mdb:MD_Metadata` | `mdq:DQ_DataQuality` |
| **Quality Container** | `mdb:metadataScope/mdb:resourceScope` | `mdq:scope` |
| **Lineage** | `mrl:LI_Lineage` | `mdq:lineage` (reference) |
| **Integration Point** | `mdb:dataQualityInfo` element | Contains `mdq:DQ_DataQuality` |
| **Encoding** | XML Schema (XSD) | XML Schema + JSON Schema |

---

## Architectural Integration

### Metadata-Quality Relationship

ISO 19115-3 metadata contains ISO 19157 quality information through the `dataQualityInfo` element:

```xml
<mdb:MD_Metadata>
  <mdb:metadataIdentifier>...</mdb:metadataIdentifier>
  <mdb:contact>...</mdb:contact>
  <mdb:dateInfo>...</mdb:dateInfo>
  
  <!-- Quality information integration point -->
  <mdb:dataQualityInfo>
    <mdq:DQ_DataQuality>
      <mdq:scope>...</mdq:scope>
      <mdq:report>...</mdq:report>
      <mdq:lineage>...</mdq:lineage>
    </mdq:DQ_DataQuality>
  </mdb:dataQualityInfo>
  
  <mdb:resourceLineage>
    <mrl:LI_Lineage>...</mrl:LI_Lineage>
  </mdb:resourceLineage>
</mdb:MD_Metadata>
```

### Namespace Mappings

| ISO 19115-3 Namespace | Prefix | ISO 19157 Equivalent | Integration |
|----------------------|--------|---------------------|-------------|
| `mdb` (metadata base) | Metadata root | `mdq` (data quality) | `mdb:dataQualityInfo` |
| `mri` (resource identification) | Resource info | `mdq:scope` | Scope definition |
| `mrl` (resource lineage) | Lineage | `mdq:lineage` | Lineage reference |
| `mrd` (resource distribution) | Distribution | - | Quality of service |
| `cit` (citation) | Citations | `mdq:evaluationProcedure` | Procedure references |

---

## Core Element Mappings

### 1. Metadata Scope → Data Quality Scope

**ISO 19115-3 (mdb:metadataScope):**
```xml
<mdb:metadataScope>
  <mdb:MD_MetadataScope>
    <mdb:resourceScope>
      <mcc:MD_ScopeCode codeList="..." codeListValue="dataset"/>
    </mdb:resourceScope>
    <mdb:name>
      <gco:CharacterString>Complete dataset quality assessment</gco:CharacterString>
    </mdb:name>
  </mdb:MD_MetadataScope>
</mdb:metadataScope>
```

**ISO 19157-1 (mdq:scope):**
```xml
<mdq:scope>
  <mdq:DQ_Scope>
    <mdq:level>
      <mcc:MD_ScopeCode codeList="..." codeListValue="dataset"/>
    </mdq:level>
    <mdq:levelDescription>
      <mcc:MD_ScopeDescription>
        <mcc:other>
          <gco:CharacterString>Complete dataset quality assessment</gco:CharacterString>
        </mcc:other>
      </mcc:MD_ScopeDescription>
    </mdq:levelDescription>
  </mdq:DQ_Scope>
</mdq:scope>
```

**JSON Equivalent:**
```json
{
  "scope": {
    "level": "dataset",
    "levelDescription": ["Complete dataset quality assessment"]
  }
}
```

### 2. Resource Lineage → Quality Lineage

**ISO 19115-3 (mrl:LI_Lineage):**
```xml
<mdb:resourceLineage>
  <mrl:LI_Lineage>
    <mrl:statement>
      <gco:CharacterString>Dataset derived from Sentinel-2 imagery</gco:CharacterString>
    </mrl:statement>
    <mrl:processStep>
      <mrl:LE_ProcessStep>
        <mrl:description>
          <gco:CharacterString>Atmospheric correction</gco:CharacterString>
        </mrl:description>
        <mrl:dateTime>
          <gco:DateTime>2025-06-16T08:30:00Z</gco:DateTime>
        </mrl:dateTime>
      </mrl:LE_ProcessStep>
    </mrl:processStep>
  </mrl:LI_Lineage>
</mdb:resourceLineage>
```

**ISO 19157-1 (mdq:lineage reference):**
```xml
<mdq:lineage>
  <mrl:LI_Lineage>
    <mrl:statement>
      <gco:CharacterString>Dataset derived from Sentinel-2 imagery</gco:CharacterString>
    </mrl:statement>
    <mrl:processStep>
      <mrl:LE_ProcessStep>
        <mrl:description>
          <gco:CharacterString>Atmospheric correction</gco:CharacterString>
        </mrl:description>
      </mrl:LE_ProcessStep>
    </mrl:processStep>
  </mrl:LI_Lineage>
</mdq:lineage>
```

**JSON Equivalent:**
```json
{
  "lineage": {
    "statement": "Dataset derived from Sentinel-2 imagery",
    "processStep": [{
      "description": "Atmospheric correction",
      "dateTime": "2025-06-16T08:30:00Z"
    }]
  }
}
```

**Mapping Notes:**
- ISO 19115-3 lineage in `mdb:resourceLineage` is **optional**
- ISO 19157 lineage in `mdq:lineage` is **optional** but recommended
- Both use the same `mrl:LI_Lineage` type
- Can reference the same lineage content or provide quality-specific lineage

### 3. Citation → Evaluation Procedure

**ISO 19115-3 (cit:CI_Citation):**
```xml
<mdb:metadataStandard>
  <cit:CI_Citation>
    <cit:title>
      <gco:CharacterString>ISO 19115-3:2016</gco:CharacterString>
    </cit:title>
    <cit:edition>
      <gco:CharacterString>1.0</gco:CharacterString>
    </cit:edition>
  </cit:CI_Citation>
</mdb:metadataStandard>
```

**ISO 19157-1 (mdq:evaluationProcedure):**
```xml
<mdq:evaluationProcedure>
  <cit:CI_Citation>
    <cit:title>
      <gco:CharacterString>INSPIRE Positional Accuracy Test Procedure</gco:CharacterString>
    </cit:title>
    <cit:date>
      <cit:CI_Date>
        <cit:date>
          <gco:Date>2013-12-10</gco:Date>
        </cit:date>
        <cit:dateType>
          <cit:CI_DateTypeCode codeListValue="publication"/>
        </cit:dateType>
      </cit:CI_Date>
    </cit:date>
  </cit:CI_Citation>
</mdq:evaluationProcedure>
```

**JSON Equivalent:**
```json
{
  "evaluationProcedure": {
    "title": "INSPIRE Positional Accuracy Test Procedure",
    "date": [{
      "date": "2013-12-10",
      "dateType": "publication"
    }]
  }
}
```

### 4. Responsible Party → Quality Assessment Organization

**ISO 19115-3 (cit:CI_Responsibility):**
```xml
<mdb:contact>
  <cit:CI_Responsibility>
    <cit:role>
      <cit:CI_RoleCode codeListValue="pointOfContact"/>
    </cit:role>
    <cit:party>
      <cit:CI_Organisation>
        <cit:name>
          <gco:CharacterString>National Mapping Agency</gco:CharacterString>
        </cit:name>
      </cit:CI_Organisation>
    </cit:party>
  </cit:CI_Responsibility>
</mdb:contact>
```

**ISO 19157-1 (processor in processStep):**
```xml
<mrl:processor>
  <cit:CI_Responsibility>
    <cit:role>
      <cit:CI_RoleCode codeListValue="processor"/>
    </cit:role>
    <cit:party>
      <cit:CI_Organisation>
        <cit:name>
          <gco:CharacterString>Quality Assessment Team</gco:CharacterString>
        </cit:name>
      </cit:CI_Organisation>
    </cit:party>
  </cit:CI_Responsibility>
</mrl:processor>
```

---

## Quality Report Integration

### Complete Integration Example

**XML Structure:**
```xml
<mdb:MD_Metadata xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                 xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                 xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                 xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                 xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                 xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0">
  
  <!-- Metadata identification -->
  <mdb:metadataIdentifier>
    <mcc:MD_Identifier>
      <mcc:code>
        <gco:CharacterString>metadata-001</gco:CharacterString>
      </mcc:code>
    </mcc:MD_Identifier>
  </mdb:metadataIdentifier>
  
  <!-- Metadata scope -->
  <mdb:metadataScope>
    <mdb:MD_MetadataScope>
      <mdb:resourceScope>
        <mcc:MD_ScopeCode codeListValue="dataset"/>
      </mdb:resourceScope>
    </mdb:MD_MetadataScope>
  </mdb:metadataScope>
  
  <!-- DATA QUALITY INFORMATION -->
  <mdb:dataQualityInfo>
    <mdq:DQ_DataQuality>
      
      <!-- Quality scope -->
      <mdq:scope>
        <mdq:DQ_Scope>
          <mdq:level>
            <mcc:MD_ScopeCode codeListValue="dataset"/>
          </mdq:level>
        </mdq:DQ_Scope>
      </mdq:scope>
      
      <!-- Quality reports -->
      <mdq:report>
        <mdq:DQ_AbsoluteExternalPositionalAccuracy>
          <mdq:measure>
            <mdq:DQ_MeasureReference>
              <mdq:measureIdentification>
                <mcc:MD_Identifier>
                  <mcc:code>
                    <gco:CharacterString>28</gco:CharacterString>
                  </mcc:code>
                  <mcc:codeSpace>
                    <gco:CharacterString>ISO 19157</gco:CharacterString>
                  </mcc:codeSpace>
                </mcc:MD_Identifier>
              </mdq:measureIdentification>
              <mdq:nameOfMeasure>
                <gco:CharacterString>Mean value of positional uncertainties</gco:CharacterString>
              </mdq:nameOfMeasure>
            </mdq:DQ_MeasureReference>
          </mdq:measure>
          
          <mdq:evaluationMethod>
            <mdq:DQ_EvaluationMethod>
              <mdq:evaluationMethodType>
                <mdq:DQ_EvaluationMethodTypeCode codeListValue="directExternal"/>
              </mdq:evaluationMethodType>
              <mdq:evaluationMethodDescription>
                <gco:CharacterString>Ground control point comparison</gco:CharacterString>
              </mdq:evaluationMethodDescription>
              <mdq:dateTime>
                <gco:DateTime>2025-06-16T14:00:00Z</gco:DateTime>
              </mdq:dateTime>
            </mdq:DQ_EvaluationMethod>
          </mdq:evaluationMethod>
          
          <mdq:result>
            <mdq:DQ_QuantitativeResult>
              <mdq:value>
                <gco:Record>12.3</gco:Record>
              </mdq:value>
              <mdq:valueUnit xlink:href="http://www.opengis.net/def/uom/SI/metre"/>
            </mdq:DQ_QuantitativeResult>
          </mdq:result>
          
        </mdq:DQ_AbsoluteExternalPositionalAccuracy>
      </mdq:report>
      
      <!-- Lineage -->
      <mdq:lineage>
        <mrl:LI_Lineage>
          <mrl:statement>
            <gco:CharacterString>Derived from Sentinel-2 L2A imagery</gco:CharacterString>
          </mrl:statement>
          <mrl:processStep>
            <mrl:LE_ProcessStep>
              <mrl:description>
                <gco:CharacterString>Atmospheric correction using Sen2Cor</gco:CharacterString>
              </mrl:description>
              <mrl:dateTime>
                <gco:DateTime>2025-06-16T08:30:00Z</gco:DateTime>
              </mrl:dateTime>
            </mrl:LE_ProcessStep>
          </mrl:processStep>
        </mrl:LI_Lineage>
      </mdq:lineage>
      
    </mdq:DQ_DataQuality>
  </mdb:dataQualityInfo>
  
  <!-- Optional: Resource-level lineage (can duplicate or extend quality lineage) -->
  <mdb:resourceLineage>
    <mrl:LI_Lineage>
      <mrl:statement>
        <gco:CharacterString>Derived from Sentinel-2 L2A imagery</gco:CharacterString>
      </mrl:statement>
    </mrl:LI_Lineage>
  </mdb:resourceLineage>
  
</mdb:MD_Metadata>
```

**JSON Equivalent (STAC Liability Claims Extension):**
```json
{
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "liability:dataQualityInfo": [{
      "scope": {
        "level": "dataset"
      },
      "report": [{
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
          "valueUnit": "meter"
        }]
      }],
      "lineage": {
        "statement": "Derived from Sentinel-2 L2A imagery",
        "processStep": [{
          "description": "Atmospheric correction using Sen2Cor",
          "dateTime": "2025-06-16T08:30:00Z"
        }]
      }
    }]
  }
}
```

---

## Quality Element Type Mappings

### ISO 19157 Quality Elements → ISO 19115-3 Encoding

| ISO 19157 Quality Element | XML Type | ISO 19115-3 Namespace | JSON Type |
|--------------------------|----------|----------------------|-----------|
| **DQ_Completeness** | `mdq:DQ_CompletenessCommission` / `mdq:DQ_CompletenessOmission` | `mdq:` | `completeness` |
| **DQ_LogicalConsistency** | `mdq:DQ_ConceptualConsistency`, `mdq:DQ_DomainConsistency`, `mdq:DQ_FormatConsistency`, `mdq:DQ_TopologicalConsistency` | `mdq:` | `logicalConsistency` |
| **DQ_PositionalAccuracy** | `mdq:DQ_AbsoluteExternalPositionalAccuracy`, `mdq:DQ_RelativeInternalPositionalAccuracy`, `mdq:DQ_GriddedDataPositionalAccuracy` | `mdq:` | `positionalAccuracy` |
| **DQ_ThematicQuality** | `mdq:DQ_ThematicClassificationCorrectness`, `mdq:DQ_NonQuantitativeAttributeCorrectness`, `mdq:DQ_QuantitativeAttributeAccuracy` | `mdq:` | `thematicQuality` |
| **DQ_TemporalQuality** | `mdq:DQ_AccuracyOfATimeMeasurement`, `mdq:DQ_TemporalConsistency`, `mdq:DQ_TemporalValidity` | `mdq:` | `temporalQuality` |
| **DQ_Usability** | `mdq:DQ_Usability` | `mdq:` | `usability` |
| **DQ_Metaquality** | `mdq:DQ_Confidence`, `mdq:DQ_Representativity`, `mdq:DQ_Homogeneity` | `mdq:` | `metaquality` |

### Result Type Encodings

| ISO 19157 Result Type | XML Type | ISO 19115-3 Elements | JSON Type |
|----------------------|----------|---------------------|-----------|
| **Quantitative Result** | `mdq:DQ_QuantitativeResult` | `mdq:value`, `mdq:valueUnit`, `mdq:valueRecordType` | `quantitative` |
| **Conformance Result** | `mdq:DQ_ConformanceResult` | `mdq:specification`, `mdq:pass`, `mdq:explanation` | `conformance` |
| **Descriptive Result** | `mdq:DQ_DescriptiveResult` | `mdq:statement` | `descriptive` |
| **Coverage Result** | `mdq:DQ_CoverageResult` | `mdq:spatialRepresentationType`, `mdq:resultFile` | `coverage` |

---

## Code List Alignments

### Scope Codes (mcc:MD_ScopeCode)

Used in both ISO 19115-3 (`mdb:metadataScope`) and ISO 19157 (`mdq:scope`):

| Code Value | Description | Use in Metadata | Use in Quality |
|------------|-------------|-----------------|----------------|
| `attribute` | Information applies to the attribute class | Resource attribute scope | Quality of specific attributes |
| `attributeType` | Information applies to the characteristic of a feature | Attribute type scope | Quality of attribute types |
| `dataset` | Information applies to the dataset | Complete dataset metadata | Dataset-level quality |
| `series` | Information applies to the series | Series metadata | Series-level quality |
| `feature` | Information applies to a feature | Feature instance | Feature-level quality |
| `featureType` | Information applies to a feature type | Feature type catalog | Quality of feature types |
| `model` | Information applies to a model | Model metadata | Model quality |
| `tile` | Information applies to a tile | Tile metadata | Tile-level quality |
| `collection` | Information applies to a collection | Collection metadata | Collection quality |

### Date Type Codes (cit:CI_DateTypeCode)

Used in citations for both metadata and quality procedures:

| Code Value | Metadata Use | Quality Use |
|------------|-------------|-------------|
| `creation` | Dataset creation date | Quality assessment date |
| `publication` | Metadata publication | Procedure publication |
| `revision` | Metadata revision | Quality re-assessment |
| `validityBegins` | Metadata validity start | Quality report validity |
| `validityExpires` | Metadata validity end | Quality report expiry |

### Role Codes (cit:CI_RoleCode)

Used for responsible parties in both contexts:

| Code Value | Metadata Use | Quality Use |
|------------|-------------|-------------|
| `author` | Metadata author | Quality report author |
| `originator` | Data originator | Quality assessor |
| `processor` | Data processor | Quality processor |
| `publisher` | Metadata publisher | Quality report publisher |
| `pointOfContact` | Metadata contact | Quality contact |
| `principalInvestigator` | Dataset PI | Quality assessment PI |

---

## Best Practices for Integration

### 1. Dual Lineage Approach

**Recommended:** Use quality-specific lineage in `mdq:lineage` and resource lineage in `mdb:resourceLineage`:

```xml
<!-- Quality-specific lineage: focus on quality assessment process -->
<mdb:dataQualityInfo>
  <mdq:DQ_DataQuality>
    <mdq:lineage>
      <mrl:LI_Lineage>
        <mrl:statement>
          <gco:CharacterString>Quality assessed using 50 ground control points</gco:CharacterString>
        </mrl:statement>
        <mrl:processStep>
          <mrl:LE_ProcessStep>
            <mrl:description>
              <gco:CharacterString>RMSE calculation from GCP residuals</gco:CharacterString>
            </mrl:description>
          </mrl:LE_ProcessStep>
        </mrl:processStep>
      </mrl:LI_Lineage>
    </mdq:lineage>
  </mdq:DQ_DataQuality>
</mdb:dataQualityInfo>

<!-- Resource lineage: focus on data production process -->
<mdb:resourceLineage>
  <mrl:LI_Lineage>
    <mrl:statement>
      <gco:CharacterString>Derived from Sentinel-2 L2A atmospheric correction</gco:CharacterString>
    </mrl:statement>
    <mrl:processStep>
      <mrl:LE_ProcessStep>
        <mrl:description>
          <gco:CharacterString>Sen2Cor v2.10 atmospheric correction</gco:CharacterString>
        </mrl:description>
      </mrl:LE_ProcessStep>
    </mrl:processStep>
  </mrl:LI_Lineage>
</mdb:resourceLineage>
```

### 2. Multiple Quality Reports

Include multiple `mdq:report` elements for different quality dimensions:

```xml
<mdb:dataQualityInfo>
  <mdq:DQ_DataQuality>
    <mdq:scope>...</mdq:scope>
    
    <!-- Positional accuracy report -->
    <mdq:report>
      <mdq:DQ_AbsoluteExternalPositionalAccuracy>
        ...
      </mdq:DQ_AbsoluteExternalPositionalAccuracy>
    </mdq:report>
    
    <!-- Thematic quality report -->
    <mdq:report>
      <mdq:DQ_ThematicClassificationCorrectness>
        ...
      </mdq:DQ_ThematicClassificationCorrectness>
    </mdq:report>
    
    <!-- Completeness report -->
    <mdq:report>
      <mdq:DQ_CompletenessOmission>
        ...
      </mdq:DQ_CompletenessOmission>
    </mdq:report>
    
    <mdq:lineage>...</mdq:lineage>
  </mdq:DQ_DataQuality>
</mdb:dataQualityInfo>
```

### 3. Scope Consistency

Ensure `mdb:metadataScope` aligns with `mdq:scope`:

```xml
<!-- Metadata scope -->
<mdb:metadataScope>
  <mdb:MD_MetadataScope>
    <mdb:resourceScope>
      <mcc:MD_ScopeCode codeListValue="dataset"/>
    </mdb:resourceScope>
  </mdb:MD_MetadataScope>
</mdb:metadataScope>

<!-- Quality scope (should match) -->
<mdb:dataQualityInfo>
  <mdq:DQ_DataQuality>
    <mdq:scope>
      <mdq:DQ_Scope>
        <mdq:level>
          <mcc:MD_ScopeCode codeListValue="dataset"/>
        </mdq:level>
      </mdq:DQ_Scope>
    </mdq:scope>
  </mdq:DQ_DataQuality>
</mdb:dataQualityInfo>
```

---

## JSON Schema Integration

### Combining ISO 19115-3 and ISO 19157 in JSON

**Complete STAC Item Example:**
```json
{
  "stac_version": "1.0.0",
  "type": "Feature",
  "id": "metadata-quality-integration-example",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "properties": {
    "datetime": "2025-06-16T10:30:00Z",
    
    "_comment": "ISO 19115-3 metadata elements",
    "title": "Sentinel-2 L2A Surface Reflectance",
    "description": "Atmospherically corrected surface reflectance product",
    "platform": "Sentinel-2A",
    "instruments": ["MSI"],
    
    "_comment": "ISO 19157 data quality information",
    "liability:dataQualityInfo": [{
      "scope": {
        "level": "dataset",
        "extent": {
          "geographicExtent": [{
            "westBoundLongitude": 11.0,
            "eastBoundLongitude": 12.0,
            "southBoundLatitude": 45.0,
            "northBoundLatitude": 46.0
          }],
          "temporalExtent": [{
            "extent": {
              "begin": "2025-06-16T10:25:00Z",
              "end": "2025-06-16T10:35:00Z"
            }
          }]
        }
      },
      "report": [{
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
          "evaluationMethodDescription": "Ground control point comparison using RMSE",
          "dateTime": "2025-06-16T14:00:00Z",
          "evaluationProcedure": {
            "title": "Sentinel-2 Geometric Quality Procedure",
            "date": [{
              "date": "2024-01-15T00:00:00Z",
              "dateType": "publication"
            }]
          }
        },
        "result": [{
          "resultType": "quantitative",
          "value": [12.3],
          "valueUnit": "meter",
          "valueRecordType": "Real",
          "errorStatistic": "RMSE"
        }]
      }],
      "lineage": {
        "statement": "Sentinel-2 L2A product generated from L1C using Sen2Cor atmospheric correction",
        "processStep": [{
          "description": "Atmospheric correction to surface reflectance",
          "rationale": "Convert TOA reflectance to BOA surface reflectance",
          "dateTime": "2025-06-16T08:30:00Z",
          "processor": [{
            "role": "processor",
            "party": [{
              "name": "ESA Copernicus Ground Segment",
              "contactInfo": {
                "onlineResource": [{
                  "linkage": "https://scihub.copernicus.eu",
                  "name": "Copernicus Open Access Hub"
                }]
              }
            }]
          }],
          "processingInformation": {
            "identifier": "Sen2Cor v2.10",
            "softwareReference": {
              "title": "Sen2Cor Atmospheric Correction Processor",
              "edition": "2.10"
            }
          }
        }]
      }
    }],
    
    "_comment": "Responsible party (ISO 19115-3 cit:CI_Responsibility)",
    "liability:responsible_party": {
      "name": "European Space Agency",
      "organization": "ESA Copernicus Programme",
      "role": "originator",
      "email": "copernicus@esa.int"
    }
  }
}
```

---

## Transformation Guidelines

### XML → JSON Conversion Rules

| XML Pattern | JSON Pattern | Notes |
|------------|-------------|-------|
| `<gco:CharacterString>value</gco:CharacterString>` | `"value"` | String unwrapping |
| `<gco:DateTime>2025-01-01T00:00:00Z</gco:DateTime>` | `"2025-01-01T00:00:00Z"` | ISO 8601 string |
| `<gco:Record>12.3</gco:Record>` | `[12.3]` | Array for quantitative values |
| `<mdq:value><gco:Record>12.3</gco:Record></mdq:value>` | `"value": [12.3]` | Numeric array |
| `<mcc:MD_ScopeCode codeListValue="dataset"/>` | `"dataset"` | Code value extraction |
| `xlink:href="http://..."` | `"href": "http://..."` | URI reference |

### JSON → XML Conversion Rules

| JSON Pattern | XML Pattern | Notes |
|-------------|------------|-------|
| `"value"` | `<gco:CharacterString>value</gco:CharacterString>` | String wrapping |
| `[12.3]` | `<mdq:value><gco:Record>12.3</gco:Record></mdq:value>` | Record wrapping |
| `"dataset"` | `<mcc:MD_ScopeCode codeListValue="dataset"/>` | Code list reference |
| `"2025-01-01T00:00:00Z"` | `<gco:DateTime>2025-01-01T00:00:00Z</gco:DateTime>` | DateTime wrapping |

---

## Validation and Conformance

### XML Schema Validation

**ISO 19115-3 Schemas:**
```
http://standards.iso.org/iso/19115/-3/mdb/2.0/mdb.xsd (Metadata base)
http://standards.iso.org/iso/19115/-3/mri/1.0/mri.xsd (Resource identification)
http://standards.iso.org/iso/19115/-3/mrl/2.0/mrl.xsd (Resource lineage)
```

**ISO 19157 Schemas:**
```
http://standards.iso.org/iso/19157/-2/mdq/1.0/mdq.xsd (Data quality)
http://standards.iso.org/iso/19157/-2/dqc/1.0/dqc.xsd (Quality common)
```

### JSON Schema Validation

**Liability Claims Extension Schemas:**
```json
{
  "$ref": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json",
  "$ref": "https://stac-extensions.github.io/liability-claims/iso19157-quality.json",
  "$ref": "https://stac-extensions.github.io/liability-claims/iso19157-lineage.json",
  "$ref": "https://stac-extensions.github.io/liability-claims/iso19157-scope.json"
}
```

---

## Migration Strategies

### From ISO 19115-3 XML to STAC JSON

**Step 1: Extract Metadata Elements**
```python
import xml.etree.ElementTree as ET

# Parse ISO 19115-3 XML
tree = ET.parse('metadata.xml')
root = tree.getroot()

# Extract basic metadata
ns = {'mdb': 'http://standards.iso.org/iso/19115/-3/mdb/2.0'}
title = root.find('.//mri:title/gco:CharacterString', ns).text
```

**Step 2: Transform Quality Information**
```python
# Extract data quality info
dq_elements = root.findall('.//mdq:DQ_DataQuality', ns)

quality_reports = []
for dq in dq_elements:
    scope = dq.find('.//mdq:scope/mdq:DQ_Scope/mdq:level', ns).get('codeListValue')
    # ... transform to JSON
```

**Step 3: Generate STAC Item**
```python
stac_item = {
    "type": "Feature",
    "stac_extensions": [
        "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
    ],
    "properties": {
        "title": title,
        "liability:dataQualityInfo": quality_reports
    }
}
```

### From STAC JSON to ISO 19115-3 XML

Use XSLT or programmatic transformation libraries like `lxml` (Python) or `xmlbuilder` (JavaScript).

---

## Summary Table: ISO 19115-3 ↔ ISO 19157 Element Correspondence

| Concept | ISO 19115-3 Element | ISO 19157 Element | Relationship |
|---------|-------------------|------------------|--------------|
| **Quality Container** | `mdb:dataQualityInfo` | `mdq:DQ_DataQuality` | Container |
| **Scope** | `mdb:metadataScope` | `mdq:scope` | Parallel/aligned |
| **Lineage** | `mdb:resourceLineage` | `mdq:lineage` | Shared type (`mrl:LI_Lineage`) |
| **Citation** | `cit:CI_Citation` | `mdq:evaluationProcedure` | Reused type |
| **Responsibility** | `cit:CI_Responsibility` | `mrl:processor` | Reused type |
| **Extent** | `mdb:spatialRepresentationInfo` | `mdq:scope/mdq:extent` | Geographic extent |
| **Date** | `mdb:dateInfo` | `mdq:evaluationMethod/mdq:dateTime` | Temporal reference |

---

## Related Documentation

- [ISO19157-INTEGRATION.md](ISO19157-INTEGRATION.md) - Complete ISO 19157 integration guide
- [ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md](ISO19115-4-vs-ISO19157-3-COMPATIBILITY.md) - Imagery-specific mapping
- [DQV-ISO19157-MAPPING.md](DQV-ISO19157-MAPPING.md) - W3C DQV semantic lifting
- [json-schema/iso19157-quality.json](json-schema/iso19157-quality.json) - ISO 19157 JSON Schema
- [json-schema/iso19157-lineage.json](json-schema/iso19157-lineage.json) - Lineage JSON Schema
- [json-schema/iso19157-scope.json](json-schema/iso19157-scope.json) - Scope JSON Schema

## Standards References

- **ISO 19115-1:2014** - Geographic information - Metadata - Part 1: Fundamentals
- **ISO 19115-3:2016** - Geographic information - Metadata - Part 3: XML schema implementation
- **ISO 19157-1:2023** - Geographic information - Data quality - Part 1: General requirements
- **ISO 19157-3:2026** - Geographic information - Data quality - Part 3: Measures register (expected)

## Contact

For questions about ISO 19115-3 / ISO 19157 integration:
- Email: luciocol@gmail.com
- GitHub Issues: https://github.com/stac-extensions/liability-claims/issues

---

**Version**: 1.0  
**Date**: 2026-01-22  
**Author**: luciocol@gmail.com
