#!/bin/bash

# STAC Extension Liability Claims - Git Setup Script
# This script initializes the git repository and prepares it for GitHub

echo "========================================="
echo "Git Setup for stac-extension-liability-claims"
echo "========================================="
echo ""

# Step 1: Install Homebrew (if not installed)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi

# Step 2: Install Git
if ! command -v git &> /dev/null; then
    echo "Installing Git via Homebrew..."
    brew install git
else
    echo "✓ Git already installed"
fi

# Step 3: Configure Git (if not already configured)
if [ -z "$(git config --global user.name)" ]; then
    echo ""
    read -p "Enter your name for Git commits: " git_name
    git config --global user.name "$git_name"
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Enter your email for Git commits: " git_email
    git config --global user.email "$git_email"
fi

echo ""
echo "Git configuration:"
echo "  Name: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"

# Step 4: Initialize repository
cd "$(dirname "$0")"
if [ ! -d .git ]; then
    echo ""
    echo "Initializing Git repository..."
    git init
    echo "✓ Repository initialized"
else
    echo "✓ Git repository already exists"
fi

# Step 5: Add all files
echo ""
echo "Adding files to git..."
git add .

# Step 6: Create initial commit
if [ -z "$(git log 2>/dev/null)" ]; then
    echo "Creating initial commit..."
    git commit -m "Initial commit: STAC Liability and Claims Extension v1.2.0

- ISO 19157-1:2023 data quality support
- ISO 19115 lineage tracking
- W3C PROV provenance integration
- W3C Verifiable Credentials 2.0 support
- NASA UMM compatibility
- OGC compliance for defense/emergency response
- Comprehensive documentation and examples"
    echo "✓ Initial commit created"
else
    echo "Committing changes..."
    git commit -m "Update: Add Verifiable Credentials 2.0 integration

- Added VC-2.0-INTEGRATION.md comprehensive guide
- Added liability:verifiable_credentials field
- Updated README.md with VC 2.0 support
- Created example with verifiable quality and provenance credentials
- Support for EdDSA, ECDSA, BBS+ cryptographic proofs
- DID integration (did:web, did:key, did:ion)
- Selective disclosure capabilities"
    echo "✓ Changes committed"
fi

# Step 7: Instructions for GitHub
echo ""
echo "========================================="
echo "Next Steps:"
echo "========================================="
echo ""
echo "1. Create a new repository on GitHub:"
echo "   - Go to: https://github.com/new"
echo "   - Repository name: stac-extension-liability-claims"
echo "   - Description: STAC Extension for Liability Claims, Data Quality (ISO 19157), and Provenance (W3C PROV, Verifiable Credentials 2.0)"
echo "   - Make it Public (recommended for STAC extensions)"
echo "   - DO NOT initialize with README, .gitignore, or license (we already have these)"
echo ""
echo "2. After creating the repository, run these commands:"
echo "   cd $(pwd)"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/YOUR_USERNAME/stac-extension-liability-claims.git"
echo "   git push -u origin main"
echo ""
echo "3. (Optional) To submit to official STAC extensions registry:"
echo "   - Create a pull request to: https://github.com/stac-extensions/stac-extensions.github.io"
echo "   - Add your extension to the registry"
echo ""
echo "========================================="
echo "Setup complete!"
echo "========================================="
