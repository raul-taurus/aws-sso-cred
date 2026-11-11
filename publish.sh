#!/usr/bin/env bash
set -euo pipefail

BUMP="${1:-patch}"

case "$BUMP" in
  patch|minor|major|prepatch|preminor|premajor|prerelease) ;;
  *)
    echo "Usage: $0 [patch|minor|major|prepatch|preminor|premajor|prerelease]"
    exit 1
    ;;
esac

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: Git working tree is not clean. Commit, stash, or ignore changes first:"
  git status --short
  exit 1
fi

if ! npm whoami >/dev/null 2>&1; then
  echo "Not logged in to npm. Running 'npm login'..."
  npm login
fi

echo "Building with tsc..."
./node_modules/.bin/tsc

echo "Previewing npm tarball..."
npm pack --dry-run

read -r -p "Bump version ($BUMP), publish to npm, and push git tags? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# If index.js is not tracked/ignored in git, remove it so `npm version` sees a clean tree;
# `prepublishOnly` (`tsc`) will regenerate it during `npm publish`.
if [[ -f index.js ]] && ! git ls-files --error-unmatch index.js >/dev/null 2>&1; then
  rm -f index.js
fi

npm version "$BUMP"
npm publish
git push && git push --tags
