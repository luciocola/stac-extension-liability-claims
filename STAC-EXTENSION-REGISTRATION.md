# STAC Extension Registration Guide

## Overview

This guide walks you through registering the **Liability and Claims Extension** as an official STAC extension in the [stac-extensions organization](https://github.com/stac-extensions).

**Current Status:** Proposal  
**Target Status:** Community Extension → Pilot Extension → Stable Extension  
**Registration URL:** `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`

---

## Prerequisites Checklist

Before registering, ensure all requirements are met:

- [x] **JSON Schema** - Valid JSON Schema at `json-schema/schema.json` (1103 lines)
- [x] **README.md** - Comprehensive documentation (761 lines)
- [x] **Examples** - Working STAC Item/Collection examples (14 examples)
- [x] **CHANGELOG.md** - Version history
- [x] **LICENSE** - Apache-2.0 license
- [x] **Validation** - All examples pass JSON Schema validation
- [x] **JSON-LD Context** - Semantic web support (`context.jsonld`)
- [x] **Maturity Classification** - Currently "Proposal"
- [x] **OGC Compliance** - Aligned with OGC Building Blocks
- [x] **Compatibility** - T21-DQ4IPT compatibility documented

---

## Step-by-Step Registration Process

### Step 1: Publish to GitHub (Required)

The extension **must** be publicly available on GitHub before registration.

**Option A: Create New Repository**

1. Go to https://github.com/new
2. Repository name: `stac-extension-liability-claims`
3. Description: `STAC Extension for Liability Claims, Data Quality (ISO 19157/19115), and Provenance (W3C PROV, Verifiable Credentials)`
4. Make it **Public**
5. **DO NOT** initialize with README (we already have one)
6. Click "Create repository"

7. Push your local repository:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

# Configure git (if not already done)
git config --global user.name "Lucio Colaiacomo"
git config --global user.email "your.email@example.com"

# Initialize repository
git init
git branch -M main
git add .
git commit -m "Initial commit: STAC Liability and Claims Extension v1.1.0"

# Add remote and push
git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git
git push -u origin main
```

**Option B: Use Existing Repository**

If you already have a repository, update it:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

git add .
git commit -m "Prepare for STAC extension registration"
git push
```

**Repository URL:** `https://github.com/luciocola/stac-extension-liability-claims`

---

### Step 2: Update Extension Identifier

Update the schema `$id` to point to the future stac-extensions.github.io URL:

**Current:** `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`  
✓ **Already correct!** No changes needed.

**In `json-schema/schema.json`:**
```json
{
  "$id": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json",
  ...
}
```

**In `README.md`:**
```markdown
- **Identifier:** <https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json>
```

✓ **Already configured correctly!**

---

### Step 3: Request Transfer to stac-extensions Organization

**Option A: Transfer Existing Repository (Recommended)**

If you created the repository under your personal account:

1. Go to your repository settings: `https://github.com/luciocola/stac-extension-liability-claims/settings`
2. Scroll to "Danger Zone" → "Transfer ownership"
3. Type: `stac-extensions`
4. Confirm transfer

**Option B: Create Issue for New Repository**

If you want the stac-extensions org to create the repository:

1. Go to: https://github.com/stac-extensions/stac-extensions.github.io/issues/new
2. Title: `New Extension: Liability and Claims`
3. Use this template:

```markdown
## Extension Information

- **Name:** Liability and Claims
- **Prefix:** `liability`
- **Repository:** https://github.com/luciocola/stac-extension-liability-claims
- **Maturity:** Proposal
- **Scope:** Item, Collection, Assets, Item Assets, Summaries

## Description

STAC Extension for documenting liability information, insurance claims, and legal proceedings associated with geospatial data assets. Includes comprehensive support for:

- **Data Quality**: ISO 19157-1:2023 (RECOMMENDED) and ISO 19115/19115-4 quality reporting
- **Provenance**: W3C PROV-DM for semantic web provenance tracking
- **Verifiable Credentials**: W3C VC 2.0 for cryptographically signed claims
- **Legal/Insurance**: Claim tracking, damage assessment, responsible parties

## Standards Alignment

- ISO 19157-1:2023 (Data Quality)
- ISO 19115/19115-4 (Geospatial Metadata)
- W3C PROV (Provenance)
- W3C Verifiable Credentials 2.0
- OGC Building Blocks compliant
- T21-DQ4IPT compatible

## Request

Please create repository `stac-extensions/liability-claims` or accept transfer from `luciocola/stac-extension-liability-claims`.

**Owner:** @luciocola  
**Contact:** [your.email@example.com]
```

---

### Step 4: Add to Extension Registry

Once the repository is in the stac-extensions organization, add it to the official registry:

1. **Fork** the STAC Extensions index repository:
   - Visit: https://github.com/stac-extensions/stac-extensions.github.io
   - Click "Fork"

2. **Edit the registry file** in your fork:
   - File: `registry.json`
   - Add your extension:

```json
{
  "extensions": [
    ...existing extensions...,
    {
      "title": "Liability and Claims",
      "description": "Extension for liability information, insurance claims, and legal proceedings with ISO 19157 quality and W3C PROV provenance",
      "prefix": "liability",
      "maturity": "Proposal",
      "repo": "https://github.com/stac-extensions/liability-claims",
      "schema": "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json",
      "owner": "@luciocola",
      "scopes": ["Item", "Collection", "Assets", "Item Assets", "Summaries"]
    }
  ]
}
```

3. **Create Pull Request:**
   - Title: `Add Liability and Claims Extension to Registry`
   - Description:

```markdown
This PR adds the Liability and Claims Extension to the official STAC extensions registry.

**Extension:** Liability and Claims  
**Prefix:** `liability`  
**Maturity:** Proposal  
**Repository:** https://github.com/stac-extensions/liability-claims

## Summary

Provides fields for documenting:
- Liability and insurance claims
- ISO 19157-1:2023 data quality reporting (RECOMMENDED)
- ISO 19115/19115-4 quality (backward compatibility)
- W3C PROV provenance graphs
- W3C Verifiable Credentials 2.0 for cryptographic verification
- Legal compliance and responsible parties

## Standards Compliance

- ✓ JSON Schema validation
- ✓ 14 working examples
- ✓ Comprehensive documentation (761 lines)
- ✓ Changelog
- ✓ Apache-2.0 license
- ✓ JSON-LD context
- ✓ OGC Building Blocks aligned
- ✓ T21-DQ4IPT compatible

## Use Cases

1. Environmental liability tracking
2. Insurance claims management
3. Legal compliance documentation
4. Data quality assessment (ISO 19157)
5. Provenance tracking (W3C PROV)
```

---

### Step 5: Configure GitHub Pages (Schema Hosting)

Enable GitHub Pages to host your schema at the official URL:

1. Go to repository settings: `https://github.com/stac-extensions/liability-claims/settings/pages`
2. Under "Source", select:
   - Branch: `main`
   - Folder: `/ (root)`
3. Click "Save"
4. GitHub Pages URL will be: `https://stac-extensions.github.io/liability-claims/`

**Verify schema is accessible:**
- After ~5 minutes, visit: `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`
- Should return your JSON Schema

**Directory structure for GitHub Pages:**

```
/
├── v1.1.0/
│   ├── schema.json          # Main schema
│   ├── README.md            # Documentation
│   └── examples/            # Example files
├── context.jsonld           # JSON-LD context (root level)
└── index.html              # Optional: landing page
```

Update your repository to match this structure:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

# Create v1.1.0 directory
mkdir -p v1.1.0
cp json-schema/schema.json v1.1.0/
cp README.md v1.1.0/
cp -r examples v1.1.0/

# Commit and push
git add v1.1.0/
git commit -m "Add v1.1.0 directory for GitHub Pages hosting"
git push
```

---

### Step 6: Community Announcement

Announce your extension to the STAC community:

**1. STAC Gitter Chat:**

Join: https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby

Post message:
```
🎉 New STAC Extension Proposal: Liability and Claims

I've submitted a new extension for community review:

📦 **Extension:** Liability and Claims
🔗 **Repo:** https://github.com/stac-extensions/liability-claims
📄 **Schema:** https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json

**Features:**
✅ ISO 19157-1:2023 data quality reporting (RECOMMENDED)
✅ ISO 19115/19115-4 quality (backward compatibility)
✅ W3C PROV provenance tracking
✅ W3C Verifiable Credentials 2.0 support
✅ Legal/insurance claim documentation
✅ OGC T21-DQ4IPT compatible

**Use Cases:**
- Environmental liability tracking
- Insurance claims management  
- Data quality assessment
- Legal compliance
- Provenance documentation

Feedback welcome! 🙏
```

**2. STAC Mailing List:**

Subscribe and post: https://lists.osgeo.org/mailman/listinfo/stac-community

**3. STAC Spec Repository Discussion:**

Create discussion: https://github.com/radiantearth/stac-spec/discussions/new

---

### Step 7: Request Maturity Advancement

As your extension gains adoption, advance maturity level:

**Maturity Levels:**

1. **Proposal** (Current) - Initial submission, seeking feedback
2. **Pilot** - At least 3 independent implementations
3. **Candidate** - At least 6 implementations, stable API
4. **Stable** - Widely adopted, no breaking changes expected
5. **Deprecated** - Superseded by another extension

**Advancing to Pilot:**

Requirements:
- ✓ At least 3 independent organizations using the extension
- ✓ No major issues reported
- ✓ Stable schema (no breaking changes for 3+ months)

When ready, open issue in your extension repository:
- Title: `Request Maturity Advancement: Proposal → Pilot`
- Provide evidence of 3+ implementations
- Link to any dependent projects

Update README.md:
```markdown
- **Extension [Maturity Classification](...):** Pilot
```

---

## Quick Reference

### Repository Checklist

- [ ] Public GitHub repository created
- [ ] Repository transferred to stac-extensions org (or requested)
- [ ] GitHub Pages enabled
- [ ] Schema accessible at `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`
- [ ] Added to STAC extensions registry
- [ ] Community announcement posted
- [ ] Repository topics added: `stac`, `stac-extension`, `geospatial`, `iso-19157`, `w3c-prov`

### Files Checklist

- [x] `json-schema/schema.json` - Valid JSON Schema
- [x] `README.md` - Comprehensive documentation
- [x] `CHANGELOG.md` - Version history
- [x] `LICENSE` - Apache-2.0
- [x] `examples/*.json` - Working examples
- [x] `context.jsonld` - JSON-LD context
- [x] `.github/workflows/` - CI/CD (optional but recommended)

### URLs

- **Source Repository:** `https://github.com/luciocola/stac-extension-liability-claims` (before transfer)
- **Official Repository:** `https://github.com/stac-extensions/liability-claims` (after transfer)
- **Schema URL:** `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`
- **Documentation:** `https://stac-extensions.github.io/liability-claims/v1.1.0/README.html`
- **Registry Entry:** `https://stac-extensions.github.io/`

---

## Support & Resources

### STAC Extension Guidelines

Official documentation: https://github.com/radiantearth/stac-spec/blob/master/extensions/README.md

### Extension Template

Reference template: https://github.com/stac-extensions/template

### Community Channels

- **Gitter Chat:** https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby
- **Mailing List:** https://lists.osgeo.org/mailman/listinfo/stac-community
- **GitHub Discussions:** https://github.com/radiantearth/stac-spec/discussions

### Example Extensions

Reference implementations:
- https://github.com/stac-extensions/eo (Electro-Optical)
- https://github.com/stac-extensions/sar (Synthetic Aperture Radar)
- https://github.com/stac-extensions/scientific (Scientific)

---

## Next Steps

1. **Immediate:** Publish repository to GitHub (Step 1)
2. **Week 1:** Request transfer to stac-extensions org (Step 3)
3. **Week 2:** Add to registry and configure GitHub Pages (Steps 4-5)
4. **Week 3:** Community announcement (Step 6)
5. **Month 3-6:** Gather feedback and implementations
6. **Month 6+:** Request maturity advancement to Pilot (Step 7)

---

## Contacts

**Extension Owner:** @luciocola  
**Organization:** Secure Dimensions  
**Support:** Open issues at repository  

**STAC Community:**
- GitHub: https://github.com/radiantearth/stac-spec
- Website: https://stacspec.org/
