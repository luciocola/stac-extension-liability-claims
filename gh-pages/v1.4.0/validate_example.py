#!/usr/bin/env python3
"""
Validate STAC items against the v1.3.0 liability claims extension schema
"""
import json
import sys
from pathlib import Path

def validate_example(example_path, schema_path):
    """Validate a STAC item example"""
    
    # Load the example
    with open(example_path, 'r') as f:
        item = json.load(f)
    
    # Load the schema
    with open(schema_path, 'r') as f:
        schema = json.load(f)
    
    print(f"Validating: {example_path.name}")
    print("=" * 60)
    
    # Check STAC version
    stac_version = item.get('stac_version')
    print(f"✓ STAC Version: {stac_version}")
    
    # Check extension declaration
    extensions = item.get('stac_extensions', [])
    has_extension = any('liability-claims/v1.3.0' in ext for ext in extensions)
    if has_extension:
        print(f"✓ Extension declared: {extensions[0]}")
    else:
        print(f"✗ Extension NOT declared")
        return False
    
    # Check properties
    props = item.get('properties', {})
    
    # Find extension fields
    extension_fields = {k: v for k, v in props.items() 
                       if k.startswith(('liability:', 'dq:', 'ard:'))}
    
    print(f"\n✓ Extension fields found: {len(extension_fields)}")
    for field in sorted(extension_fields.keys()):
        field_type = type(extension_fields[field]).__name__
        if isinstance(extension_fields[field], list):
            field_type = f"array[{len(extension_fields[field])}]"
        print(f"  - {field}: {field_type}")
    
    # Check require_any_field satisfaction
    require_any = schema['definitions']['require_any_field']['anyOf']
    satisfied_fields = []
    
    for req in require_any:
        if 'required' in req and len(req['required']) == 1:
            field = req['required'][0]
            if field in props:
                satisfied_fields.append(field)
    
    print(f"\n✓ Satisfies {len(satisfied_fields)} 'require_any_field' options:")
    for field in satisfied_fields[:5]:  # Show first 5
        print(f"  - {field}")
    if len(satisfied_fields) > 5:
        print(f"  ... and {len(satisfied_fields) - 5} more")
    
    # Validate EOVOC fields specifically
    if 'dq:quality' in props:
        quality_items = props['dq:quality']
        print(f"\n✓ dq:quality: {len(quality_items)} quality report(s)")
        for i, q in enumerate(quality_items):
            scope = q.get('scope', {}).get('level', 'unknown')
            reports = len(q.get('report', []))
            print(f"  [{i}] Scope: {scope}, Reports: {reports}")
    
    if 'dq:lineage' in props:
        lineage_items = props['dq:lineage']
        print(f"\n✓ dq:lineage: {len(lineage_items)} lineage record(s)")
        for i, lin in enumerate(lineage_items):
            statement = lin.get('statement', '')[:60]
            steps = len(lin.get('processStep', []))
            sources = len(lin.get('source', []))
            print(f"  [{i}] Statement: {statement}...")
            print(f"      Process steps: {steps}, Sources: {sources}")
    
    # Check geometry
    geometry = item.get('geometry')
    if geometry:
        geom_type = geometry.get('type')
        print(f"\n✓ Geometry: {geom_type}")
    
    # Check bbox
    bbox = item.get('bbox')
    if bbox:
        print(f"✓ BBox: [{bbox[0]:.2f}, {bbox[1]:.2f}, {bbox[2]:.2f}, {bbox[3]:.2f}]")
    
    # Check assets
    assets = item.get('assets', {})
    print(f"\n✓ Assets: {len(assets)}")
    for asset_key in sorted(assets.keys()):
        asset = assets[asset_key]
        title = asset.get('title', 'Untitled')
        asset_type = asset.get('type', 'unknown')
        print(f"  - {asset_key}: {title} ({asset_type})")
    
    print("\n" + "=" * 60)
    print("✅ VALIDATION PASSED - Example is structurally valid!")
    print("=" * 60)
    return True

if __name__ == '__main__':
    base_dir = Path(__file__).parent
    example_file = base_dir / 'examples' / 'item-with-eovoc-dq.json'
    schema_file = base_dir / 'schema.json'
    
    if not example_file.exists():
        print(f"Error: Example file not found: {example_file}")
        sys.exit(1)
    
    if not schema_file.exists():
        print(f"Error: Schema file not found: {schema_file}")
        sys.exit(1)
    
    success = validate_example(example_file, schema_file)
    sys.exit(0 if success else 1)
