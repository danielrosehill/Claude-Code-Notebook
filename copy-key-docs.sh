#!/bin/bash

# Script to copy key Claude Code documentation files
# Created: October 30, 2025
# Purpose: Copy selected docs from mirror to key-files directory

# Set source and destination directories
SOURCE_DIR="/home/daniel/repos/github/Claude Code Notebook/claude-docs/mirror/docs"
DEST_DIR="/home/daniel/repos/github/Claude Code Notebook/claude-docs/key-files"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Array of files to copy (based on links.md reference)
FILES=(
    # Getting Started
    "overview.md"
    "quickstart.md"
    "common-workflows.md"

    # Tools/Features
    "sub-agents.md"
    "plugins.md"
    "skills.md"
    "output-styles.md"
    "hooks-guide.md"
    "headless.md"
    "mcp.md"
    "troubleshooting.md"

    # Administration
    "setup.md"
    "iam.md"
    "security.md"
    "plugin-marketplaces.md"

    # Configuration
    "settings.md"
    "terminal-config.md"
    "model-config.md"
    "memory.md"

    # Reference
    "cli-reference.md"
    "interactive-mode.md"
    "slash-commands.md"
    "checkpointing.md"
    "hooks.md"
    "plugins-reference.md"
)

# Copy each file
echo "Copying key documentation files..."
for file in "${FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        cp "$SOURCE_DIR/$file" "$DEST_DIR/"
        echo "✓ Copied: $file"
    else
        echo "✗ Not found: $file"
    fi
done

echo ""
echo "Copy complete! Files copied to: $DEST_DIR"
echo "Total files copied: $(ls -1 "$DEST_DIR" | wc -l)"
