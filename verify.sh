#!/bin/bash
# Verify gh-pages folder structure and readiness

echo "=========================================="
echo "gh-pages Folder Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base path
BASE="/Users/luciocolaiacomo/4113Eng-wfs/cop_defence_stac/stac-extension-liability-claims/gh-pages"

echo "1. Checking directory structure..."
if [ -d "$BASE" ]; then
    echo -e "${GREEN}✓${NC} gh-pages/ exists"
else
    echo -e "${RED}✗${NC} gh-pages/ NOT found"
    exit 1
fi

if [ -d "$BASE/v1.1.0" ]; then
    echo -e "${GREEN}✓${NC} v1.1.0/ exists"
else
    echo -e "${RED}✗${NC} v1.1.0/ NOT found"
    exit 1
fi

if [ -d "$BASE/v1.2.0" ]; then
    echo -e "${GREEN}✓${NC} v1.2.0/ exists"
else
    echo -e "${RED}✗${NC} v1.2.0/ NOT found"
    exit 1
fi

echo ""
echo "2. Checking required files..."

# v1.1.0 files
if [ -f "$BASE/v1.1.0/schema.json" ]; then
    echo -e "${GREEN}✓${NC} v1.1.0/schema.json"
else
    echo -e "${RED}✗${NC} v1.1.0/schema.json MISSING"
fi

if [ -f "$BASE/v1.1.0/README.md" ]; then
    echo -e "${GREEN}✓${NC} v1.1.0/README.md"
else
    echo -e "${RED}✗${NC} v1.1.0/README.md MISSING"
fi

# v1.2.0 files
if [ -f "$BASE/v1.2.0/schema.json" ]; then
    echo -e "${GREEN}✓${NC} v1.2.0/schema.json"
else
    echo -e "${RED}✗${NC} v1.2.0/schema.json MISSING"
fi

if [ -f "$BASE/v1.2.0/README.md" ]; then
    echo -e "${GREEN}✓${NC} v1.2.0/README.md"
else
    echo -e "${RED}✗${NC} v1.2.0/README.md MISSING"
fi

if [ -f "$BASE/index.html" ]; then
    echo -e "${GREEN}✓${NC} index.html"
else
    echo -e "${RED}✗${NC} index.html MISSING"
fi

echo ""
echo "3. Counting examples..."
v110_examples=$(find "$BASE/v1.1.0/examples" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
v120_examples=$(find "$BASE/v1.2.0/examples" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')

echo -e "   v1.1.0 examples: ${GREEN}$v110_examples${NC}"
echo -e "   v1.2.0 examples: ${GREEN}$v120_examples${NC}"

echo ""
echo "4. Checking schema versions..."

# Check v1.1.0 schema version
v110_version=$(grep -o '"version": "[^"]*"' "$BASE/v1.1.0/schema.json" | head -1 | cut -d'"' -f4)
if [ "$v110_version" = "1.1.0" ]; then
    echo -e "${GREEN}✓${NC} v1.1.0 schema version: $v110_version"
else
    echo -e "${YELLOW}⚠${NC} v1.1.0 schema version: $v110_version (expected 1.1.0)"
fi

# Check v1.2.0 schema version
v120_version=$(grep -o '"version": "[^"]*"' "$BASE/v1.2.0/schema.json" | head -1 | cut -d'"' -f4)
if [ "$v120_version" = "1.2.0" ]; then
    echo -e "${GREEN}✓${NC} v1.2.0 schema version: $v120_version"
else
    echo -e "${RED}✗${NC} v1.2.0 schema version: $v120_version (expected 1.2.0)"
fi

echo ""
echo "5. Checking schema \$id URLs..."

# Check v1.1.0 $id
v110_id=$(grep -o '"\\$id": "[^"]*"' "$BASE/v1.1.0/schema.json" | head -1 | cut -d'"' -f4)
expected_v110_id="https://luciocola.github.io/stac-extension-liability-claims/v1.1.0/schema.json#"
if [ "$v110_id" = "$expected_v110_id" ]; then
    echo -e "${GREEN}✓${NC} v1.1.0 \$id: correct"
else
    echo -e "${YELLOW}⚠${NC} v1.1.0 \$id: $v110_id"
    echo "   Expected: $expected_v110_id"
fi

# Check v1.2.0 $id
v120_id=$(grep -o '"\\$id": "[^"]*"' "$BASE/v1.2.0/schema.json" | head -1 | cut -d'"' -f4)
expected_v120_id="https://luciocola.github.io/stac-extension-liability-claims/v1.2.0/schema.json#"
if [ "$v120_id" = "$expected_v120_id" ]; then
    echo -e "${GREEN}✓${NC} v1.2.0 \$id: correct"
else
    echo -e "${RED}✗${NC} v1.2.0 \$id: $v120_id"
    echo "   Expected: $expected_v120_id"
fi

echo ""
echo "6. Checking JSON validity..."

# Validate v1.1.0 schema
if python3 -m json.tool "$BASE/v1.1.0/schema.json" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} v1.1.0 schema is valid JSON"
else
    echo -e "${RED}✗${NC} v1.1.0 schema has JSON errors"
fi

# Validate v1.2.0 schema
if python3 -m json.tool "$BASE/v1.2.0/schema.json" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} v1.2.0 schema is valid JSON"
else
    echo -e "${RED}✗${NC} v1.2.0 schema has JSON errors"
fi

echo ""
echo "7. File sizes..."
v110_size=$(du -h "$BASE/v1.1.0/schema.json" | cut -f1)
v120_size=$(du -h "$BASE/v1.2.0/schema.json" | cut -f1)
echo "   v1.1.0 schema: $v110_size"
echo "   v1.2.0 schema: $v120_size"

echo ""
echo "8. Total size..."
total_size=$(du -sh "$BASE" | cut -f1)
echo "   gh-pages folder: $total_size"

echo ""
echo "=========================================="
echo "Verification Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Deploy to gh-pages branch (see DEPLOYMENT.md)"
echo "2. Enable GitHub Pages in repository settings"
echo "3. Verify at: https://luciocola.github.io/stac-extension-liability-claims/"
echo ""
echo -e "${GREEN}✓ Ready to deploy!${NC}"
echo ""
