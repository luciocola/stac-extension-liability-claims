#!/bin/bash

# STAC Extension Registration - Automated Setup Script
# This script prepares the repository structure for official STAC extension registration

set -e  # Exit on error

echo "=================================================="
echo "STAC Extension Registration Setup"
echo "Extension: Liability and Claims"
echo "Version: 1.1.0"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "json-schema/schema.json" ]; then
    echo "❌ Error: Must run from stac-extension-liability-claims directory"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo "✓ Found schema file"
echo ""

# Step 1: Create v1.1.0 directory structure for GitHub Pages
echo "Step 1: Creating version directory structure..."
mkdir -p v1.1.0/examples

# Copy main schema
cp json-schema/schema.json v1.1.0/
echo "  ✓ Copied schema.json"

# Copy README
cp README.md v1.1.0/
echo "  ✓ Copied README.md"

# Copy CHANGELOG
cp CHANGELOG.md v1.1.0/
echo "  ✓ Copied CHANGELOG.md"

# Copy examples
cp examples/*.json v1.1.0/examples/ 2>/dev/null || echo "  ⚠ No examples to copy"
echo "  ✓ Copied examples"

# Copy JSON-LD context to root (required for GitHub Pages)
cp context.jsonld ./ 2>/dev/null || echo "  ⚠ No context.jsonld found"
echo "  ✓ Copied context.jsonld to root"

echo ""

# Step 2: Create GitHub Pages index.html
echo "Step 2: Creating GitHub Pages landing page..."
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STAC Liability and Claims Extension</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            line-height: 1.6;
            color: #24292e;
        }
        h1 {
            border-bottom: 1px solid #eaecef;
            padding-bottom: 0.3em;
        }
        .badges {
            margin: 20px 0;
        }
        .badge {
            display: inline-block;
            padding: 3px 7px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 3px;
            margin-right: 5px;
        }
        .badge-maturity { background: #0969da; color: white; }
        .badge-version { background: #1a7f37; color: white; }
        .badge-license { background: #8250df; color: white; }
        code {
            background: #f6f8fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
            font-size: 85%;
        }
        .links {
            background: #f6f8fa;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
            margin: 20px 0;
        }
        .links a {
            color: #0969da;
            text-decoration: none;
            display: block;
            margin: 8px 0;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .feature {
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
        }
        .feature h3 {
            margin-top: 0;
            color: #0969da;
        }
    </style>
</head>
<body>
    <h1>🛡️ STAC Liability and Claims Extension</h1>
    
    <div class="badges">
        <span class="badge badge-maturity">Maturity: Proposal</span>
        <span class="badge badge-version">Version: 1.1.0</span>
        <span class="badge badge-license">License: Apache-2.0</span>
    </div>

    <p>
        STAC Extension for documenting liability information, insurance claims, and legal proceedings 
        associated with geospatial data assets. Includes comprehensive support for data quality 
        (ISO 19157-1:2023, ISO 19115/19115-4) and provenance tracking (W3C PROV, Verifiable Credentials 2.0).
    </p>

    <div class="links">
        <h3>📚 Documentation</h3>
        <a href="v1.1.0/README.html">📖 Extension Specification</a>
        <a href="v1.1.0/schema.json">📄 JSON Schema</a>
        <a href="v1.1.0/CHANGELOG.html">📝 Changelog</a>
        <a href="context.jsonld">🔗 JSON-LD Context</a>
    </div>

    <div class="links">
        <h3>💻 Code & Examples</h3>
        <a href="https://github.com/stac-extensions/liability-claims">GitHub Repository</a>
        <a href="v1.1.0/examples/">Example STAC Items & Collections</a>
        <a href="https://github.com/stac-extensions/liability-claims/issues">Issue Tracker</a>
    </div>

    <div class="features">
        <div class="feature">
            <h3>📊 Data Quality</h3>
            <ul>
                <li>ISO 19157-1:2023 (RECOMMENDED)</li>
                <li>ISO 19115/19115-4</li>
                <li>Standardized quality measures</li>
                <li>Metaquality assessment</li>
            </ul>
        </div>

        <div class="feature">
            <h3>🔍 Provenance</h3>
            <ul>
                <li>W3C PROV-DM</li>
                <li>Semantic web integration</li>
                <li>SPARQL queries</li>
                <li>ISO 19115 lineage</li>
            </ul>
        </div>

        <div class="feature">
            <h3>✅ Verification</h3>
            <ul>
                <li>W3C Verifiable Credentials 2.0</li>
                <li>Cryptographic signatures</li>
                <li>Selective disclosure</li>
                <li>Tamper evidence</li>
            </ul>
        </div>

        <div class="feature">
            <h3>⚖️ Legal & Claims</h3>
            <ul>
                <li>Insurance claims</li>
                <li>Damage assessment</li>
                <li>Responsible parties</li>
                <li>Legal proceedings</li>
            </ul>
        </div>
    </div>

    <h2>🚀 Usage</h2>
    <p>Add the extension to your STAC Item or Collection:</p>
    <pre><code>{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "properties": {
    "liability:claim_id": "CLAIM-2025-001",
    "liability:responsible_party": "Acme Geospatial Inc.",
    "liability:quality": { ... }
  }
}</code></pre>

    <h2>📋 Standards Compliance</h2>
    <ul>
        <li>✅ ISO 19157-1:2023 (Geographic information - Data quality)</li>
        <li>✅ ISO 19115/19115-4 (Geographic information - Metadata)</li>
        <li>✅ W3C PROV (Provenance Data Model)</li>
        <li>✅ W3C Verifiable Credentials 2.0</li>
        <li>✅ OGC Building Blocks compliant</li>
        <li>✅ T21-DQ4IPT compatible</li>
    </ul>

    <h2>📞 Contact</h2>
    <p>
        <strong>Owner:</strong> @luciocola<br>
        <strong>Organization:</strong> Secure Dimensions<br>
        <strong>Support:</strong> <a href="https://github.com/stac-extensions/liability-claims/issues">GitHub Issues</a>
    </p>

    <footer style="margin-top: 60px; padding-top: 20px; border-top: 1px solid #eaecef; color: #57606a; font-size: 14px;">
        <p>Part of the <a href="https://stacspec.org/">STAC Extensions</a> ecosystem</p>
    </footer>
</body>
</html>
EOF
echo "  ✓ Created index.html"
echo ""

# Step 3: Create GitHub repository topics file
echo "Step 3: Creating repository configuration..."
cat > .github-topics.txt << 'EOF'
stac
stac-extension
geospatial
liability
claims
insurance
data-quality
iso-19157
iso-19115
provenance
w3c-prov
verifiable-credentials
legal-compliance
ogc
stac-api
EOF
echo "  ✓ Created .github-topics.txt"
echo ""

# Step 4: Create GitHub repository description
cat > .github-description.txt << 'EOF'
STAC Extension for Liability Claims, Data Quality (ISO 19157/19115), and Provenance (W3C PROV, Verifiable Credentials)
EOF
echo "  ✓ Created .github-description.txt"
echo ""

# Step 5: Update package.json with correct repository URL
echo "Step 4: Updating package.json..."
cat > package.json << 'EOF'
{
  "name": "stac-liability-claims",
  "version": "1.1.0",
  "description": "STAC Extension for Liability and Claims Management with ISO 19157 Quality and W3C PROV Provenance",
  "main": "v1.1.0/schema.json",
  "scripts": {
    "test": "npm run check-markdown && npm run check-examples",
    "check-markdown": "remark . -qf --no-stdout",
    "check-examples": "node scripts/validate-examples.js",
    "format-examples": "prettier --write examples/*.json v1.1.0/examples/*.json"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/stac-extensions/liability-claims.git"
  },
  "keywords": [
    "stac",
    "stac-extension",
    "geospatial",
    "liability",
    "claims",
    "insurance",
    "data-quality",
    "iso-19157",
    "iso-19115",
    "provenance",
    "w3c-prov",
    "verifiable-credentials"
  ],
  "author": "Lucio Colaiacomo <lucio@secure-dimensions.de>",
  "license": "Apache-2.0",
  "bugs": {
    "url": "https://github.com/stac-extensions/liability-claims/issues"
  },
  "homepage": "https://stac-extensions.github.io/liability-claims/",
  "devDependencies": {
    "@stac-extensions/validate": "^1.0.0",
    "ajv": "^8.12.0",
    "prettier": "^3.0.0",
    "remark-cli": "^11.0.0",
    "remark-preset-lint-recommended": "^6.1.3"
  }
}
EOF
echo "  ✓ Updated package.json"
echo ""

# Step 6: Create/update .gitignore
echo "Step 5: Updating .gitignore..."
cat >> .gitignore << 'EOF'

# GitHub Pages
_site/
.jekyll-cache/
.jekyll-metadata

# Node
node_modules/
package-lock.json

# Python
__pycache__/
*.pyc
.pytest_cache/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
echo "  ✓ Updated .gitignore"
echo ""

# Step 7: Create GitHub Actions workflow
echo "Step 6: Creating GitHub Actions workflow..."
mkdir -p .github/workflows

cat > .github/workflows/validate.yml << 'EOF'
name: Validate Extension

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'
    
    - name: Install dependencies
      run: |
        pip install jsonschema
        pip install pystac
        pip install requests
    
    - name: Validate JSON Schema
      run: |
        python -c "
        import json
        from jsonschema import Draft7Validator
        
        with open('v1.1.0/schema.json') as f:
            schema = json.load(f)
        
        validator = Draft7Validator(schema)
        errors = list(validator.iter_errors(schema))
        
        if errors:
            for error in errors:
                print(f'Schema error: {error.message}')
            exit(1)
        else:
            print('✓ Schema is valid')
        "
    
    - name: Validate Examples
      run: |
        for file in v1.1.0/examples/*.json; do
          echo "Validating $file..."
          python -c "
        import json
        import sys
        
        with open('$file') as f:
            item = json.load(f)
        
        # Basic STAC validation
        if 'stac_extensions' not in item:
            print('Missing stac_extensions')
            sys.exit(1)
            
        ext_url = 'https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json'
        if ext_url not in item.get('stac_extensions', []):
            print(f'Extension {ext_url} not declared')
            sys.exit(1)
        
        print('✓ Valid STAC Item/Collection')
          "
        done
    
    - name: Check README
      run: |
        if [ ! -f "v1.1.0/README.md" ]; then
          echo "❌ Missing README.md"
          exit 1
        fi
        echo "✓ README.md exists"
    
    - name: Check CHANGELOG
      run: |
        if [ ! -f "v1.1.0/CHANGELOG.md" ]; then
          echo "❌ Missing CHANGELOG.md"
          exit 1
        fi
        echo "✓ CHANGELOG.md exists"
EOF
echo "  ✓ Created GitHub Actions workflow"
echo ""

# Summary
echo "=================================================="
echo "✅ Setup Complete!"
echo "=================================================="
echo ""
echo "Repository structure created for STAC extension registration:"
echo ""
echo "📁 File Structure:"
echo "  ├── v1.1.0/                  # Version directory for GitHub Pages"
echo "  │   ├── schema.json          # Main schema"
echo "  │   ├── README.md            # Documentation"
echo "  │   ├── CHANGELOG.md         # Version history"
echo "  │   └── examples/            # Example files"
echo "  ├── index.html               # GitHub Pages landing page"
echo "  ├── context.jsonld           # JSON-LD context (root)"
echo "  ├── package.json             # npm package metadata"
echo "  ├── .github/workflows/       # CI/CD automation"
echo "  └── .github-*.txt            # Repository configuration"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Review the created files"
echo "2. Commit changes:"
echo "   git add ."
echo "   git commit -m 'Prepare for STAC extension registration'"
echo ""
echo "3. Push to GitHub:"
echo "   git push"
echo ""
echo "4. Follow the registration guide:"
echo "   cat STAC-EXTENSION-REGISTRATION.md"
echo ""
echo "=================================================="
echo ""
echo "🔗 Useful URLs (after registration):"
echo ""
echo "  Repository:   https://github.com/stac-extensions/liability-claims"
echo "  GitHub Pages: https://stac-extensions.github.io/liability-claims/"
echo "  Schema:       https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
echo "  Registry:     https://stac-extensions.github.io/"
echo ""
echo "=================================================="
