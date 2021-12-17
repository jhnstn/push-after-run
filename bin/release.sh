#!/bin/bash

set -euo pipefail

minor_version=true
while getopts "m" opt; do
  case $opt in
    m)
      minor_version=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

version=$(jq -r '.version' package.json)

git diff --exit-code || echo -e "\nThere are uncommitted changes. Commit changes before creating a release" && exit 0

IFS='.' read -r -a version_array <<< "$version"
if [[ $minor_version -eq "true" ]]; then
  version_array[1]=$((version_array[1] + 1))
else
  version_array[0]=$((version_array[0] + 1))
fi
version="${version_array[0]}.${version_array[1]}"

package_json=$(jq '.version = "${version}.0"' package.json) && echo "${package_json}" > package.json

ncc build index.js --license licenses.txt
git commit -am "Release v$version"

git tag -a v$version -m "Release v$version"
git push --follow-tags
