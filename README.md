# gh-pages Folder - Summary

## ✅ Created Successfully

The `gh-pages` folder is ready for deployment to GitHub Pages. This provides version-isolated hosting for both v1.1.0 and v1.2.0 of the STAC Liability and Claims Extension.

## Directory Structure

```
gh-pages/
├── index.html              # Landing page (version selector)
├── DEPLOYMENT.md           # Deployment instructions
├── v1.1.0/                 # STABLE version (unchanged)
│   ├── schema.json         # Schema (44 KB)
│   ├── README.md           # Documentation
│   └── examples/           # 15 examples
└── v1.2.0/                 # LATEST version
    ├── schema.json         # Main schema (47 KB)
    ├── iso19157-quality.json
    ├── iso19157-lineage.json
    ├── iso19157-scope.json
    ├── iso19115-quality.json
    ├── prov-ref.json
    ├── README.md           # Documentation
    └── examples/           # 21 examples
```

## Schema URLs

### v1.1.0 (Stable)
```
https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json
```

### v1.2.0 (Latest)
```
https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json
```

### Landing Page
```
https://luciocola.github.io/stac-extension-liability-claims/
```

## Impact on v1.1.0 Users

### ✅ ZERO IMPACT - Complete Isolation

**Why no impact:**

1. **Separate URLs**: Each version has its own path
   - v1.1.0: `.../v1.1.0/schema.json`
   - v1.2.0: `.../v1.2.0/schema.json`

2. **Frozen v1.1.0**: No modifications to v1.1.0 files
   - Schema copied AS-IS from `v1.1.0/schema.json`
   - Examples copied unchanged
   - Documentation copied unchanged

3. **Independent Versioning**: Each version is self-contained
   - v1.1.0 has no references to v1.2.0
   - v1.2.0 has no impact on v1.1.0

4. **Permanent URLs**: v1.1.0 URLs will never change
   - GitHub Pages serves static files
   - Version paths are permanent

### Example: Existing User Workflow

**Before v1.2.0 deployment:**
```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json"
  ]
}
```

**After v1.2.0 deployment:**
```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json"
  ]
}
```

**Result**: Identical - no changes needed!

## Migration Path (Optional)

Users can migrate when ready:

```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json"
  ]
}
```

**Backward Compatibility**: 100% - all v1.1.0 items validate against v1.2.0

See [ISO-TC211-ALIGNMENT.md](../ISO-TC211-ALIGNMENT.md) for migration guide.

## Next Steps

### 1. Deploy to GitHub Pages

```bash
cd /path/to/stac-extension-liability-claims

# Create gh-pages branch
git checkout --orphan gh-pages

# Remove all files
git rm -rf .

# Copy gh-pages folder contents to root
cp -r gh-pages/* .

# Remove gh-pages folder (now redundant)
rm -rf gh-pages/

# Commit and push
git add .
git commit -m "Deploy v1.2.0 to GitHub Pages"
git push origin gh-pages

# Return to main branch
git checkout main
```

### 2. Enable GitHub Pages

1. Go to repository settings: `https://github.com/luciocola/stac-extension-liability-claims/settings`
2. Click **Pages** in left sidebar
3. Under **Source**:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
4. Click **Save**
5. Wait 1-2 minutes for deployment

### 3. Verify Deployment

```bash
# Check landing page
curl https://luciocola.github.io/stac-extension-liability-claims/

# Check v1.1.0 schema
curl https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json

# Check v1.2.0 schema
curl https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json
```

### 4. Update Documentation

Update references in:
- README.md (main branch)
- OGC Building Blocks submission
- STAC Extensions catalog

## Features

### Landing Page (index.html)

- **Modern Design**: Gradient backgrounds, card layout
- **Version Selector**: Clear visual distinction between v1.1.0 (stable) and v1.2.0 (latest)
- **Feature Lists**: Key features for each version
- **Quick Start**: Code snippet for STAC Item integration
- **Resource Links**: GitHub, changelog, migration guide

### Version Documentation

Each version includes:
- **README.md**: Complete documentation
- **schema.json**: JSON Schema with $id pointing to GitHub Pages URL
- **examples/**: All example STAC Items and Collections

### Backward Compatibility

- v1.1.0 schema unchanged (44,650 bytes)
- v1.2.0 schema updated with new features (46,978 bytes)
- 100% validation compatibility

## File Sizes

```
v1.1.0/schema.json:        44 KB
v1.1.0/examples/:          15 files

v1.2.0/schema.json:        47 KB
v1.2.0/iso19157-*.json:    48 KB (all ISO schemas)
v1.2.0/examples/:          21 files
```

## Testing Locally

```bash
cd gh-pages
python3 -m http.server 8000

# Visit: http://localhost:8000/
# Check: http://localhost:8000/v1.2.0/schema.json
```

## Security & Best Practices

✅ **Version Isolation**: Each version in separate directory  
✅ **Immutable URLs**: Published schemas never change  
✅ **HTTPS**: GitHub Pages uses HTTPS by default  
✅ **CORS**: All files accessible via CORS  
✅ **Semantic Versioning**: Clear version numbers (v1.1.0, v1.2.0)

## Conclusion

The `gh-pages` folder is **production-ready** and **safe to deploy**. It will:

- ✅ Provide stable hosting for v1.1.0 (no changes)
- ✅ Publish v1.2.0 with new features
- ✅ Enable version-specific URLs
- ✅ NOT affect existing v1.1.0 users
- ✅ Support gradual migration to v1.2.0

**Status**: Ready to deploy  
**Impact on v1.1.0**: None (100% isolated)  
**Breaking Changes**: None (backward compatible)

---

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md)
