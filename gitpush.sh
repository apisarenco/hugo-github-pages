#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"
BUILD_DIR="$2"

pushd "${WORKSPACE}/${BUILD_DIR}"
git config user.email "pisarenco.a@gmail.com"
git config user.name "Alexandru Pisarenco"

sed -i -s 's/^\/docs\/\*$//' .gitignore

echo "---- .gitignore ----"
cat .gitignore
echo "---- END .gitignore ----"

CHANGES="$(git status docs --porcelain)"

echo "Current changes:"
echo $CHANGES
if [ "$CHANGES" ] ; then
    git add docs
    git commit -m "Build: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi
git push origin build --force
popd
