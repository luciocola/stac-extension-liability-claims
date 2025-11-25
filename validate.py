#!/usr/bin/env python3
"""
Validation script for STAC Liability and Claims Extension.

This script validates STAC items and collections against the liability-claims 
extension JSON schema.

Usage:
    python validate.py <path_to_stac_file>
    python validate.py examples/item-environmental.json
"""

import json
import sys
from pathlib import Path
from typing import Dict, Any

try:
    import jsonschema
    from jsonschema import validate, ValidationError, RefResolver
except ImportError:
    print("Error: jsonschema library not found.")
    print("Install it with: pip install jsonschema")
    sys.exit(1)


def load_json(file_path: Path) -> Dict[str, Any]:
    """Load JSON file and return parsed content."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: File not found: {file_path}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {file_path}: {e}")
        sys.exit(1)


def validate_stac_item(item: Dict[str, Any], schema: Dict[str, Any]) -> bool:
    """
    Validate a STAC item against the liability-claims extension schema.
    
    Args:
        item: The STAC item to validate
        schema: The JSON schema to validate against
        
    Returns:
        True if valid, False otherwise
    """
    try:
        # Create a resolver for handling $ref in schemas
        resolver = RefResolver.from_schema(schema)
        
        # Validate the item
        validate(instance=item, schema=schema, resolver=resolver)
        return True
    except ValidationError as e:
        print(f"Validation Error: {e.message}")
        print(f"Path: {' -> '.join(str(p) for p in e.path)}")
        if e.context:
            print("\nContext:")
            for ctx_error in e.context:
                print(f"  - {ctx_error.message}")
        return False
    except Exception as e:
        print(f"Unexpected error during validation: {e}")
        return False


def check_liability_fields(item: Dict[str, Any]) -> None:
    """
    Check for common issues with liability extension fields.
    
    Args:
        item: The STAC item to check
    """
    properties = item.get('properties', {})
    
    # Check if extension is declared
    extensions = item.get('stac_extensions', [])
    if not any('liability-claims' in ext for ext in extensions):
        print("Warning: liability-claims extension not declared in stac_extensions")
    
    # Check for liability fields
    liability_fields = [k for k in properties.keys() if k.startswith('liability:')]
    
    if not liability_fields:
        print("Warning: No liability: fields found in properties")
    else:
        print(f"Found {len(liability_fields)} liability fields:")
        for field in liability_fields:
            print(f"  - {field}: {properties[field]}")
    
    # Check for common field combinations
    if 'liability:damages_estimated' in properties:
        if 'liability:damages_currency' not in properties:
            print("Warning: damages_estimated found but damages_currency is missing")
    
    if 'liability:resolution_date' in properties:
        if 'liability:resolution_status' not in properties:
            print("Warning: resolution_date found but resolution_status is missing")


def main():
    """Main validation function."""
    if len(sys.argv) < 2:
        print("Usage: python validate.py <path_to_stac_file>")
        print("\nExample:")
        print("  python validate.py examples/item-environmental.json")
        sys.exit(1)
    
    # Get paths
    script_dir = Path(__file__).parent
    schema_path = script_dir / 'json-schema' / 'schema.json'
    stac_file_path = Path(sys.argv[1])
    
    # Make path absolute if relative
    if not stac_file_path.is_absolute():
        stac_file_path = script_dir / stac_file_path
    
    print(f"Validating: {stac_file_path}")
    print(f"Schema: {schema_path}\n")
    
    # Load files
    schema = load_json(schema_path)
    stac_item = load_json(stac_file_path)
    
    # Validate
    is_valid = validate_stac_item(stac_item, schema)
    
    print("\n" + "="*60)
    if is_valid:
        print("✓ VALIDATION PASSED")
        print("="*60 + "\n")
        
        # Additional checks
        print("Additional Checks:")
        print("-"*60)
        check_liability_fields(stac_item)
    else:
        print("✗ VALIDATION FAILED")
        print("="*60)
        sys.exit(1)


if __name__ == '__main__':
    main()
