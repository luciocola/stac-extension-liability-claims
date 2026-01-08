# Quick Publish Guide

## Step 1: Install Git (if not installed)

Open a new Terminal window and run:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Git
brew install git
```

## Step 2: Run the Publish Script

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

bash publish-to-github.sh
```

## Or Run Commands Manually

If you prefer to run commands step-by-step:

```bash
cd /Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims

# Configure git
git config --global user.name "Lucio Colaiacomo"
git config --global user.email "your.email@example.com"

# Initialize and commit
git init
git branch -M main
git add .
git commit -m "STAC Liability and Claims Extension v1.2.0 with VC 2.0 support"

# Push to GitHub
git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git
git push -u origin main
```

## If Repository Doesn't Exist

1. Go to: https://github.com/new
2. Repository name: `stac-extension-liability-claims`
3. Description: `STAC Extension for Liability Claims, Data Quality (ISO 19157), and Provenance (W3C PROV, Verifiable Credentials 2.0)`
4. Make it **Public**
5. **DO NOT** check "Add a README file"
6. Click "Create repository"
7. Then run the publish script again

## After Publishing

Repository will be available at:
**https://github.com/luciocola/stac-extension-liability-claims**

Add these topics to your repository:
- stac
- stac-extension
- geospatial
- provenance
- data-quality
- verifiable-credentials
- iso-19157
- w3c-prov
