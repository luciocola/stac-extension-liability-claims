# Validation Tests

This directory contains validation tests for the Liability and Claims STAC Extension.

## Test Structure

Each test follows the OGC Building Blocks pattern:

```
tests/
├── valid/              # Valid examples that should pass validation
│   ├── item-basic.json
│   ├── item-with-prov.json
│   ├── item-with-quality.json
│   └── collection-basic.json
├── invalid/            # Invalid examples that should fail validation
│   ├── missing-extension.json
│   ├── invalid-status.json
│   └── invalid-prov.json
└── README.md           # This file
```

## Running Validation

### Using JSON Schema Validators

```bash
# Install ajv-cli (Ajv JSON Schema validator)
npm install -g ajv-cli

# Validate a single example
ajv validate -s ../json-schema/schema.json -d valid/item-basic.json

# Validate all valid examples
ajv validate -s ../json-schema/schema.json -d "valid/*.json"

# Test that invalid examples fail
ajv validate -s ../json-schema/schema.json -d "invalid/*.json" 2>&1 | grep "invalid"
```

### Using Python

```python
import json
import jsonschema

# Load schema
with open('../json-schema/schema.json') as f:
    schema = json.load(f)

# Load and validate example
with open('valid/item-basic.json') as f:
    instance = json.load(f)
    
jsonschema.validate(instance, schema)
print("✓ Validation passed")
```

### Using OGC Building Blocks Tooling

For full OGC compliance testing:

```bash
# Clone OGC Building Blocks validator
git clone https://github.com/opengeospatial/bblocks-postprocess

# Run validation (requires Docker)
docker run --rm -v $(pwd):/workspace ogc/bblocks-postprocess validate /workspace/tests
```

## Test Categories

### Valid Examples

These examples demonstrate correct usage and should pass validation:

1. **item-basic.json** - Minimal valid STAC item with liability fields
2. **item-with-prov.json** - Item with W3C PROV provenance
3. **item-with-quality.json** - Item with ISO 19115 quality reports
4. **collection-basic.json** - Valid STAC collection with liability metadata

### Invalid Examples

These examples contain errors and should fail validation:

1. **missing-extension.json** - Missing `stac_extensions` declaration
2. **invalid-status.json** - Invalid enum value for `liability:claim_status`
3. **invalid-prov.json** - Malformed PROV document structure
4. **invalid-currency.json** - Non-ISO 4217 currency code

## Validation Rules

The schema enforces:

- At least one `liability:*` field must be present
- `stac_extensions` must include this extension's URL
- Enum fields must use valid values
- Date fields must be RFC 3339 format
- Currency codes must be 3-letter ISO 4217
- PROV documents must follow PROV-JSON structure
- ISO 19115 quality reports must have required fields

## Expected Results

All tests in `valid/` should:
- ✓ Pass JSON Schema validation
- ✓ Contain all required STAC fields
- ✓ Use correct extension URL in `stac_extensions`

All tests in `invalid/` should:
- ✗ Fail validation with specific error messages
- Demonstrate common usage mistakes

## Adding New Tests

When adding new test cases:

1. Place valid examples in `valid/` directory
2. Place invalid examples in `invalid/` directory
3. Name files descriptively (e.g., `item-environmental-claim.json`)
4. Document the test purpose in this README
5. Run validation to confirm expected behavior

## Continuous Integration

For CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
name: Validate Extension
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install ajv-cli
        run: npm install -g ajv-cli
      - name: Validate schema
        run: ajv compile -s json-schema/schema.json
      - name: Test valid examples
        run: ajv validate -s json-schema/schema.json -d "tests/valid/*.json"
      - name: Test invalid examples fail
        run: |
          ! ajv validate -s json-schema/schema.json -d "tests/invalid/*.json"
```

## See Also

- [OGC Building Blocks Documentation](https://opengeospatial.github.io/bblocks/)
- [JSON Schema Validation](https://json-schema.org/understanding-json-schema/reference/index.html)
- [STAC Validation](https://stac-utils.github.io/stac-validator/)
