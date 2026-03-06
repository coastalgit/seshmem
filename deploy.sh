#!/bin/bash
# Deploy seshmem skill files to ~/.claude/commands/seshmem/
# Also creates a versioned snapshot in releases/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/logic/seshmem"
TARGET_DIR="$HOME/.claude/commands/seshmem"

# Extract version from help.md
VERSION=$(grep -oP '(?<=\*\*Version:\*\* )\S+' "$SOURCE_DIR/help.md")

if [ -z "$VERSION" ]; then
    echo "ERROR: Could not extract version from help.md"
    exit 1
fi

echo "Deploying seshmem v$VERSION"

# 1. Deploy to ~/.claude/commands/seshmem/
mkdir -p "$TARGET_DIR"
cp "$SOURCE_DIR"/*.md "$TARGET_DIR/"
echo "  Copied skill files to $TARGET_DIR/"

# 2. Create versioned snapshot in releases/
RELEASE_DIR="$SCRIPT_DIR/releases/v$VERSION"
mkdir -p "$RELEASE_DIR"
cp "$SOURCE_DIR"/*.md "$RELEASE_DIR/"
echo "  Created release snapshot at releases/v$VERSION/"

echo ""
echo "seshmem v$VERSION deployed successfully."
echo "Commands available: /seshmem:save, /seshmem:load, /seshmem:list, /seshmem:help"
