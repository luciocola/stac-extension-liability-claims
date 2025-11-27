#!/usr/bin/env python3
"""
Validate a JSON file (quality report or array of reports) against the
`json-schema/iso19115-quality.json` schema.

Usage:
    python tools/validate-quality.py <path_to_quality_json>

"""
import json
import sys
from pathlib import Path

try:
    import jsonschema
    from jsonschema import validate, ValidationError, RefResolver
except ImportError:
    print("Error: jsonschema library not found. Install with: pip install jsonschema")
    sys.exit(1)


def load_json(path: Path):
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading JSON {path}: {e}")
        sys.exit(1)


def main():
    if len(sys.argv) < 2:
        print("Usage: python tools/validate-quality.py <quality_json_file>")
        sys.exit(1)

    file_path = Path(sys.argv[1])
    if not file_path.is_absolute():
        file_path = Path(__file__).parent.parent / file_path

    schema_path = Path(__file__).parent.parent / 'json-schema' / 'iso19115-quality.json'

    print(f"Validating {file_path} against {schema_path}")

    schema = load_json(schema_path)
    instance = load_json(file_path)

    try:
        resolver = RefResolver.from_schema(schema)
        validate(instance=instance, schema=schema, resolver=resolver)
        print("✓ VALID: instance conforms to iso19115-quality schema")
    except ValidationError as e:
        print("✗ INVALID: instance does NOT conform to iso19115-quality schema")
        print(f"Error: {e.message}")
        print(f"Path: {'/'.join(str(p) for p in e.path)}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
