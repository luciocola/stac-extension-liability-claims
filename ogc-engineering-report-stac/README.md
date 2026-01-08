# STAC Liability and Claims Extension - OGC Engineering Report

This directory contains the OGC Engineering Report for the STAC Liability and Claims Extension v1.1.0.

## Structure

```
ogc-engineering-report/
├── document.adoc              # Main document with metadata
├── sections/
│   ├── 00-executive_summary.adoc
│   ├── 01-introduction.adoc
│   ├── 02-topics.adoc
│   ├── 03-outlook.adoc
│   ├── 04-security_privacy_ethical.adoc
│   ├── aa-annexA_bibliography.adoc
│   └── ab-annexB_abbreviations_acronyms.adoc
├── images/                    # Images directory (currently empty)
└── README.md                  # This file
```

## Building the Document

### Prerequisites

You need either:
- **Local Metanorma installation** - See https://www.metanorma.org/install/
- **Docker** - For containerized Metanorma

### Build with Local Metanorma

```bash
cd ogc-engineering-report
metanorma compile --agree-to-terms -t ogc -x xml,html,doc,pdf document.adoc
```

The `--agree-to-terms` flag is required to retrieve licensed fonts.

### Build with Docker

```bash
cd ogc-engineering-report
docker run -v "$(pwd)":/metanorma -v ${HOME}/.fontist/fonts/:/config/fonts \
  metanorma/metanorma metanorma compile --agree-to-terms -t ogc -x xml,html,doc,pdf document.adoc
```

### Output Files

After compilation, you will have:
- `document.xml` - Metanorma XML
- `document.html` - HTML version
- `document.doc` - Microsoft Word version
- `document.pdf` - PDF version

## Document Sections

### Executive Summary
High-level overview with:
- Overview of the extension and its purpose
- Future outlook and development roadmap
- Value proposition for different stakeholder groups
- Contributors list

### Introduction
Provides context including:
- Background on STAC and the need for liability tracking
- Project objectives
- Scope definition
- Document structure
- Intended audience

### Topics
Detailed technical documentation covering:
- Extension architecture and schema design
- ISO 19115/19115-4 quality metadata integration
- W3C PROV provenance model implementation
- Semantic web integration (JSON-LD, RDF, SPARQL)
- Validation framework (JSON Schema, SHACL, CI/CD)
- Interoperability analysis (NASA UMM, TrainingDML-AI, DGIWG)
- OGC Building Blocks alignment
- Implementation examples
- Performance considerations

### Outlook
Future development directions and enhancements.

### Security, Privacy and Ethical Considerations
Addresses:
- Security concerns (access control, provenance integrity)
- Privacy implications (PII, geographic privacy)
- Ethical considerations (transparency, algorithmic accountability)

### Annexes
- Annex A: Comprehensive bibliography of standards and references
- Annex B: Abbreviations and acronyms

## Authoring Guidelines

When editing the document:

1. **Follow Metanorma/AsciiDoc syntax** - See https://www.metanorma.org/author/ogc/authoring-guide/
2. **Use semantic markup** - Proper headings, lists, tables, code blocks
3. **Reference standards properly** - Use bibliography entries in Annex A
4. **Maintain section structure** - Don't reorganize without updating document.adoc includes
5. **Test compilation** - Build locally before committing changes

## Metanorma Resources

- OGC Authoring Guide: https://www.metanorma.org/author/ogc/authoring-guide/
- AsciiDoc Syntax: https://docs.asciidoctor.org/asciidoc/latest/
- Metanorma Installation: https://www.metanorma.org/install/
- OGC Template Repository: https://github.com/opengeospatial/templates/tree/master/engineering_report

## Document Metadata

- **Document Type**: Engineering Report
- **Status**: Published
- **Document Number**: 25-XXX (to be assigned by OGC)
- **Committee**: Technical
- **Editor**: Lucio Colaiacomo (Secure Dimensions GmbH)
- **Version**: 1.1.0
- **Date**: 2025-12-21

## License

This document follows OGC document licensing. The extension itself is licensed under Apache 2.0.
