#!/bin/bash

# Script to update Claude Code documentation
# Created: October 30, 2025
# Purpose: Pull latest docs from submodule and copy key files

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_PATH="$SCRIPT_DIR/claude-docs/mirror"

echo "===================================="
echo "Claude Code Documentation Updater"
echo "===================================="
echo ""

# Check if submodule exists
if [ ! -d "$SUBMODULE_PATH" ]; then
    echo "Error: Submodule not found at $SUBMODULE_PATH"
    echo "Please ensure the submodule is initialized."
    exit 1
fi

# Update the submodule
echo "Step 1: Updating submodule..."
echo "-----------------------------------"
cd "$SCRIPT_DIR"
git submodule update --init --recursive --remote
echo "✓ Submodule updated"
echo ""

# Show what changed
echo "Step 2: Checking for updates..."
echo "-----------------------------------"
cd "$SUBMODULE_PATH"
LATEST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%cr)" HEAD)
echo "Latest commit: $LATEST_COMMIT"
echo ""

# Run the copy script
echo "Step 3: Copying key documentation files..."
echo "-----------------------------------"
cd "$SCRIPT_DIR"
./copy-key-docs.sh
echo ""

echo "===================================="
echo "Update complete!"
echo "===================================="
