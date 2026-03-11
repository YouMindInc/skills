#!/bin/bash
set -euo pipefail

# Publish a single skill to ClawHub
# Usage: ./scripts/publish-skill.sh <skill-name> --version <x.y.z> [--changelog "..."] [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

SKILL_NAME=""
VERSION=""
CHANGELOG="Update"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --version) VERSION="$2"; shift 2 ;;
    --changelog) CHANGELOG="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    -*) echo "Unknown option: $1"; exit 1 ;;
    *) SKILL_NAME="$1"; shift ;;
  esac
done

if [[ -z "$SKILL_NAME" ]]; then
  echo "Usage: ./scripts/publish-skill.sh <skill-name> --version <x.y.z> [--changelog \"...\"] [--dry-run]"
  echo ""
  echo "Available skills:"
  ls -1 "$REPO_DIR/skills/" | grep -v '^$'
  exit 1
fi

SKILL_DIR="$REPO_DIR/skills/$SKILL_NAME"

if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
  echo "Error: $SKILL_DIR/SKILL.md not found"
  exit 1
fi

if [[ -z "$VERSION" ]]; then
  # Try to read version from package.json
  if [[ -f "$SKILL_DIR/package.json" ]]; then
    VERSION=$(grep '"version"' "$SKILL_DIR/package.json" | head -1 | sed 's/.*"version".*"\(.*\)".*/\1/')
  fi
  if [[ -z "$VERSION" ]]; then
    echo "Error: --version required (no package.json found)"
    exit 1
  fi
fi

# Extract display name from SKILL.md frontmatter
DISPLAY_NAME=$(grep '^name:' "$SKILL_DIR/SKILL.md" | head -1 | sed 's/^name: *//')
if [[ -z "$DISPLAY_NAME" ]]; then
  DISPLAY_NAME="$SKILL_NAME"
fi

# Create temp directory with publishable files only
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo "Packaging $SKILL_NAME v$VERSION..."

cp "$SKILL_DIR/SKILL.md" "$TMP_DIR/"
[[ -f "$SKILL_DIR/package.json" ]] && cp "$SKILL_DIR/package.json" "$TMP_DIR/"
[[ -f "$SKILL_DIR/README.md" ]] && cp "$SKILL_DIR/README.md" "$TMP_DIR/"

if [[ -d "$SKILL_DIR/references" ]]; then
  cp -r "$SKILL_DIR/references" "$TMP_DIR/"
fi
if [[ -d "$SKILL_DIR/scripts" ]]; then
  cp -r "$SKILL_DIR/scripts" "$TMP_DIR/"
fi

echo "Files to publish:"
find "$TMP_DIR" -type f | while read -r f; do
  echo "  $(basename "$f") ($(wc -c < "$f" | tr -d ' ') bytes)"
done

if $DRY_RUN; then
  echo ""
  echo "[DRY RUN] Would publish:"
  echo "  slug: $SKILL_NAME"
  echo "  name: $DISPLAY_NAME"
  echo "  version: $VERSION"
  echo "  changelog: $CHANGELOG"
  exit 0
fi

echo ""
echo "Publishing to ClawHub..."
clawhub publish "$TMP_DIR" \
  --slug "$SKILL_NAME" \
  --name "$DISPLAY_NAME" \
  --version "$VERSION" \
  --changelog "$CHANGELOG"

echo ""
echo "✅ Published $SKILL_NAME v$VERSION to ClawHub"
echo "   https://clawhub.ai/skill/$SKILL_NAME"
