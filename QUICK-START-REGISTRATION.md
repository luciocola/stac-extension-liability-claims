# 🚀 Quick Start: Register Your STAC Extension in 5 Minutes

This guide will get your **Liability and Claims Extension** registered as an official STAC extension.

## Prerequisites

- ✅ GitHub account
- ✅ Git installed
- ✅ 5-10 minutes of your time

## Steps

### 1️⃣ Prepare Repository (1 minute)

Run the automated setup script:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims
./prepare-registration.sh
```

This creates:
- ✅ `v1.1.0/` directory structure for GitHub Pages
- ✅ `index.html` landing page
- ✅ Updated `package.json`
- ✅ GitHub Actions CI/CD workflow
- ✅ Repository configuration files

### 2️⃣ Create GitHub Repository (2 minutes)

**Option A: Via GitHub Web**

1. Go to: https://github.com/new
2. Repository name: `stac-extension-liability-claims`
3. Description: `STAC Extension for Liability Claims, Data Quality (ISO 19157/19115), and Provenance (W3C PROV, Verifiable Credentials)`
4. Make it **Public**
5. **Do NOT** initialize with README
6. Click **Create repository**

**Option B: Via Command Line**

```bash
# Using GitHub CLI (if installed)
gh repo create stac-extension-liability-claims --public \
  --description "STAC Extension for Liability Claims, Data Quality, and Provenance"
```

### 3️⃣ Push Your Code (1 minute)

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

# Configure git (if not already done)
git config --global user.name "Lucio Colaiacomo"
git config --global user.email "your.email@example.com"

# Initialize and push
git init
git branch -M main
git add .
git commit -m "STAC Liability and Claims Extension v1.1.0 - Ready for registration"

# Add remote (replace 'luciocola' with your GitHub username)
git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git

# Push to GitHub
git push -u origin main
```

### 4️⃣ Enable GitHub Pages (30 seconds)

1. Go to your repository settings:
   `https://github.com/luciocola/stac-extension-liability-claims/settings/pages`

2. Under **Source**:
   - Branch: `main`
   - Folder: `/ (root)`

3. Click **Save**

4. Wait ~2 minutes, then verify:
   - Visit: `https://luciocola.github.io/stac-extension-liability-claims/`
   - Schema: `https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json`

### 5️⃣ Add Repository Topics (30 seconds)

1. Go to your repository homepage
2. Click ⚙️ (gear icon) next to "About"
3. Add these topics (from `.github-topics.txt`):
   ```
   stac, stac-extension, geospatial, liability, claims, insurance,
   data-quality, iso-19157, iso-19115, provenance, w3c-prov,
   verifiable-credentials, legal-compliance, ogc, stac-api
   ```
4. Click **Save changes**

### 6️⃣ Request Transfer to stac-extensions Org (1 minute)

**Option A: Transfer Repository (Recommended)**

1. Go to Settings → scroll to **Danger Zone** → **Transfer ownership**
2. Type: `stac-extensions`
3. Confirm transfer

**Option B: Create Issue**

1. Go to: https://github.com/stac-extensions/stac-extensions.github.io/issues/new
2. Title: `New Extension: Liability and Claims`
3. Body:
   ```markdown
   ## Extension Request
   
   - **Name:** Liability and Claims
   - **Prefix:** `liability`
   - **Repository:** https://github.com/luciocola/stac-extension-liability-claims
   - **Maturity:** Proposal
   - **Owner:** @luciocola
   
   ## Description
   
   Extension for liability information, insurance claims, data quality 
   (ISO 19157/19115), and provenance (W3C PROV, VC 2.0).
   
   ## Standards
   
   - ISO 19157-1:2023
   - ISO 19115/19115-4
   - W3C PROV
   - W3C Verifiable Credentials 2.0
   - OGC Building Blocks
   
   Please create or accept transfer of repository to stac-extensions org.
   ```

---

## ✅ Done!

Your extension is now ready for registration! 

### What Happens Next?

1. **Community Review** - STAC community reviews your extension (~1-2 weeks)
2. **Feedback** - Address any feedback via GitHub issues
3. **Approval** - Extension gets official stac-extensions namespace
4. **Registry Addition** - Added to https://stac-extensions.github.io/

### Official URLs (After Transfer)

- **Repository:** `https://github.com/stac-extensions/liability-claims`
- **Homepage:** `https://stac-extensions.github.io/liability-claims/`
- **Schema:** `https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json`

---

## 🆘 Need Help?

**Documentation:**
- 📖 Full guide: `STAC-EXTENSION-REGISTRATION.md`
- 📋 STAC Extensions: https://github.com/stac-extensions

**Community Support:**
- 💬 Gitter: https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby
- 📧 Mailing list: https://lists.osgeo.org/mailman/listinfo/stac-community
- 💭 Discussions: https://github.com/radiantearth/stac-spec/discussions

---

## 📊 Current Status

Check your progress:

- [ ] Repository created on GitHub
- [ ] Code pushed to main branch
- [ ] GitHub Pages enabled
- [ ] Repository topics added
- [ ] Transfer requested to stac-extensions org
- [ ] Schema accessible via HTTPS
- [ ] GitHub Actions passing ✅

Once all checkboxes are complete, your extension is officially submitted!

---

**Next:** See `STAC-EXTENSION-REGISTRATION.md` for advanced options and community announcement templates.
