#!/bin/bash
set -euo pipefail

REMOTE=${INPUT_REMOTE:-"origin"}
HEAD="HEAD"
GITHUB_TOKEN=${INPUT_TOKEN}

git fetch --quiet "${REMOTE}" "${INPUT_HEAD}"
git switch "${INPUT_HEAD}" || git switch -c "${INPUT_HEAD}"

# Run the commands if provided
if [[ -n "${INPUT_RUN:-}" ]]; then
  while IFS= read -r line; do
    eval "${line}"
  done <<< "$INPUT_RUN"
fi

# Set up git user name if provided
if [[ -n "${INPUT_USER_NAME:-}" ]]; then
  git config user.name "${INPUT_USER_NAME}"
fi

# Set up git user email if provided
if [[ -n "${INPUT_USER_EMAIL:-}" ]]; then
  git config user.email "${INPUT_USER_EMAIL}"
fi
git status

if [ -z "$(git status --porcelain)" ]; then
  exit "${INPUT_NO_CHANGES_EXIT_CODE:-0}"
  echo "::set-output name=changes_pushed::false"
fi

git add .
git -c user.name="${INPUT_USER_NAME}" -c user.email="${INPUT_USER_EMAIL}" \
  commit \
  -m "${INPUT_COMMIT_MESSAGE}" \
  -m "${INPUT_COMMIT_DETAIL}" \
  --author "${INPUT_AUTHOR}" \

git push "${REMOTE}" "${INPUT_HEAD}"
sha=$(git rev-parse --short HEAD)
echo "::set-output name=sha::${sha}"
echo "::set-output name=changes_pushed::true"