# 🎯 STAC Extension Registration - Command Reference Card

Quick reference for registering the stac-extension-liability-claims.

---

## 🚀 One-Command Registration

Run this to complete GitHub setup:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims && \
git init && \
git branch -M main && \
git add . && \
git commit -m "STAC Liability and Claims Extension v1.1.0 - Ready for registration" && \
git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git && \
git push -u origin main
```

**Note:** Create the repository at https://github.com/new first!

---

## 📝 Step-by-Step Commands

### 1. Create GitHub Repository

Visit: https://github.com/new
- Name: `stac-extension-liability-claims`
- Public ✓
- No README ✓

### 2. Initialize and Push

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

# Configure git (if first time)
git config --global user.name "Lucio Colaiacomo"
git config --global user.email "your.email@example.com"

# Initialize repository
git init
git branch -M main

# Stage all files
git add .

# Commit
git commit -m "STAC Liability and Claims Extension v1.1.0

- ISO 19157-1:2023 data quality support
- W3C PROV provenance tracking
- W3C Verifiable Credentials 2.0
- Legal liability and claims documentation
- OGC Building Blocks compliant
- 14 validated examples
- GitHub Actions CI/CD
- Ready for stac-extensions registration"

# Add remote (replace 'luciocola' with your username)
git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git

# Push to GitHub
git push -u origin main
```

### 3. Enable GitHub Pages

```bash
# Option A: Via GitHub Web Interface
# 1. Go to: https://github.com/luciocola/stac-extension-liability-claims/settings/pages
# 2. Source: main / (root)
# 3. Save

# Option B: Via GitHub CLI (if installed)
gh repo edit --enable-pages --pages-branch main --pages-path /
```

### 4. Add Repository Topics

```bash
# Via GitHub Web
# Click ⚙️ next to About → Add topics:
# stac, stac-extension, geospatial, liability, claims, insurance,
# data-quality, iso-19157, iso-19115, provenance, w3c-prov,
# verifiable-credentials, legal-compliance, ogc, stac-api

# Via GitHub CLI
gh repo edit --add-topic "stac,stac-extension,geospatial,liability,claims,insurance,data-quality,iso-19157,iso-19115,provenance,w3c-prov,verifiable-credentials"
```

### 5. Transfer to stac-extensions Org

```bash
# Via GitHub Web
# Settings → Transfer ownership → Type: stac-extensions

# Via GitHub CLI
gh repo transfer stac-extensions/liability-claims
```

---

## 🔍 Verification Commands

```bash
# Verify schema is valid
python3 -c "import json; json.load(open('v1.1.0/schema.json')); print('✅ Schema valid')"

# Count examples
ls -1 v1.1.0/examples/*.json | wc -l

# Verify GitHub Pages structure
ls -R v1.1.0/

# Check git status
git status

# View commit history
git log --oneline

# Test GitHub remote
git remote -v
```

---

## 🌐 After Push - Verification URLs

Replace `luciocola` with your GitHub username:

```bash
# Repository
open https://github.com/luciocola/stac-extension-liability-claims

# GitHub Pages (wait 2-5 minutes after enabling)
open https://luciocola.github.io/stac-extension-liability-claims/

# Schema URL
open https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json

# Actions (CI/CD status)
open https://github.com/luciocola/stac-extension-liability-claims/actions
```

---

## 📋 Registry Submission

### Fork and Edit Registry

```bash
# Fork the registry repo (via GitHub web interface)
# Visit: https://github.com/stac-extensions/stac-extensions.github.io
# Click "Fork"

# Clone your fork
git clone https://github.com/YOUR_USERNAME/stac-extensions.github.io.git
cd stac-extensions.github.io

# Create branch
git checkout -b add-liability-claims

# Edit registry.json (add your extension)
# ... manual edit required ...

# Commit and push
git add registry.json
git commit -m "Add Liability and Claims Extension"
git push origin add-liability-claims

# Create PR via GitHub web interface
# Visit: https://github.com/YOUR_USERNAME/stac-extensions.github.io
# Click "Compare & pull request"
```

### Registry Entry (JSON to add)

```json
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
```

---

## 🆘 Troubleshooting

### Problem: Git push rejected

```bash
# If repository already has commits
git pull origin main --rebase
git push -u origin main
```

### Problem: GitHub Pages not working

```bash
# Verify files exist
ls -la index.html v1.1.0/schema.json

# Check GitHub Pages settings
open https://github.com/luciocola/stac-extension-liability-claims/settings/pages

# Wait 5 minutes, then test
curl -I https://luciocola.github.io/stac-extension-liability-claims/
```

### Problem: Schema validation fails

```bash
# Re-run preparation script
./prepare-registration.sh

# Manually validate
python3 -c "
import json
from jsonschema import Draft7Validator
schema = json.load(open('v1.1.0/schema.json'))
Draft7Validator.check_schema(schema)
print('✅ Valid')
"
```

### Problem: Examples not found

```bash
# Verify examples copied
ls -l v1.1.0/examples/

# Re-copy if needed
cp examples/*.json v1.1.0/examples/
git add v1.1.0/examples/
git commit -m "Add examples"
git push
```

---

## 📞 Get Help

**Community Support:**
- Gitter: https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby
- Mailing List: stac-community@lists.osgeo.org
- GitHub Discussions: https://github.com/radiantearth/stac-spec/discussions

**Documentation:**
- Full Guide: `STAC-EXTENSION-REGISTRATION.md`
- Quick Start: `QUICK-START-REGISTRATION.md`
- Status: `REGISTRATION-STATUS.md`

---

## ✅ Success Checklist

- [ ] Repository created on GitHub
- [ ] Code pushed to main branch
- [ ] GitHub Actions passing (green ✓)
- [ ] GitHub Pages enabled
- [ ] Schema accessible via HTTPS
- [ ] Repository topics added
- [ ] Transfer requested to stac-extensions
- [ ] Registry PR created
- [ ] Community announced

**When all complete:** You're officially a STAC extension author! 🎉

---

**Last Updated:** January 21, 2026  
**Extension Version:** 1.1.0  
**Target Maturity:** Proposal → Pilot (after 3+ implementations)
