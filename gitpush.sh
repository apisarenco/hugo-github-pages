#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"
CONTENT_DIR="$2"

pushd "${WORKSPACE}/${CONTENT_DIR}"
git config user.email "pisarenco.a@gmail.com"
git config user.name "Alexandru Pisarenco"
git checkout -b build
rm -rf docs
CHANGES="$(git status --porcelain)"
echo $CHANGES
if [ ! -n "$CHANGES" ] ; then
    git add docs
    git commit -m "Build: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi
git push origin build --force
popd
