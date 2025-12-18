# OGC Building Block Submission Package

This directory contains all files needed to submit the Liability and Claims STAC Extension to the OGC Building Blocks registry.

## Submission Process

### 1. Fork the OGC Repository

```bash
# Visit https://github.com/ogcincubator/bblocks-stac
# Click "Fork" button to create your own fork
```

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/bblocks-stac.git
cd bblocks-stac
```

### 3. Create Building Block Structure

```bash
# Create directory for the extension
mkdir -p _sources/extensions/liability-claims

# Copy files from this directory
cp ogc-bblock/schema.yaml _sources/extensions/liability-claims/
cp ogc-bblock/description.md _sources/extensions/liability-claims/
cp ../context.jsonld _sources/extensions/liability-claims/
cp ../json-schema/schema.json _sources/extensions/liability-claims/schema.json

# Copy examples
mkdir -p _sources/extensions/liability-claims/examples
cp ../tests/valid/item-basic.json _sources/extensions/liability-claims/examples/
cp ../tests/valid/item-with-prov.json _sources/extensions/liability-claims/examples/
cp ../tests/valid/item-with-quality.json _sources/extensions/liability-claims/examples/
```

### 4. Create Metadata File

Create `_sources/extensions/liability-claims/bblock.json`:

```json
{
  "$schema": "https://raw.githubusercontent.com/opengeospatial/bblocks-postprocess/master/ogc/bblocks/metadata-schema.yaml",
  "itemIdentifier": "ogc.contrib.stac.extensions.liability-claims",
  "name": "STAC Liability and Claims Extension",
  "abstract": "STAC extension for documenting liability claims, legal proceedings, and insurance information with ISO 19115 quality and W3C PROV provenance support",
  "status": "under-development",
  "dateTimeAddition": "2025-12-13T00:00:00Z",
  "itemClass": "schema",
  "register": "ogc-incubator-building-block-register",
  "version": "1.1.0",
  "dateOfLastChange": "2025-12-13",
  "link": "https://github.com/luciocola/stac-extension-liability-claims",
  "sources": [
    {
      "title": "GitHub Repository",
      "link": "https://github.com/luciocola/stac-extension-liability-claims"
    },
    {
      "title": "ISO 19115 Geographic Information - Metadata",
      "link": "https://www.iso.org/standard/53798.html"
    },
    {
      "title": "W3C PROV-DM",
      "link": "https://www.w3.org/TR/prov-dm/"
    }
  ],
  "scope": "contrib",
  "tags": [
    "stac",
    "stac-extension",
    "liability",
    "claims",
    "insurance",
    "legal",
    "quality",
    "provenance",
    "iso19115",
    "prov"
  ],
  "shaclShapes": {},
  "dependsOn": [
    "ogc.contrib.stac.item",
    "ogc.contrib.stac.collection",
    "ogc.ogc-utils.prov"
  ],
  "ldContext": "https://stac-extensions.github.io/liability-claims/v1.1.0/context.jsonld",
  "schema": {
    "application/yaml": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.yaml",
    "application/json": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  },
  "sourceLdContext": "context.jsonld",
  "sourceSchema": "schema.json"
}
```

### 5. Commit and Push

```bash
git checkout -b add-liability-claims-extension
git add _sources/extensions/liability-claims/
git commit -m "Add STAC Liability and Claims Extension

- ISO 19115/19115-4 quality reporting
- W3C PROV provenance support
- Legal/insurance claim documentation
- Comprehensive test suite
- Full JSON-LD context for semantic web integration"

git push origin add-liability-claims-extension
```

### 6. Create Pull Request

1. Go to your fork on GitHub
2. Click "Compare & pull request"
3. Fill in the PR template with:
   - **Title**: "Add STAC Liability and Claims Extension"
   - **Description**: Use the text from `PR-DESCRIPTION.md` in this directory
   - **Checklist**: Mark all completed items
4. Submit the pull request

### 7. Respond to Review

The OGC team will review your submission and may request:
- Schema adjustments
- Additional examples
- Documentation clarifications
- Test coverage improvements

## Files in This Directory

- `README.md` - This file (submission instructions)
- `bblock.json` - OGC Building Block metadata
- `description.md` - Building block description for OGC register
- `schema.yaml` - YAML version of JSON schema (optional)
- `PR-DESCRIPTION.md` - Pull request description template
- `SUBMISSION-CHECKLIST.md` - Pre-submission verification checklist

## Required Files (To Copy)

From parent directory:
- `../context.jsonld` → JSON-LD context
- `../json-schema/schema.json` → Main schema
- `../tests/valid/*.json` → Example files
- `../README.md` → Documentation (reference)

## Validation Before Submission

Run these checks before submitting:

```bash
# 1. Validate JSON Schema
ajv compile -s schema.json

# 2. Validate examples against schema
ajv validate -s schema.json -d "examples/*.json"

# 3. Validate JSON-LD context
python3 -m json.tool < context.jsonld > /dev/null

# 4. Check all files present
ls -la schema.json context.jsonld bblock.json description.md examples/
```

## Expected Timeline

- **Initial Review**: 1-2 weeks
- **Revisions** (if needed): 1-4 weeks depending on feedback
- **Final Approval**: 1-2 weeks
- **Total**: 3-8 weeks for full acceptance

## Support

For questions about the submission process:
- OGC Building Blocks: https://github.com/opengeospatial/bblocks
- STAC Extensions: https://github.com/stac-extensions
- Extension Author: luciocol@gmail.com

## Post-Acceptance

Once accepted:
1. Extension will appear in OGC Building Blocks register
2. Automatic validation will run on examples
3. Documentation will be auto-generated
4. Extension becomes referenceable by other building blocks

---

**Status**: Ready for submission  
**Date Prepared**: 2025-12-13  
**Extension Version**: 1.1.0
