#!/bin/bash

set -e

echo
echo "  'Auto Merge Action' is using the following input:"
echo "    - source_branch = '$INPUT_SOURCE_BRANCH'"
echo "    - target_branch = '$INPUT_TARGET_BRANCH'"
echo "    - allow_ff = $INPUT_ALLOW_FF"
echo "    - ff_only = $INPUT_FF_ONLY"
echo "    - user_name = $INPUT_USER_NAME"
echo "    - user_email = $INPUT_USER_EMAIL"
echo "    - commit_message = '$INPUT_COMMIT_MESSAGE'"
echo

FF_MODE="--no-ff"
if [[ "$INPUT_ALLOW_FF" == "true" ]]; then
  FF_MODE="--ff"
  if [[ "$INPUT_FF_ONLY" == "true" ]]; then
    FF_MODE="--ff-only"
  fi
fi

git config --local user.name "$INPUT_USER_NAME"
git config --local user.email "$INPUT_USER_EMAIL"

set -o xtrace

git fetch --unshallow origin $INPUT_SOURCE_BRANCH
git checkout -B $INPUT_SOURCE_BRANCH origin/$INPUT_SOURCE_BRANCH

git fetch origin $INPUT_TARGET_BRANCH
git checkout -b $INPUT_TARGET_BRANCH origin/$INPUT_TARGET_BRANCH

if git merge-base --is-ancestor $INPUT_SOURCE_BRANCH $INPUT_TARGET_BRANCH; then
  echo "No merge is necessary"
  exit 0
fi;

set +o xtrace
echo
echo "  'Merge Action' is trying to merge the '$INPUT_SOURCE_BRANCH' branch ($(git log -1 --pretty=%H $INPUT_SOURCE_BRANCH))"
echo "  into the '$INPUT_TARGET_BRANCH' branch ($(git log -1 --pretty=%H $INPUT_TARGET_BRANCH))"
echo
set -o xtrace

# Do the merge
git merge $FF_MODE --no-edit $INPUT_SOURCE_BRANCH -m "$INPUT_COMMIT_MESSAGE"

# Push the branch
git push origin $INPUT_TARGET_BRANCH
