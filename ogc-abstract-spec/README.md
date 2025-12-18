# OGC Abstract Specification: Liability and Claims for Geospatial Data

This directory contains the OGC Abstract Specification Topic for Liability and Claims management in geospatial data systems.

## Document Overview

- **Title**: OGC Abstract Specification Topic: Liability and Claims for Geospatial Data
- **Version**: 1.1.0
- **Status**: Draft (SWG Draft)
- **Editor**: Lucio Colaiacomo
- **Document Type**: Abstract Specification Topic

## Abstract

This OGC Abstract Specification Topic defines a comprehensive framework for representing and managing liability, legal claims, and quality assessments associated with geospatial data products. The specification provides conceptual models, requirements, and conformance classes for systems that must maintain accountability for geospatial data quality and usage in critical applications.

## Structure

The specification is organized using Metanorma (OGC's official documentation tool):

```
ogc-abstract-spec/
├── document.adoc                 # Main document
├── sections/                     # Document sections
│   ├── 00-preface.adoc          # Preface and abstract
│   ├── 01-scope.adoc            # Scope
│   ├── 02-conformance.adoc      # Conformance
│   ├── 03-references.adoc       # Normative references
│   ├── 04-terms_and_definitions.adoc
│   ├── 05-conventions.adoc      # Conventions and notations
│   ├── 06-conceptual-model.adoc # UML conceptual model
│   ├── 07-core-requirements.adoc # Requirements classes
│   ├── 08-quality-framework.adoc # Quality assessment
│   ├── 09-provenance-model.adoc  # W3C PROV-O integration
│   ├── 10-legal-frameworks.adoc  # Legal framework guidance
│   ├── aa-annexA-use-cases.adoc  # Use cases (informative)
│   ├── ab-annexB-examples.adoc   # Examples (informative)
│   ├── ac-annexC-conformance.adoc # Abstract test suite (normative)
│   └── az-bibliography.adoc      # Bibliography
├── Makefile                      # Build automation
├── metanorma.yml                # Metanorma configuration
└── README.md                     # This file
```

## Building the Document

### Prerequisites

Install Metanorma following instructions at: https://www.metanorma.org/install/

### Build Commands

```bash
# Build all output formats (HTML, PDF, DOC, XML)
make all

# Build specific format
make html
make pdf
make doc

# Clean build artifacts
make clean
```

### Using Docker

If you prefer not to install Metanorma locally, use Docker:

```bash
# Build with Docker
docker run --rm -v "$(pwd)":/metanorma \
  -v ${HOME}/.fontist/fonts/:/config/fonts \
  metanorma/metanorma \
  metanorma compile --agree-to-terms -t ogc -x xml,html,doc,pdf document.adoc
```

## Conformance Classes

This specification defines the following conformance classes:

1. **Core** (`/conf/core`) - Core requirements for liability representation
2. **Claims Management** (`/conf/claims`) - Claims documentation and tracking
3. **Quality Assessment** (`/conf/quality`) - Data quality frameworks
4. **Provenance** (`/conf/provenance`) - W3C PROV-O integration
5. **Legal Frameworks** (`/conf/legal`) - Multi-jurisdiction support

## Key Features

- **Conceptual Model**: UML-based object model for liability concepts
- **Requirements**: Normative requirements organized in classes
- **Quality Integration**: Based on ISO 19157 and W3C DQV
- **Provenance**: Full W3C PROV-O compliance for lineage tracking
- **Legal Frameworks**: Support for multiple jurisdictions and standards
- **Use Cases**: Real-world examples from emergency response, defense, insurance
- **Implementation Examples**: JSON, RDF/Turtle, XML examples

## Standards Compliance

This specification references and builds upon:

- ISO 19101-1: Geographic information – Reference model
- ISO 19103: Geographic information – Conceptual schema language
- ISO 19115-1: Geographic information – Metadata
- ISO 19157: Geographic information – Data quality
- W3C PROV-O: Provenance Ontology
- W3C DQV: Data Quality Vocabulary
- STAC: SpatioTemporal Asset Catalog

## Implementation

This abstract specification is implemented by:

- STAC Liability and Claims Extension v1.1.0
- Additional implementations may follow

## Contributing

This is a draft specification open for comment. To provide feedback:

1. Open an issue in the GitHub repository
2. Submit a pull request with proposed changes
3. Contact the editor directly

## License

This document is provided under the OGC Document License.

## Contact

**Editor**: Lucio Colaiacomo  
**Organization**: Defence Science and Technology  
**Email**: (contact via GitHub)

## Document Status

**Current Status**: Draft for review  
**Target Status**: OGC Abstract Specification Topic (approved)

## Next Steps

1. SWG review and refinement
2. Public comment period
3. Technical Committee review
4. OGC Architecture Board review
5. Final approval and publication
