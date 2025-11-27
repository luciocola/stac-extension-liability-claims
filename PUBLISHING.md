# Publishing to GitHub - Instructions

## Quick Setup

Your STAC Liability and Claims Extension is ready to be published! Follow these steps:

### Option 1: Using GitHub Web Interface (Recommended)

1. **Create a new repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `stac-extension-liability-claims`
   - Description: `STAC Extension for Liability and Claims Management - Track incidents, damages, legal proceedings, and insurance claims with secure asset access control`
   - Choose: **Public**
   - Do NOT initialize with README, .gitignore, or license (we already have these)
   - Click "Create repository"

2. **Push your local repository:**
   ```bash
   cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims
   git remote add origin https://github.com/YOUR_USERNAME/stac-extension-liability-claims.git
   git branch -M main
   git push -u origin main
   ```

3. **Configure repository settings:**
   - Go to repository Settings → Pages
   - Enable GitHub Pages from the `main` branch (optional, for documentation)
   - Add topics: `stac`, `stac-extension`, `geospatial`, `liability`, `claims`, `insurance`

### Option 2: Using GitHub CLI

If you want to install GitHub CLI first:

```bash
# Install GitHub CLI (macOS)
brew install gh

# Authenticate
gh auth login

# Create and push repository
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims
gh repo create stac-extension-liability-claims --public --source=. \
  --description="STAC Extension for Liability and Claims Management - Track incidents, damages, legal proceedings, and insurance claims with secure asset access control" \
  --push
```

## After Publishing

### 1. Update Repository URLs

After creating the repository, update these files with your actual GitHub username:

**README.md**: Replace `@yourusername` with your GitHub handle

**package.json** and **pyproject.toml**: Update repository URLs from:
```
https://github.com/yourusername/stac-extension-liability-claims
```
to:
```
https://github.com/YOUR_ACTUAL_USERNAME/stac-extension-liability-claims
```

### 2. Add Repository Topics

Add these topics to make your extension discoverable:
- `stac`
- `stac-extension`
- `geospatial`
- `liability`
- `claims`
- `insurance`
- `legal`
- `environmental`

### 3. Create Initial Release

```bash
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release of STAC Liability and Claims Extension"
git push origin v1.0.0
```

Then create a GitHub release:
- Go to Releases → Create a new release
- Choose tag: v1.0.0
- Release title: `v1.0.0 - Initial Release`
- Copy description from CHANGELOG.md
- Publish release

### 4. Optional: Submit to STAC Extensions Registry

To make this an official STAC extension:

1. Fork https://github.com/stac-extensions/stac-extensions.github.io
2. Add your extension to the registry
3. Submit a pull request

See: https://github.com/stac-extensions/stac-extensions.github.io/blob/main/CONTRIBUTING.md

## Repository Structure

Your repository includes:

```
stac-extension-liability-claims/
├── .gitignore              # Git ignore rules
├── LICENSE                 # Apache 2.0 license
├── README.md              # Main documentation
├── CHANGELOG.md           # Version history
├── CONTRIBUTING.md        # Contribution guidelines
├── package.json           # NPM package config
├── pyproject.toml         # Python package config
├── validate.py            # Python validation script
├── validate-all.sh        # Batch validation script
├── json-schema/
│   └── schema.json        # JSON Schema definition
└── examples/
    ├── collection.json
    ├── item-environmental.json
    ├── item-property-damage.json
    └── item-with-auth.json
```

## Next Steps

1. Publish to GitHub (see instructions above)
2. Update URLs with your actual username
3. Create v1.0.0 release
4. Share with the STAC community
5. Consider submitting to official STAC extensions registry

## Support

If you encounter issues:
- Check GitHub's documentation: https://docs.github.com/en/get-started
- STAC community: https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby
