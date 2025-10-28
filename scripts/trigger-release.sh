#!/bin/bash
#
# Script to trigger a GitHub Actions workflow for building and releasing CrystalDiskInfo
# Usage: ./scripts/trigger-release.sh [version]
# Example: ./scripts/trigger-release.sh 9.0.0-RC2
#

set -e

VERSION="${1:-9.0.0-RC2}"
WORKFLOW_FILE="build-release.yml"

echo "=========================================="
echo "CrystalDiskInfo Release Trigger"
echo "=========================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Please install it from: https://cli.github.com/"
    echo ""
    echo "Or use one of these methods:"
    echo "  - Create a tag: git tag -a v${VERSION} -m 'Release ${VERSION}' && git push origin v${VERSION}"
    echo "  - Manually trigger from GitHub Actions web UI"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub."
    echo ""
    echo "Please run: gh auth login"
    exit 1
fi

echo "📦 Triggering release workflow for version: ${VERSION}"
echo ""

# Trigger the workflow
gh workflow run "${WORKFLOW_FILE}" \
    --field version="${VERSION}" \
    --ref feat/windows-portable-win10-1803-release

echo ""
echo "✅ Workflow triggered successfully!"
echo ""
echo "To check the status:"
echo "  gh run list --workflow=${WORKFLOW_FILE}"
echo ""
echo "To watch the workflow in real-time:"
echo "  gh run watch"
echo ""
echo "To view in browser:"
echo "  gh workflow view ${WORKFLOW_FILE} --web"
echo ""
