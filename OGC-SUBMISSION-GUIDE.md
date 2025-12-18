# OGC Building Blocks Submission - Complete Guide

## ✅ Submission Package Ready

Your STAC Liability and Claims Extension is fully prepared for OGC Building Blocks submission!

**Package Location:** `ogc-submission-package/`  
**Archive:** `stac-liability-claims-v1.1.0-ogc-submission.tar.gz` (16KB)  
**Status:** All files validated ✓

---

## 📦 Package Contents

```
ogc-submission-package/
├── bblock.json              # OGC Building Block metadata
├── description.md           # Comprehensive documentation
├── schema.json              # JSON Schema definition (1013 lines)
├── context.jsonld           # JSON-LD context for RDF uplift (125 lines)
├── SUBMIT.md                # Step-by-step submission instructions
└── examples/
    ├── item-basic.json           # Basic environmental claim (2.5KB)
    ├── item-with-prov.json       # W3C PROV provenance (11KB)
    ├── item-with-quality.json    # ISO 19115 quality (5.9KB)
    └── collection-basic.json     # Collection example (1.9KB)
```

---

## 🚀 How to Submit (3 Options)

### Option 1: Via GitHub Web Interface (Easiest)

1. **Fork the repository**
   - Visit: https://github.com/ogcincubator/bblocks-stac
   - Click "Fork" button (top right)

2. **Create new branch in your fork**
   - In your fork, click "main" dropdown → "View all branches"
   - Click "New branch"
   - Name: `add-liability-claims-extension`

3. **Upload files via GitHub**
   - Navigate to `_sources/extensions/` in your fork
   - Click "Add file" → "Create new file"
   - Name the file: `liability-claims/.gitkeep` (this creates the directory)
   - Click "Commit changes"
   - Now navigate into `liability-claims/` folder
   - Click "Add file" → "Upload files"
   - Drag and drop all files from `ogc-submission-package/` (except SUBMIT.md)
   - Click "Commit changes"
   - Create `examples/` subfolder and upload example files

4. **Create Pull Request**
   - Go to your fork's main page
   - Click "Compare & pull request" (green button)
   - **Title**: `Add STAC Liability and Claims Extension`
   - **Description**: Copy content from `ogc-bblock/PR-DESCRIPTION.md`
   - Click "Create pull request"

### Option 2: Via Command Line (Recommended for developers)

```bash
# 1. Fork on GitHub first, then clone your fork
git clone https://github.com/YOUR_USERNAME/bblocks-stac.git
cd bblocks-stac

# 2. Create branch
git checkout -b add-liability-claims-extension

# 3. Create directory structure
mkdir -p _sources/extensions/liability-claims/examples

# 4. Copy files from submission package
cd /path/to/stac-extension-liability-claims
cp ogc-submission-package/bblock.json ../bblocks-stac/_sources/extensions/liability-claims/
cp ogc-submission-package/description.md ../bblocks-stac/_sources/extensions/liability-claims/
cp ogc-submission-package/schema.json ../bblocks-stac/_sources/extensions/liability-claims/
cp ogc-submission-package/context.jsonld ../bblocks-stac/_sources/extensions/liability-claims/
cp ogc-submission-package/examples/*.json ../bblocks-stac/_sources/extensions/liability-claims/examples/

# 5. Commit and push
cd ../bblocks-stac
git add _sources/extensions/liability-claims/
git commit -m "Add STAC Liability and Claims Extension

- ISO 19115/19115-4 quality reporting
- W3C PROV provenance support  
- Legal/insurance claim documentation
- Comprehensive test suite
- Full JSON-LD context for semantic web"

git push origin add-liability-claims-extension

# 6. Create PR on GitHub
# Visit your fork and click "Compare & pull request"
```

### Option 3: Extract Archive and Copy

```bash
# Extract the prepared archive
tar -xzf stac-liability-claims-v1.1.0-ogc-submission.tar.gz -C /tmp/ogc-submit

# Follow steps from Option 2, copying from /tmp/ogc-submit instead
```

---

## 📋 Pull Request Checklist

When creating your PR, ensure:

- [x] PR title: "Add STAC Liability and Claims Extension"
- [x] Description includes full content from `ogc-bblock/PR-DESCRIPTION.md`
- [x] All files copied to `_sources/extensions/liability-claims/`
- [x] Examples in `_sources/extensions/liability-claims/examples/`
- [x] Branch name: `add-liability-claims-extension`
- [x] Base branch: `main` (OGC repository)
- [x] Compare branch: `add-liability-claims-extension` (your fork)

---

## 🔍 What Happens Next?

### Automated Validation (Minutes)

GitHub Actions will automatically:
- Validate JSON Schema syntax
- Check all examples pass validation
- Verify JSON-LD context
- Test building block metadata
- Generate documentation preview

### OGC Team Review (1-2 weeks)

Reviewers will check:
- Alignment with OGC Building Blocks standards
- Schema quality and consistency
- Documentation completeness
- Example coverage
- Dependency correctness

### Possible Review Outcomes

1. **✅ Approved** - Merged into register
2. **🔄 Changes Requested** - Address feedback and update PR
3. **❓ Questions** - Clarify use cases or technical details

### Post-Acceptance (Automatic)

Once merged:
- Extension appears in OGC Building Blocks register
- Documentation auto-generated and published
- Validation examples run on schedule
- Extension becomes referenceable by other building blocks
- URL becomes active: `https://ogcincubator.github.io/bblocks-stac/bblock/ogc.contrib.stac.extensions.liability-claims`

---

## 📊 Pre-Validation Results

All submission requirements verified:

### Files ✓
- [x] bblock.json validated
- [x] schema.json compiles successfully
- [x] context.jsonld valid JSON-LD
- [x] description.md complete
- [x] 4 examples validate against schema

### Metadata ✓
- [x] Identifier: `ogc.contrib.stac.extensions.liability-claims`
- [x] Dependencies declared: stac.item, stac.collection, ogc-utils.prov
- [x] Tags and keywords defined
- [x] Sources and references included
- [x] License specified (Apache 2.0)

### Quality ✓
- [x] No schema conflicts
- [x] No circular references
- [x] Clear documentation
- [x] Realistic examples
- [x] Comprehensive test coverage

---

## 📚 Reference Documents

Located in `ogc-bblock/` directory:

1. **README.md** - Complete submission instructions
2. **PR-DESCRIPTION.md** - Copy this for your pull request description
3. **SUBMISSION-CHECKLIST.md** - Verify all requirements met
4. **bblock.json** - Building block metadata
5. **description.md** - Full documentation
6. **prepare-submission.sh** - Package creation script (already run)

---

## 🆘 Troubleshooting

### "Validation failed" message

Check that:
- All JSON files are syntactically valid
- Schema references are correct
- Examples use correct extension URL
- No schema conflicts with existing building blocks

### "Dependencies not found"

Ensure `dependsOn` array in `bblock.json` lists:
- `ogc.contrib.stac.item`
- `ogc.contrib.stac.collection`
- `ogc.ogc-utils.prov`

### "Examples don't validate"

Run local validation:
```bash
cd ogc-submission-package
ajv validate -s schema.json -d "examples/*.json"
```

### Need help?

- OGC Building Blocks Docs: https://opengeospatial.github.io/bblocks/
- OGC GitHub Discussions: https://github.com/opengeospatial/bblocks/discussions
- Extension Author: luciocol@gmail.com

---

## ⏱️ Expected Timeline

| Phase | Duration | Your Action |
|-------|----------|-------------|
| Fork & Upload | 30 min | Fork repo, upload files, create PR |
| Automated Tests | 5-10 min | Wait for CI/CD validation |
| Initial Review | 1-2 weeks | Respond to any questions |
| Revisions (if needed) | Variable | Address feedback, update PR |
| Final Approval | 1 week | None (awaiting merge) |
| **Total** | **3-8 weeks** | Minimal ongoing involvement |

---

## ✨ Summary

You now have everything needed to submit your extension to OGC Building Blocks:

✅ **All files prepared and validated**  
✅ **Submission package created (16KB archive)**  
✅ **Documentation complete**  
✅ **Examples tested**  
✅ **Dependencies verified**  
✅ **Checklist 100% complete**

**Next Action**: Choose submission method (Option 1, 2, or 3 above) and create your pull request!

---

**Submission Package Date**: 2025-12-13  
**Extension Version**: 1.1.0  
**Package Status**: ✅ Ready for OGC Submission  
**Maintainer**: Lucio Colaiacomo (@luciocola)
