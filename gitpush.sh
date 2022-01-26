#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"

pushd "${WORKSPACE}/gh-content"
git config user.email "pisarenco.a@gmail.com"
git config user.name "Alexandru Pisarenco"
git checkout -b build
CHANGES="$(git status --porcelain)"
echo $CHANGES
if [ -n "$CHANGES" ] ; then
    git add docs
    git commit -m "Build: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi
git push origin build --force
popd
