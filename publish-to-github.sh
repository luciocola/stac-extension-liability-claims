#!/bin/bash

# Publish to GitHub: https://github.com/luciocola/stac-extension-liability-claims
# Run this script after installing git

echo "========================================="
echo "Publishing to GitHub"
echo "========================================="
echo ""

cd "$(dirname "$0")"

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "ERROR: Git is not installed or not in PATH"
    echo ""
    echo "Please install git first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo "  eval \"\$(/opt/homebrew/bin/brew shellenv)\""
    echo "  brew install git"
    echo ""
    exit 1
fi

# Configure git if needed
if [ -z "$(git config --global user.name)" ]; then
    echo "Configuring git user..."
    git config --global user.name "Lucio Colaiacomo"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "Please enter your email for git commits:"
    read -p "Email: " git_email
    git config --global user.email "$git_email"
fi

# Initialize repository if needed
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    git branch -M main
fi

# Add all files
echo "Adding files..."
git add .

# Check if there are changes to commit
if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "No changes to commit"
else
    echo "Committing changes..."
    git commit -m "STAC Liability and Claims Extension v1.2.0

Features:
- ISO 19157-1:2023 data quality support (completeness, accuracy, consistency)
- ISO 19115 lineage tracking with processing history
- W3C PROV provenance integration for semantic web
- W3C Verifiable Credentials 2.0 support with cryptographic proofs
- NASA UMM metadata compatibility
- OGC compliance for defense and emergency response
- Comprehensive documentation and examples

New in v1.2.0:
- Verifiable Credentials 2.0 integration (VC-2.0-INTEGRATION.md)
- liability:verifiable_credentials field for cryptographically signed assertions
- Support for EdDSA, ECDSA, BBS+ cryptographic suites
- DID integration (did:web, did:key, did:ion)
- Selective disclosure capabilities
- Example STAC items with verifiable quality and provenance credentials" || \
    git commit -m "Update STAC Liability and Claims Extension with VC 2.0 support"
fi

# Add remote if not exists
if ! git remote | grep -q origin; then
    echo "Adding GitHub remote..."
    git remote add origin https://github.com/luciocola/stac-extension-liability-claims.git
else
    echo "Remote 'origin' already exists"
    git remote set-url origin https://github.com/luciocola/stac-extension-liability-claims.git
fi

# Push to GitHub
echo ""
echo "Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✓ Successfully published to GitHub!"
    echo "========================================="
    echo ""
    echo "Repository URL:"
    echo "  https://github.com/luciocola/stac-extension-liability-claims"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://github.com/luciocola/stac-extension-liability-claims"
    echo "2. Add topics: stac, stac-extension, geospatial, provenance, data-quality"
    echo "3. (Optional) Submit to official STAC extensions registry:"
    echo "   https://github.com/stac-extensions/stac-extensions.github.io"
else
    echo ""
    echo "========================================="
    echo "Push failed!"
    echo "========================================="
    echo ""
    echo "If the repository doesn't exist on GitHub:"
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: stac-extension-liability-claims"
    echo "3. Make it Public"
    echo "4. DO NOT initialize with README"
    echo "5. Click 'Create repository'"
    echo "6. Run this script again"
    echo ""
    echo "If you need to authenticate:"
    echo "  git push -u origin main"
fi
