#!/bin/bash
set -euo pipefail

REMOTE=${INPUT_REMOTE:-"origin"}
HEAD="HEAD"

# Switch to ref if provided
if [ -n "${INPUT_REF:-}" ]; then
  git fetch --quiet "${REMOTE}" "${INPUT_REF}"
  git switch "${INPUT_REF}" || git switch -c "${INPUT_REF}"
  HEAD="${INPUT_REF}"
fi

# Run the commands if provided
if [[ -n "${INPUT_RUN:-}" ]]; then
  while IFS= read -r line; do
    cmd=($line)
    "${cmd[@]}"
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

if [ -z "$(git status --porcelain)" ]; then
  exit "${INPUT_NO_CHANGES_EXIT_CODE:-0}"
fi

git add .
git -c user.name="${INPUT_USER_NAME}" -c user.email="${INPUT_USER_EMAIL}" \
commit \
-m "${INPUT_MESSAGE}" \
-m "${INPUT_MESSAGE_DETAIL}" \
--author "${INPUT_AUTHOR}" \

git push "${REMOTE}" "${HEAD}"