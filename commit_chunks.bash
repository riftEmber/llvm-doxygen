#!/usr/bin/env bash

# Commit and push a bunch of changes in chunks of some number of files, to avoid
# commit/push size limits.

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <commit message> [chunk size]"
  exit 1
fi
MESSAGE=$1
CHUNK_SIZE=${2:-1000}

chunkCommand="git ls-files --others --exclude-standard docs"
totalChunks=$(( $($chunkCommand | wc -l) / CHUNK_SIZE + 1 ))
i=0
while [ -n "$($chunkCommand)" ]; do
  eval "$chunkCommand" | head -n $CHUNK_SIZE | xargs git add
  git commit -m "$MESSAGE (chunk $((++i))/$totalChunks)"
done

# adapted from https://docs.github.com/en/get-started/using-git/troubleshooting-the-2-gb-push-limit#splitting-up-a-large-push
step_commits=$(git log --oneline --reverse refs/remotes/origin/main..refs/heads/main)
echo "$step_commits" | while read commit message; do git push origin $commit:refs/heads/main; done
