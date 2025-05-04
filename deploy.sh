#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Deploy Flutter Web build to GitHub Pages (gh-pages branch)
# Repository: gregambrown/amnetworks
# This script:
#   1. Verifies you’re on a clean working branch
#   2. Builds your Flutter web app
#   3. Backs up the current gh-pages branch into a timestamped local branch
#   4. Publishes the new build as an orphan gh-pages branch
#   5. Returns you to your original branch
# ------------------------------------------------------------------------------

#######################
# Configuration
#######################

# Remote and branch names
REMOTE_NAME="origin"
REPO_PATH="gregambrown/amnetworks.git"
GH_PAGES_BRANCH="gh-pages"

# Timestamp for backup branch
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_BRANCH="backup-gh-pages-${TIMESTAMP}"

#######################
# Pre-flight checks
#######################

# 1. Ensure git is initialized
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌  Not in a Git repository. Aborting."
  exit 1
fi

# 2. Confirm remote URL
REMOTE_URL=$(git remote get-url ${REMOTE_NAME})
if [[ "${REMOTE_URL}" != *"${REPO_PATH}" ]]; then
  echo "❌  Remote ${REMOTE_NAME} does not point to ${REPO_PATH}."
  echo "    Found: ${REMOTE_URL}"
  exit 1
fi

# 3. Check working directory is clean
if ! git diff-index --quiet HEAD --; then
  echo "❌  You have uncommitted changes. Please commit or stash before deploying."
  exit 1
fi

# 4. Remember current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "🔀  Current branch is '${CURRENT_BRANCH}'."

#######################
# Build Flutter Web
#######################
echo "🚧  Building Flutter web release..."
flutter build web --release

#######################
# Backup existing gh-pages
#######################
echo "📦  Fetching and backing up remote '${GH_PAGES_BRANCH}' as '${BACKUP_BRANCH}'..."
# Create a local backup branch from remote/gh-pages
git fetch ${REMOTE_NAME} ${GH_PAGES_BRANCH}:${BACKUP_BRANCH}

#######################
# Publish new gh-pages
#######################
echo "🚀  Publishing to '${GH_PAGES_BRANCH}' branch..."

# Create or switch to an orphan gh-pages branch
git checkout --orphan ${GH_PAGES_BRANCH}

# Remove all files from the index
git rm -rf . >/dev/null 2>&1 || true

# Copy the newly built site into current directory
cp -r build/web/* .

# If you have a CNAME file, copy it as well:
# cp CNAME .

# Stage all files
git add .

# Commit
git commit -m "💻 Deploy Flutter web build (${TIMESTAMP})"

# Force-push to overwrite remote gh-pages
git push ${REMOTE_NAME} ${GH_PAGES_BRANCH} --force

#######################
# Cleanup & restore
#######################
echo "🔄  Returning to '${CURRENT_BRANCH}'..."
git checkout ${CURRENT_BRANCH}

echo "✅  Deployment complete!"
echo "   ▶ Backup of previous '${GH_PAGES_BRANCH}' is in local branch '${BACKUP_BRANCH}'."
echo "   ▶ Review it with: git checkout ${BACKUP_BRANCH}"
