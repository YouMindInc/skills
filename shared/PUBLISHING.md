# Publishing Guide

This document describes how to publish YouMind skills to [ClawHub](https://clawhub.ai) and keep them updated.

## Overview

Each skill in the `skills/` directory is published independently to ClawHub. The publish script handles packaging and uploading.

## Prerequisites

1. Install ClawHub CLI:
   ```bash
   npm install -g clawhub
   ```

2. Authenticate:
   ```bash
   clawhub login
   clawhub whoami
   ```

## Publishing a Single Skill

### Using the publish script

```bash
./scripts/publish-skill.sh <skill-name> --version <x.y.z> --changelog "What changed"
```

Example:
```bash
./scripts/publish-skill.sh youmind-yt-transcript --version 1.0.0 --changelog "Initial release"
```

### Manual publish

```bash
# 1. Create a clean temp directory with only publishable files
TMP_DIR=$(mktemp -d)
SKILL_DIR="skills/youmind-yt-transcript"

cp "$SKILL_DIR/SKILL.md" "$TMP_DIR/"
[ -f "$SKILL_DIR/package.json" ] && cp "$SKILL_DIR/package.json" "$TMP_DIR/"
[ -f "$SKILL_DIR/README.md" ] && cp "$SKILL_DIR/README.md" "$TMP_DIR/"
[ -d "$SKILL_DIR/references" ] && cp -r "$SKILL_DIR/references" "$TMP_DIR/"
[ -d "$SKILL_DIR/scripts" ] && cp -r "$SKILL_DIR/scripts" "$TMP_DIR/"

# 2. Publish
clawhub publish "$TMP_DIR" \
  --slug youmind-yt-transcript \
  --name "YouMind YouTube Transcript" \
  --version 1.0.0 \
  --changelog "Initial release"

# 3. Clean up
rm -rf "$TMP_DIR"
```

## What Gets Published

| Included | Excluded |
|----------|----------|
| `SKILL.md` | `node_modules/` |
| `package.json` (if exists) | `.git/` |
| `README.md` (if exists) | `shared/` (repo-level) |
| `references/` | `scripts/publish-*.sh` (repo-level) |
| `scripts/` (skill-level) | Test files |

## Version Conventions

- Use [semver](https://semver.org/): `MAJOR.MINOR.PATCH`
- Bump MAJOR for breaking SKILL.md changes (e.g., new required setup steps)
- Bump MINOR for new features (e.g., new output format)
- Bump PATCH for fixes and doc improvements

## Publishing All Changed Skills

```bash
./scripts/publish-all.sh
```

This script:
1. Compares each `skills/*/SKILL.md` against the ClawHub version
2. Detects changes via file hash
3. Prompts for version bump and changelog
4. Publishes only changed skills

## Checking Current Versions

```bash
# Check what's on ClawHub
clawhub list | grep youmind

# Check a specific skill
npx clawhub@latest inspect youmind-yt-transcript --json
```

## Installation Channels

Users can install skills via two channels:

### 1. skills.sh (GitHub-based)
```bash
# Install a specific skill
npx skills add YouMind-OpenLab/skills --skill youmind-yt-transcript

# List all available skills
npx skills add YouMind-OpenLab/skills --list

# Install all skills
npx skills add YouMind-OpenLab/skills --all
```

### 2. ClawHub
```bash
clawhub install youmind-yt-transcript
```

Both channels are maintained in parallel. GitHub is always the source of truth.
