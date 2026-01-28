# OGC TrainingDML-AI Compatibility Assessment

## Executive Summary

**Compatibility Rating: 4/5 (High Compatibility)**

The STAC Extension for Liability Claims with ISO 19115 data quality support demonstrates **high compatibility** with OGC TrainingDML-AI Part 1 (23-008r3), particularly for geospatial ML training data quality and provenance metadata. The extension can effectively support TrainingDML-AI use cases through its comprehensive quality reporting framework.

**Key Findings:**
- ✅ Direct alignment through shared ISO 19115/19157 foundation
- ✅ Quality metadata structures map to TrainingDML-AI AI_DataQuality module
- ✅ Provenance and lineage support compatible with AI_Labeling requirements
- ⚠️ Training dataset organization requires additional STAC collection-level metadata
- ⚠️ ML-specific label semantics (AI_Label) require custom fields

---

## 1. TrainingDML-AI Overview

**Standard:** OGC Training Data Markup Language for Artificial Intelligence (TrainingDML-AI) Part 1: Conceptual Model Standard v1.0 (2023-09-19)

**Purpose:** Defines UML model and metadata structures for geospatial machine learning training data, including:
- Training dataset organization (AI_TrainingDataset, AI_TrainingData)
- ML task specifications (AI_Task, AI_EOTask)
- Label semantics (AI_Label: scene/object/pixel level)
- **Provenance metadata** (AI_Labeling, AI_Labeler, AI_LabelingProcedure)
- **Data quality** (AI_DataQuality extending ISO 19157 QualityElement)
- Version control (AI_TDChangeset)

**Target Domain:** Earth Observation AI/ML applications, particularly:
- Scene classification (e.g., land use/land cover)
- Object detection (e.g., building/vehicle detection)
- Semantic segmentation (e.g., pixel-level classification)
- Change detection (e.g., flood mapping, urban growth)
- 3D reconstruction from multi-view imagery

**Core Dependencies:**
- ISO 19115-1:2014 (Geographic information — Metadata)
- ISO 19157-1 (Geographic information — Data quality)
- ISO 19107:2019 (Geographic information — Spatial schema)
- ISO 19103:2015 (Geographic information — Conceptual schema language)

---

## 2. Compatibility Analysis

### 2.1 Quality Metadata Alignment (★★★★★ Excellent)

**TrainingDML-AI Section 7.9 AI_DataQuality:**

The standard explicitly states:
> "TD quality description can use DataQuality from ISO 19157-1 to align with the existing efforts on geographic data quality. Data quality can be evaluated in terms of either collection or individual levels of the TD."

**Direct Mapping to STAC Extension:**

| TrainingDML-AI Concept | STAC Extension Equivalent | Compatibility |
|------------------------|---------------------------|---------------|
| `AI_DataQuality` extends `QualityElement` (ISO 19157) | `liability:quality` field with ISO 19115 quality reports | ✅ **Perfect** |
| Quality scope: dataset/feature level | `liability:quality` applicable to Items/Collections | ✅ **Perfect** |
| `AI_ClassBalanceDegree` quality element | Can be represented as ISO 19115 `completeness` or custom measure | ✅ **Compatible** |
| `Completeness` (label commission/omission) | `iso19115_completeness` with commission/omission | ✅ **Perfect** |
| `Thematic accuracy` (class accuracy) | `iso19115_thematic_accuracy` with classification correctness | ✅ **Perfect** |
| Positional uncertainty in field GPS | `iso19115_positional_accuracy` with absolute/relative accuracy | ✅ **Perfect** |

**Example Use Case:** ML training dataset for building detection
```json
{
  "type": "Feature",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "properties": {
    "liability:quality": [
      {
        "elementType": "completeness",
        "detail": {
          "type": "commission",
          "measure": "Commission Rate",
          "value": 0.023,
          "unit": "percentage",
          "evaluationMethod": "Manual inspection of 500 random samples",
          "dateTime": "2024-01-15T10:30:00Z"
        },
        "comment": "Building label commission - falsely labeled non-buildings"
      },
      {
        "elementType": "thematic_accuracy",
        "detail": {
          "classificationCorrectness": 0.947,
          "numberOfClasses": 2,
          "measure": "Overall Accuracy",
          "evaluationMethod": "Confusion matrix from 1000 test samples",
          "dateTime": "2024-01-15T10:30:00Z"
        },
        "comment": "Building vs. non-building classification accuracy"
      }
    ]
  }
}
```

### 2.2 Provenance and Lineage Support (★★★★☆ Very Good)

**TrainingDML-AI Section 7.7 AI_Labeling:**

The standard defines:
> "AI_Labeling can be associated with AI_AbstractTrainingDataset or AI_AbstractTrainingData to record basic provenance information on how the training dataset or training samples are created."

**Mapping to STAC Extension:**

| TrainingDML-AI Provenance | STAC Extension Capability | Compatibility |
|---------------------------|---------------------------|---------------|
| `AI_Labeling` (provenance record) | ISO 19115 `lineage` field in quality reports | ✅ **Compatible** |
| `AI_Labeler` (agent/person) | Captured in `evaluationMethod` or `lineage.statement` | ⚠️ **Partial** |
| `AI_LabelingProcedure` (methods/tools) | Captured in `evaluationMethod` description | ✅ **Compatible** |
| W3C PROV alignment | Not directly supported, but ISO lineage provides similar semantics | ⚠️ **Partial** |

**Example:** Labeling procedure for semantic segmentation
```json
{
  "liability:quality": [{
    "elementType": "completeness",
    "detail": {
      "type": "commission",
      "measure": "Labeling Quality",
      "evaluationMethod": "Manual labeling using QGIS 3.28 by 3 trained annotators. Inter-annotator agreement (Cohen's kappa): 0.87. Quality assurance: Senior analyst review of 10% random sample.",
      "lineage": {
        "statement": "Training samples created from WorldView-3 imagery (0.3m resolution, acquired 2023-06-15). Atmospheric correction applied using Sen2Cor v2.9. Labeling performed 2023-07-01 to 2023-07-30 following DGIWG Feature Data Dictionary v2.2 for land cover classes."
      }
    }
  }]
}
```

**Limitation:** TrainingDML-AI's structured `AI_Labeler` (id, name) and `AI_LabelingProcedure` (methods, tools as separate fields) are more granular than ISO 19115 lineage. STAC extension users can embed this in text fields but lose machine-readable structure.

### 2.3 Training Dataset Organization (★★★☆☆ Moderate)

**TrainingDML-AI Section 7.3 AI_TrainingDataset:**

Key attributes:
- `amountOfTrainingData` (total samples count)
- `numberOfClasses` (total classes)
- `classes` (semantic class list, e.g., "building", "road", "vegetation")
- `statisticsInfo` (samples per class distribution)
- `classificationSchema` (external ontology reference)
- `metricsInLiterature` (published model performance on dataset)

**STAC Extension Support:**

| TrainingDML-AI Attribute | STAC Equivalent | Compatibility |
|--------------------------|-----------------|---------------|
| `amountOfTrainingData` | Not directly supported | ❌ **Missing** |
| `numberOfClasses` | Not directly supported | ❌ **Missing** |
| `classes` | Not directly supported | ❌ **Missing** |
| `statisticsInfo` | Could use STAC Collection `summaries` | ⚠️ **Workaround** |
| `classificationSchema` | Not directly supported | ❌ **Missing** |
| Quality association (`dataQuality`) | `liability:quality` at Collection level | ✅ **Compatible** |

**Recommendation:** Extend STAC Collection metadata for ML training datasets:
```json
{
  "type": "Collection",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "ml:training_dataset": {
    "amount_of_training_data": 15000,
    "number_of_classes": 5,
    "classes": [
      {"id": "building", "name": "Building", "count": 4500},
      {"id": "road", "name": "Road Network", "count": 3200},
      {"id": "vegetation", "name": "Vegetation", "count": 2800},
      {"id": "water", "name": "Water Bodies", "count": 2200},
      {"id": "bare_soil", "name": "Bare Soil", "count": 2300}
    ],
    "classification_schema": "https://example.org/ontologies/land-cover-v1.0"
  },
  "liability:quality": [{
    "elementType": "completeness",
    "detail": {
      "scope": "collection",
      "measure": "Class Balance Degree",
      "value": 0.78,
      "evaluationMethod": "Gini coefficient across 5 classes"
    }
  }]
}
```

### 2.4 ML Task Specification (★★☆☆☆ Limited)

**TrainingDML-AI Section 7.5 AI_Task:**

`AI_EOTask` specifies ML task types:
- Scene classification
- Object detection (with bounding box types)
- Semantic segmentation
- Change detection
- 3D model reconstruction

**STAC Extension Support:**

The extension does NOT provide specific fields for ML task specification. This would require:
- Custom STAC extension or ML-specific metadata fields
- External reference to TrainingDML-AI JSON encoding

**Compatibility:** ❌ **Not Supported** (out of scope for liability/quality extension)

### 2.5 Label Semantics (★★☆☆☆ Limited)

**TrainingDML-AI Section 7.6 AI_Label:**

Defines three label types:
- `AI_SceneLabel` (semantic class for entire image)
- `AI_ObjectLabel` (feature/geometry with class)
- `AI_PixelLabel` (coverage/raster with class values)

**STAC Extension Support:**

The extension focuses on **quality metadata about labels**, not the labels themselves. STAC Items typically reference label assets (e.g., GeoJSON, GeoTIFF masks), but structured label semantics require additional extensions.

**Compatibility:** ⚠️ **Indirect** - Labels referenced as STAC assets, quality of labels described via `liability:quality`

### 2.6 ISO Standards Foundation (★★★★★ Excellent)

**Shared Dependencies:**

Both TrainingDML-AI and the STAC extension build on:
- **ISO 19115-1:2014** - Core metadata standard
- **ISO 19157-1** - Data quality framework
- **ISO 19107** - Spatial schema (geometries)

**TrainingDML-AI Section 3 Normative References explicitly includes:**
> "ISO: ISO 19115-1:2014, Geographic information — Metadata — Part 1: Fundamentals"
> "ISO: ISO 19157-1, Geographic information — Data quality — Part 1: General requirements"

This **shared foundation ensures semantic alignment** at the conceptual level, even where implementation details differ.

---

## 3. Use Case Scenarios

### 3.1 Use Case: Building Damage Assessment Training Data

**Scenario:** Create training dataset for ML model to detect damaged buildings from satellite imagery after natural disasters.

**TrainingDML-AI Requirements:**
- Dataset metadata: 25,000 labeled images, 3 classes (undamaged, minor damage, major damage)
- Quality: Inter-annotator agreement, positional accuracy of building footprints
- Provenance: Labeling performed by disaster response experts using VGG Image Annotator
- Task: Object detection with oriented bounding boxes

**STAC Extension Implementation:**

**Collection (dataset level):**
```json
{
  "type": "Collection",
  "id": "building-damage-training-v1",
  "title": "Post-Disaster Building Damage Assessment Training Dataset",
  "description": "Training data for ML-based building damage classification from VHR satellite imagery",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "extent": {
    "spatial": {"bbox": [[-180, -90, 180, 90]]},
    "temporal": {"interval": [["2020-01-01T00:00:00Z", "2023-12-31T23:59:59Z"]]}
  },
  "summaries": {
    "ml:classes": ["undamaged", "minor_damage", "major_damage"],
    "ml:sample_count": 25000,
    "gsd": [0.3, 0.5]
  },
  "liability:quality": [
    {
      "elementType": "thematic_accuracy",
      "detail": {
        "classificationCorrectness": 0.89,
        "numberOfClasses": 3,
        "measure": "Multi-class F1 Score",
        "evaluationMethod": "3-fold cross-validation on 2000 held-out samples. Cohen's kappa for inter-annotator agreement: 0.82 (substantial agreement) across 5 expert annotators.",
        "dateTime": "2024-01-20T00:00:00Z"
      },
      "comment": "Quality validated against field surveys for 500 buildings"
    },
    {
      "elementType": "positional_accuracy",
      "detail": {
        "absoluteExternalPositionalAccuracy": 2.5,
        "unit": "meters",
        "measure": "RMSE of building centroid positions",
        "evaluationMethod": "Comparison against LiDAR-derived reference data (0.1m accuracy)",
        "dateTime": "2024-01-20T00:00:00Z",
        "lineage": {
          "statement": "Building footprints digitized from WorldView-3 imagery (0.3m GSD) and Pléiades imagery (0.5m GSD). Orthorectification performed using 10m DEM. Labeling tool: VGG Image Annotator v2.0.11. Annotators: 5 disaster response experts with >5 years experience in damage assessment (training provided following FEMA P-154 guidelines)."
        }
      }
    }
  ]
}
```

**Item (individual training sample):**
```json
{
  "type": "Feature",
  "stac_version": "1.0.0",
  "id": "damaged-building-sample-00042",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "geometry": {
    "type": "Polygon",
    "coordinates": [[[...]]]
  },
  "properties": {
    "datetime": "2023-09-15T10:30:00Z",
    "gsd": 0.3,
    "platform": "WorldView-3",
    "liability:quality": [{
      "elementType": "positional_accuracy",
      "detail": {
        "absoluteExternalPositionalAccuracy": 1.8,
        "unit": "meters",
        "measure": "GPS-measured corner point accuracy",
        "evaluationMethod": "RTK-GPS survey (horizontal accuracy <0.5m)",
        "dateTime": "2023-09-16T08:00:00Z"
      },
      "comment": "Field-verified sample with ground truth from post-disaster building inspection"
    }]
  },
  "assets": {
    "image": {
      "href": "https://example.org/samples/00042.tif",
      "type": "image/tiff; application=geotiff",
      "roles": ["data"]
    },
    "labels": {
      "href": "https://example.org/samples/00042_labels.geojson",
      "type": "application/geo+json",
      "roles": ["labels"],
      "label:properties": ["damage_class"],
      "label:classes": [
        {"name": "undamaged", "classes": ["undamaged"]},
        {"name": "minor_damage", "classes": ["minor_damage"]},
        {"name": "major_damage", "classes": ["major_damage"]}
      ],
      "label:type": "vector",
      "label:task": "detection"
    }
  }
}
```

**Compatibility Score: 4/5**
- ✅ Quality metadata fully supported
- ✅ Provenance captured in lineage
- ⚠️ ML task/class metadata requires custom fields or label extension
- ⚠️ Structured labeler info embedded in text

---

### 3.2 Use Case: Land Cover Classification Quality Report

**Scenario:** Document quality of training data for semantic segmentation of land cover classes.

**TrainingDML-AI Quality Elements:**
- `AI_ClassBalanceDegree` - measure class imbalance
- `Completeness` - mislabeled pixels
- `Thematic accuracy` - pixel-level classification correctness

**STAC Extension Implementation:**
```json
{
  "type": "Feature",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "properties": {
    "liability:quality": [
      {
        "elementType": "completeness",
        "detail": {
          "type": "commission",
          "measure": "Pixel Mislabeling Rate",
          "value": 0.034,
          "unit": "ratio",
          "evaluationMethod": "Manual inspection of 50 randomly selected patches (512x512 pixels each). Independent labeling by 2 experts, discrepancies resolved by third expert.",
          "dateTime": "2024-02-01T00:00:00Z"
        },
        "comment": "Commission errors primarily at class boundaries (mixed pixels)"
      },
      {
        "elementType": "thematic_accuracy",
        "detail": {
          "classificationCorrectness": 0.912,
          "numberOfClasses": 7,
          "measure": "Mean Intersection over Union (mIoU)",
          "confusionMatrix": [
            [0.95, 0.02, 0.01, 0.01, 0.01, 0.00, 0.00],
            [0.03, 0.88, 0.04, 0.02, 0.02, 0.01, 0.00],
            [0.01, 0.03, 0.91, 0.02, 0.02, 0.01, 0.00],
            [...]
          ],
          "evaluationMethod": "1000 validation patches with expert-verified labels",
          "dateTime": "2024-02-01T00:00:00Z"
        },
        "comment": "Classes: water, forest, grassland, cropland, urban, bare soil, wetland"
      },
      {
        "elementType": "completeness",
        "detail": {
          "measure": "Class Balance Coefficient",
          "value": 0.72,
          "unit": "normalized entropy",
          "evaluationMethod": "Shannon entropy normalized by maximum entropy. Value of 1.0 indicates perfect balance. Calculated across 7 land cover classes with sample sizes: water=3200, forest=5100, grassland=4800, cropland=5500, urban=2100, bare_soil=1800, wetland=2500.",
          "dateTime": "2024-02-01T00:00:00Z"
        },
        "comment": "Moderate imbalance - urban and bare soil underrepresented"
      }
    ]
  }
}
```

**Compatibility Score: 5/5**
- ✅ All TrainingDML-AI quality measures supported
- ✅ `AI_ClassBalanceDegree` represented as completeness measure
- ✅ Confusion matrix embedded in thematic accuracy
- ✅ Full provenance via evaluation method

---

## 4. Compatibility Matrix

| TrainingDML-AI Module | STAC Extension Support | Rating | Notes |
|-----------------------|------------------------|--------|-------|
| **AI_DataQuality** | Direct via `liability:quality` | ⭐⭐⭐⭐⭐ | Perfect alignment through ISO 19157 |
| **AI_Labeling (Provenance)** | Via ISO 19115 lineage | ⭐⭐⭐⭐ | Text-based capture of methods/tools |
| **AI_TrainingDataset** | Partial via STAC Collection | ⭐⭐⭐ | Requires custom fields for ML metadata |
| **AI_TrainingData** | Via STAC Items | ⭐⭐⭐⭐ | Good support with asset references |
| **AI_Task** | Not supported | ⭐⭐ | Out of scope, needs ML extension |
| **AI_Label** | Asset references only | ⭐⭐⭐ | Labels as assets, not structured semantics |
| **AI_TDChangeset** | Not supported | ⭐ | Out of scope |

**Overall Compatibility: 4/5 (High Compatibility)**

---

## 5. Recommendations

### 5.1 For STAC Extension Users

**When using this extension for ML training data:**

1. **✅ Leverage quality metadata extensively:**
   - Use `completeness` for label commission/omission
   - Use `thematic_accuracy` for classification correctness
   - Use `positional_accuracy` for geometric label quality
   - Document class balance using custom measures

2. **✅ Embed provenance in evaluation methods:**
   - Include labeler qualifications
   - Specify labeling tools and versions
   - Document labeling procedures and guidelines
   - Cite external standards (e.g., DGIWG, FEMA)

3. **⚠️ Combine with STAC Label Extension:**
   - Use [STAC Label Extension](https://github.com/stac-extensions/label) for label-specific metadata
   - Reference label assets (GeoJSON, GeoTIFF masks)
   - Define label classes and task types

4. **⚠️ Extend STAC Collections for datasets:**
   - Add custom fields for ML metadata (classes, sample counts)
   - Use `summaries` for dataset-level statistics
   - Consider creating dedicated ML training dataset extension

### 5.2 For TrainingDML-AI Implementers

**When integrating with STAC ecosystem:**

1. **✅ Map quality modules to STAC extension:**
   - Export `AI_DataQuality` as `liability:quality` reports
   - Preserve ISO 19115/19157 structure for interoperability

2. **✅ Use STAC Collections for datasets:**
   - Map `AI_TrainingDataset` to STAC Collections
   - Map `AI_TrainingData` to STAC Items
   - Use STAC relationships (links) for dataset organization

3. **⚠️ Publish dual encodings:**
   - Provide TrainingDML-AI JSON alongside STAC metadata
   - Link between TrainingDML-AI datasets and STAC catalogs
   - Cross-reference using DOIs/identifiers

### 5.3 For Standards Harmonization

**Recommendations for future work:**

1. **Create STAC ML Training Extension:**
   - Formalize mapping between TrainingDML-AI and STAC
   - Define standard fields for task, classes, metrics
   - Coordinate with TrainingDML-AI JSON encoding (OGC 24-006r1)

2. **Enhance Quality Reporting:**
   - Add ML-specific quality measures to ISO 19157
   - Define standard confusion matrix representation
   - Standardize class balance metrics

3. **Improve Provenance Interoperability:**
   - Map between W3C PROV (used in TrainingDML-AI) and ISO lineage
   - Create structured labeler/procedure fields
   - Support machine-readable provenance chains

---

## 6. Conclusion

The STAC Extension for Liability Claims with ISO 19115 quality support provides **strong compatibility** with OGC TrainingDML-AI for **quality and provenance metadata** in geospatial ML training data. The shared ISO 19115/19157 foundation ensures semantic alignment and interoperability.

**Strengths:**
- ✅ **Comprehensive quality reporting** covering completeness, thematic accuracy, positional accuracy
- ✅ **Provenance capture** through ISO lineage statements
- ✅ **Standards-based** approach ensures long-term interoperability
- ✅ **Flexible structure** supports collection and item-level quality

**Limitations:**
- ⚠️ **ML-specific metadata** (tasks, classes, sample counts) requires custom fields
- ⚠️ **Structured provenance** (labeler, procedure) embedded in text fields
- ⚠️ **Label semantics** require additional STAC extensions

**Primary Use Cases:**
- ✅ Quality reporting for ML training datasets
- ✅ Documenting labeling provenance and procedures
- ✅ Dataset quality validation and certification
- ✅ Compliance with data quality standards (ISO, DGIWG)

**Rating: 4/5 - Recommended for geospatial ML training data quality metadata**

---

## References

1. **OGC TrainingDML-AI Part 1: Conceptual Model Standard v1.0**  
   Document: OGC 23-008r3 (2023-09-19)  
   URL: https://docs.ogc.org/is/23-008r3/23-008r3.html

2. **OGC TrainingDML-AI Part 2: JSON Encoding v1.0**  
   Document: OGC 24-006r1 (expected 2024)  
   URL: https://www.ogc.org/standards/trainingdml-ai/

3. **ISO 19115-1:2014 - Geographic information — Metadata — Part 1: Fundamentals**  
   URL: https://www.iso.org/standard/53798.html

4. **ISO 19157-1 - Geographic information — Data quality — Part 1: General requirements**  
   URL: https://www.iso.org/standard/78900.html

5. **STAC Label Extension**  
   URL: https://github.com/stac-extensions/label

6. **NASA UMM Compatibility Assessment** (this repository)  
   Document: UMM-COMPATIBILITY.md

---

**Document Version:** 1.0  
**Date:** 2024-12-19  
**Author:** GitHub Copilot (Claude Sonnet 4.5)  
**Repository:** https://github.com/luciocola/stac-extension-liability-claims
