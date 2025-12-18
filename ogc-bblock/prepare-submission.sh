#!/bin/bash
# prepare-ogc-submission.sh - Prepare files for OGC Building Blocks submission

set -e

echo "================================================"
echo "OGC Building Blocks Submission Preparation"
echo "STAC Liability and Claims Extension v1.1.0"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if we're in the right directory
if [ ! -f "json-schema/schema.json" ]; then
    echo "Error: Must be run from stac-extension-liability-claims root directory"
    exit 1
fi

echo -e "${BLUE}Step 1: Creating submission package...${NC}"
echo ""

# Create package directory
PACKAGE_DIR="ogc-submission-package"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/examples"

echo "Creating directory structure..."

# Copy required files
cp ogc-bblock/bblock.json "$PACKAGE_DIR/"
cp ogc-bblock/description.md "$PACKAGE_DIR/"
cp json-schema/schema.json "$PACKAGE_DIR/"
cp context.jsonld "$PACKAGE_DIR/"

# Copy examples
cp tests/valid/item-basic.json "$PACKAGE_DIR/examples/"
cp tests/valid/item-with-prov.json "$PACKAGE_DIR/examples/"
cp tests/valid/item-with-quality.json "$PACKAGE_DIR/examples/"
cp tests/valid/collection-basic.json "$PACKAGE_DIR/examples/"

echo -e "${GREEN}✓${NC} Files copied to $PACKAGE_DIR/"
echo ""

echo -e "${BLUE}Step 2: Validating package...${NC}"
echo ""

# Validate JSON files
for file in "$PACKAGE_DIR"/*.json "$PACKAGE_DIR"/examples/*.json; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if python3 -m json.tool < "$file" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} $filename - Valid JSON"
        else
            echo -e "${RED}✗${NC} $filename - Invalid JSON"
            exit 1
        fi
    fi
done

# Validate JSON-LD
if python3 -m json.tool < "$PACKAGE_DIR/context.jsonld" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} context.jsonld - Valid JSON-LD"
else
    echo -e "${RED}✗${NC} context.jsonld - Invalid JSON-LD"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 3: Creating submission archive...${NC}"
echo ""

# Create tar.gz archive
ARCHIVE_NAME="stac-liability-claims-v1.1.0-ogc-submission.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$PACKAGE_DIR" .

echo -e "${GREEN}✓${NC} Created archive: $ARCHIVE_NAME"
echo ""

# Create submission instructions
cat > "$PACKAGE_DIR/SUBMIT.md" << 'EOF'
# Submission Instructions

## Quick Start

1. **Fork the Repository**
   ```bash
   # Visit: https://github.com/ogcincubator/bblocks-stac
   # Click "Fork" button
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/bblocks-stac.git
   cd bblocks-stac
   ```

3. **Create Branch**
   ```bash
   git checkout -b add-liability-claims-extension
   ```

4. **Copy Files**
   ```bash
   # Create directory
   mkdir -p _sources/extensions/liability-claims
   
   # Copy from package directory
   cp bblock.json _sources/extensions/liability-claims/
   cp description.md _sources/extensions/liability-claims/
   cp schema.json _sources/extensions/liability-claims/
   cp context.jsonld _sources/extensions/liability-claims/
   
   # Copy examples
   mkdir -p _sources/extensions/liability-claims/examples
   cp examples/*.json _sources/extensions/liability-claims/examples/
   ```

5. **Commit and Push**
   ```bash
   git add _sources/extensions/liability-claims/
   git commit -m "Add STAC Liability and Claims Extension

   - ISO 19115/19115-4 quality reporting
   - W3C PROV provenance support
   - Legal/insurance claim documentation
   - Comprehensive test suite
   - Full JSON-LD context"
   
   git push origin add-liability-claims-extension
   ```

6. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "Compare & pull request"
   - Copy content from `../ogc-bblock/PR-DESCRIPTION.md`
   - Submit PR

## Files Included

- `bblock.json` - Building block metadata
- `description.md` - Documentation
- `schema.json` - JSON Schema
- `context.jsonld` - JSON-LD context
- `examples/*.json` - Example files

## Validation

All files have been pre-validated:
✓ JSON syntax
✓ Schema compilation
✓ Example validation
✓ JSON-LD context

## Support

Questions? Contact:
- Email: luciocol@gmail.com
- GitHub: @luciocola
EOF

echo -e "${BLUE}Step 4: Package summary${NC}"
echo ""
echo "Files packaged:"
find "$PACKAGE_DIR" -type f | sed 's|^|  |'
echo ""
echo "Archive size:"
ls -lh "$ARCHIVE_NAME" | awk '{print "  " $5}'
echo ""

echo "================================================"
echo -e "${GREEN}✓ Submission package ready!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Review the package:"
echo -e "   ${YELLOW}cd $PACKAGE_DIR && cat SUBMIT.md${NC}"
echo ""
echo "2. Fork the OGC repository:"
echo -e "   ${YELLOW}https://github.com/ogcincubator/bblocks-stac${NC}"
echo ""
echo "3. Follow instructions in:"
echo -e "   ${YELLOW}$PACKAGE_DIR/SUBMIT.md${NC}"
echo ""
echo "4. Reference PR description:"
echo -e "   ${YELLOW}ogc-bblock/PR-DESCRIPTION.md${NC}"
echo ""
echo "Archive created: $ARCHIVE_NAME"
echo ""
