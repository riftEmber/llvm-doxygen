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

chunkCommand="git ls-files --others --exclude-standard"
totalChunks=$(( $($chunkCommand | wc -l) / CHUNK_SIZE + 1 ))
i=0
while [ -n "$($chunkCommand)" ]; do
  eval "$chunkCommand" | head -n $CHUNK_SIZE | xargs git add
  git commit -m "$MESSAGE (chunk $((++i))/$totalChunks)"
  git push
done
