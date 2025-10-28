#!/bin/bash
#
# Script to create and push a release tag for CrystalDiskInfo
# Usage: ./scripts/create-release-tag.sh [version] [--test]
# Example: ./scripts/create-release-tag.sh 9.0.0-RC2
# Example: ./scripts/create-release-tag.sh 9.0.0-test --test
#

set -e

VERSION="${1}"
IS_TEST="${2}"

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version number required"
    echo ""
    echo "Usage: $0 <version> [--test]"
    echo ""
    echo "Examples:"
    echo "  $0 9.0.0-RC2          # Create production release"
    echo "  $0 9.0.0-test --test  # Create test release"
    exit 1
fi

# Remove 'v' prefix if provided
VERSION="${VERSION#v}"

# Construct tag name
TAG_NAME="v${VERSION}"

echo "=========================================="
echo "CrystalDiskInfo Release Tag Creator"
echo "=========================================="
echo ""
echo "Version: ${VERSION}"
echo "Tag: ${TAG_NAME}"

if [ "$IS_TEST" = "--test" ]; then
    echo "Type: TEST RELEASE"
    echo ""
    echo "⚠️  This is a test release. It will create a GitHub release"
    echo "    that you should delete after testing."
else
    echo "Type: PRODUCTION RELEASE"
fi

echo ""
echo "----------------------------------------"
echo ""

# Check if tag already exists locally
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    echo "❌ Tag '$TAG_NAME' already exists locally!"
    echo ""
    echo "To delete it:"
    echo "  git tag -d $TAG_NAME"
    exit 1
fi

# Check if tag exists on remote
if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME"; then
    echo "❌ Tag '$TAG_NAME' already exists on remote!"
    echo ""
    echo "To delete it from remote:"
    echo "  git push origin :refs/tags/$TAG_NAME"
    exit 1
fi

# Confirm before proceeding
echo "This will:"
echo "  1. Create a Git tag: $TAG_NAME"
echo "  2. Push the tag to origin"
echo "  3. Trigger GitHub Actions to build and release"
echo ""

read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Creating tag..."

# Create the tag
if [ "$IS_TEST" = "--test" ]; then
    git tag -a "$TAG_NAME" -m "Test release $VERSION"
else
    git tag -a "$TAG_NAME" -m "Release version $VERSION"
fi

echo "✅ Tag created locally"
echo ""
echo "Pushing tag to origin..."

# Push the tag
git push origin "$TAG_NAME"

echo ""
echo "✅ Tag pushed successfully!"
echo ""
echo "=========================================="
echo "Release triggered!"
echo "=========================================="
echo ""
echo "GitHub Actions will now:"
echo "  ⏳ Build Win32 and x64 versions"
echo "  ⏳ Package portable ZIP files"
echo "  ⏳ Create GitHub release"
echo ""
echo "To monitor progress:"
echo "  - View in browser:"
echo "    https://github.com/wakusei0413/CrystalDiskInfo/actions"
echo ""

if command -v gh &> /dev/null; then
    echo "  - Watch in terminal:"
    echo "    gh run watch"
    echo ""
    echo "  - List runs:"
    echo "    gh run list --workflow=build-release.yml"
    echo ""
fi

if [ "$IS_TEST" = "--test" ]; then
    echo "⚠️  REMEMBER: This is a test release!"
    echo ""
    echo "After testing, delete the release and tag:"
    echo "  1. Go to GitHub Releases page and delete the release"
    echo "  2. Delete the tag:"
    echo "     git tag -d $TAG_NAME"
    echo "     git push origin :refs/tags/$TAG_NAME"
    echo ""
fi

echo "=========================================="
