# GitHub Pages Deployment Guide

## Overview

The `gh-pages` folder contains the published version of the STAC Liability and Claims Extension for GitHub Pages hosting. This structure ensures:

1. **Version Isolation**: Each version (v1.1.0, v1.2.0) is in a separate directory
2. **Backward Compatibility**: v1.1.0 users are NOT affected by v1.2.0 updates
3. **Stable URLs**: Schema URLs remain permanent (e.g., `.../v1.1.0/schema.json`)

## Directory Structure

```
gh-pages/
├── index.html              # Landing page with version selector
├── v1.1.0/                 # Version 1.1.0 (STABLE - UNCHANGED)
│   ├── schema.json         # Main schema
│   ├── README.md           # Documentation
│   └── examples/           # Example STAC Items
│       ├── item.json
│       ├── collection.json
│       └── ...
└── v1.2.0/                 # Version 1.2.0 (LATEST)
    ├── schema.json         # Main schema
    ├── iso19157-quality.json
    ├── prov-ref.json
    ├── iso19115-quality.json
    ├── iso19157-lineage.json
    ├── iso19157-scope.json
    ├── README.md           # Documentation
    └── examples/           # Example STAC Items
        ├── item-with-iso19157-quality.json
        ├── item-with-ceos-ard-optical.json
        ├── item-with-ceos-ard-radar.json
        └── ... (18 examples total)
```

## Schema URLs

### Version 1.1.0 (STABLE)
```
https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json
```

### Version 1.2.0 (LATEST)
```
https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json
```

## Publishing to GitHub Pages

### Option 1: Using gh-pages branch (Recommended)

```bash
# 1. Navigate to repository
cd /path/to/stac-extension-liability-claims

# 2. Create gh-pages branch if it doesn't exist
git checkout --orphan gh-pages

# 3. Remove all files
git rm -rf .

# 4. Copy gh-pages folder contents to root
cp -r gh-pages/* .
cp -r gh-pages/.* . 2>/dev/null || true

# 5. Remove gh-pages folder (now redundant in gh-pages branch)
rm -rf gh-pages/

# 6. Commit and push
git add .
git commit -m "Deploy v1.2.0 to GitHub Pages"
git push origin gh-pages

# 7. Return to main branch
git checkout main
```

### Option 2: Using GitHub Actions (Automated)

Create `.github/workflows/deploy-gh-pages.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
    paths:
      - 'gh-pages/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./gh-pages
          keep_files: true  # Preserve previous versions
```

### Option 3: Manual Copy (Simple)

1. Go to GitHub repository settings
2. Enable GitHub Pages
3. Select source: `gh-pages` branch, `/` (root) folder
4. Copy files manually to `gh-pages` branch

## Enabling GitHub Pages

1. Go to repository: `https://github.com/luciocola/stac-extension-liability-claims`
2. Click **Settings** → **Pages**
3. Under **Source**, select:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
4. Click **Save**
5. Wait 1-2 minutes for deployment
6. Visit: `https://luciocola.github.io/stac-extension-liability-claims/`

## Verifying Deployment

```bash
# Check index page
curl https://luciocola.github.io/stac-extension-liability-claims/

# Check v1.1.0 schema
curl https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json

# Check v1.2.0 schema
curl https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json

# Validate STAC Item against v1.2.0
curl -X POST https://stac-utils.github.io/stac-check/ \
  -d '{"url": "https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/examples/item-with-iso19157-quality.json"}'
```

## Impact on Existing Users (v1.1.0)

### ✅ NO IMPACT on v1.1.0 Users

**Reason**: Version isolation ensures v1.1.0 remains unchanged:

1. **Separate URLs**: 
   - v1.1.0: `.../v1.1.0/schema.json`
   - v1.2.0: `.../v1.2.0/schema.json`

2. **No Breaking Changes**: v1.1.0 schema is copied AS-IS, no modifications

3. **Permanent URLs**: v1.1.0 URLs will never change

4. **Independent Versioning**: Each version is self-contained

### Example: Existing User Workflow

```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json"
  ]
}
```

**This will continue to work forever** - no changes needed when v1.2.0 is published.

## Migration from v1.1.0 to v1.2.0

Users can migrate when ready:

```json
{
  "stac_extensions": [
    "https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json"
  ]
}
```

**100% backward compatible** - all v1.1.0 items validate against v1.2.0.

See [ISO-TC211-ALIGNMENT.md](../ISO-TC211-ALIGNMENT.md) for migration guide.

## Updating Versions

### Adding v1.3.0 (Future)

```bash
# 1. Create new version directory
mkdir -p gh-pages/v1.3.0/examples

# 2. Copy schema files
cp json-schema/schema.json gh-pages/v1.3.0/

# 3. Copy examples
cp examples/*.json gh-pages/v1.3.0/examples/

# 4. Update index.html with v1.3.0 card

# 5. Deploy to gh-pages branch (see Option 1 above)
```

### Patching v1.2.0 (Bug Fix)

```bash
# Update files in gh-pages/v1.2.0/
# Redeploy to gh-pages branch
# v1.1.0 remains untouched
```

## Security Considerations

1. **HTTPS**: GitHub Pages uses HTTPS by default
2. **CORS**: All files are accessible via CORS
3. **Immutability**: Published schemas should not change (create new versions instead)
4. **Versioning**: Always use explicit version URLs in production

## Troubleshooting

### Pages not showing up

```bash
# Check GitHub Pages status
# Settings → Pages → Check if green checkmark appears

# Common issues:
# 1. Wrong branch selected
# 2. Wrong folder selected (should be / root)
# 3. Deployment in progress (wait 1-2 minutes)
```

### Schema validation fails

```bash
# Ensure schema URLs are correct
# Check HTTPS (not HTTP)
# Verify JSON is valid:
jq . gh-pages/v1.2.0/schema.json
```

### Old version showing

```bash
# Clear browser cache
# Check file timestamps on GitHub
# Verify gh-pages branch is updated
```

## Best Practices

1. **Never modify published schemas** - create new versions instead
2. **Use explicit version URLs** - don't use "latest" or unversioned URLs
3. **Test locally first** - use `python -m http.server` to test gh-pages folder
4. **Keep v1.1.0 frozen** - only update v1.2.0+ going forward
5. **Document breaking changes** - clearly mark in CHANGELOG.md

## Local Testing

```bash
# Serve gh-pages folder locally
cd gh-pages
python3 -m http.server 8000

# Visit: http://localhost:8000/
# Check: http://localhost:8000/v1.2.0/schema.json
```

## Next Steps

1. Deploy to gh-pages branch (see Option 1 above)
2. Enable GitHub Pages in repository settings
3. Update schema URLs in OGC Building Blocks submission
4. Announce v1.2.0 release
5. Update documentation to reference new URLs

---

**Status**: Ready to deploy  
**Impact on v1.1.0**: None (100% isolated)  
**Breaking Changes**: None (backward compatible)
