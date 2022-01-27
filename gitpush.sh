#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"
CONTENT_DIR="$2"

pushd "${WORKSPACE}/${CONTENT_DIR}"
echo "File list:"
ls -al .
git config user.email "pisarenco.a@gmail.com"
git config user.name "Alexandru Pisarenco"
git rebase -s theirs origin/main
CHANGES="$(git status --porcelain)"
echo "Current changes:"
echo $CHANGES
echo "File list:"
ls -al .
if [ ! -n "$CHANGES" ] ; then
    git add docs
    git commit -m "Build: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi
git push origin build --force
popd
