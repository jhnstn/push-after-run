#!/bin/bash
set -euo pipefail

REMOTE=${INPUT_REMOTE:-"origin"}
HEAD="HEAD"
GITHUB_TOKEN=${INPUT_TOKEN}
DEBUG="true"

_debug() {
  if [ "${DEBUG}" = "true" ]; then
    echo "::debug::$@"
  fi
}
ls -lat
# Switch to ref if provided

  git fetch --quiet "${REMOTE}" "${INPUT_HEAD}"
  git switch "${INPUT_REF}" || git switch -c "${INPUT_HEAD}"

echo "pre readme"
cat README.md
# Run the commands if provided
if [[ -n "${INPUT_RUN:-}" ]]; then
  while IFS= read -r line; do
    eval "${line}"
    #cmd=($line)
    #"${cmd[@]}"
  done <<< "$INPUT_RUN"
fi
echo "post readme"
cat README.md
ls -lat
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
  _debug "No changes detected, skipping commit"
  exit "${INPUT_NO_CHANGES_EXIT_CODE:-1}"
fi

git add .
git -c user.name="${INPUT_USER_NAME}" -c user.email="${INPUT_USER_EMAIL}" \
commit \
-m "${INPUT_MESSAGE}" \
-m "${INPUT_MESSAGE_DETAIL}" \
--author "${INPUT_AUTHOR}" \

git push "${REMOTE}" "${INPUT_HEAD}"