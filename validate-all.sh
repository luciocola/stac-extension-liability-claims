#!/bin/bash
# Validate all example STAC files against the schema

echo "Validating all example files..."
echo "================================"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 not found. Please install Python 3."
    exit 1
fi

# Check if jsonschema is installed
if ! python3 -c "import jsonschema" &> /dev/null; then
    echo "Installing jsonschema..."
    pip3 install jsonschema
fi

# Initialize counters
total=0
passed=0
failed=0

# Validate each example file
for file in examples/*.json; do
    if [ -f "$file" ]; then
        total=$((total + 1))
        echo "Validating: $file"
        echo "---"
        
        if python3 validate.py "$file"; then
            passed=$((passed + 1))
            echo ""
        else
            failed=$((failed + 1))
            echo ""
        fi
    fi
done

# Print summary
echo "================================"
echo "Validation Summary"
echo "================================"
echo "Total files: $total"
echo "Passed: $passed"
echo "Failed: $failed"
echo ""

if [ $failed -gt 0 ]; then
    exit 1
else
    echo "✓ All validations passed!"
    exit 0
fi
