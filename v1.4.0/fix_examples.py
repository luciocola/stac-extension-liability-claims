#!/usr/bin/env python3
"""
Fix v1.4.0 examples to use CI_Date format for stepDateTime
and update schema references
"""
import json
import glob
import os

def fix_example_file(filepath):
    """Update an example file to v1.4.0 format"""
    with open(filepath, 'r') as f:
        data = json.load(f)
    
    modified = False
    
    # Update stac_extensions to v1.4.0
    if 'stac_extensions' in data:
        for i, ext in enumerate(data['stac_extensions']):
            if 'stac-extension-liability-claims' in ext:
                data['stac_extensions'][i] = 'https://luciocola.github.io/stac-extension-liability-claims/v1.4.0/schema.json'
                modified = True
    
    # Fix stepDateTime in quality/lineage
    if 'liability:quality' in data.get('properties', {}):
        quality = data['properties']['liability:quality']
        if 'elements' in quality:
            for element in quality['elements']:
                if element.get('elementType') == 'lineage' and 'detail' in element:
                    detail = element['detail']
                    if 'processStep' in detail:
                        for step in detail['processStep']:
                            if 'stepDateTime' in step and isinstance(step['stepDateTime'], str):
                                # Convert to CI_Date object
                                old_date = step['stepDateTime']
                                step['stepDateTime'] = {'processing': old_date}
                                modified = True
    
    # Save if modified
    if modified:
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2)
            f.write('\n')  # Add final newline
        return True
    return False

# Process all example JSON files
examples_dir = 'examples'
updated_count = 0

for example_file in glob.glob(os.path.join(examples_dir, '*.json')):
    if fix_example_file(example_file):
        print(f'✓ Updated {os.path.basename(example_file)}')
        updated_count += 1
    else:
        print(f'  No changes needed for {os.path.basename(example_file)}')

print(f'\nTotal files updated: {updated_count}')
