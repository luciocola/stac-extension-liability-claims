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
