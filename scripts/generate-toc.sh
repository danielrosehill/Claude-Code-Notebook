#!/bin/bash

# Generate Table of Contents for README.md
# This script scans the notebook directory and creates a TOC

set -e

# Function to prettify directory names
prettify_name() {
    local name="$1"
    # Convert kebab-case or snake_case to Title Case
    local result=$(echo "$name" | sed 's/-/ /g; s/_/ /g; s/\b\(.\)/\u\1/g')

    # Handle specific acronyms that should be uppercase
    result=$(echo "$result" | sed 's/\bCwd\b/CWD/g')
    result=$(echo "$result" | sed 's/\bMcp\b/MCP/g')

    echo "$result"
}

# Generate TOC
generate_toc() {
    cat <<'EOF'
<!-- TOC_START -->
## Table of Contents

EOF

    # Main index
    echo "### [Main Index](./notebook/index.md)"
    echo ""

    # Find all subdirectories in notebook
    find notebook -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
        dirname=$(basename "$dir")
        pretty_name=$(prettify_name "$dirname")

        echo "### [$pretty_name](./notebook/$dirname/)"
        echo ""

        # List markdown files in this directory (excluding index.md)
        find "$dir" -maxdepth 1 -name "*.md" ! -name "index.md" -type f | sort | while read -r file; do
            filename=$(basename "$file" .md)

            # Try to extract the first heading from the file as the title
            title=$(head -20 "$file" | grep -m 1 "^# " | sed 's/^# //' || echo "$filename")

            # If no title found or title is empty, use filename
            if [ -z "$title" ]; then
                title=$(prettify_name "$filename")
            fi

            echo "- [$title](./$file)"
        done
        echo ""
    done

    cat <<'EOF'
<!-- TOC_END -->
EOF
}

# Main execution
TOC=$(generate_toc)

# Check if TOC markers exist in README
if grep -q "<!-- TOC_START -->" README.md && grep -q "<!-- TOC_END -->" README.md; then
    # Replace existing TOC
    # Use perl for multi-line replacement
    perl -i -0pe 's/<!-- TOC_START -->.*?<!-- TOC_END -->/'"$(echo "$TOC" | sed 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')"'/s' README.md
    echo "TOC updated in README.md"
else
    # Append TOC to README
    echo "" >> README.md
    echo "$TOC" >> README.md
    echo "TOC appended to README.md"
fi
