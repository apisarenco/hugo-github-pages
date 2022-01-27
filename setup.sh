#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"
SITE_DIR="$2"
CONTENT_DIR="$3"
BUILD_DIR="$4"

echo "Working on WORKSPACE=${WORKSPACE}, with SITE_DIR=${SITE_DIR} and CONTENT_DIR=${CONTENT_DIR}"

JQ=$(which jq | head -n 1 2> /dev/null || :)
if [ -n "$JQ" ] ; then
    JQ="$WORKSPACE/jq"
    curl -Lso "$JQ" https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    chmod +x "$JQ"
fi

echo "JQ=${JQ}"

EXT=".tar.gz"
HUGO_PACKAGE_URL=$( \
    curl -Ls "https://api.github.com/repos/gohugoio/hugo/releases/latest" | \
    $JQ -r '.assets[].browser_download_url' | \
    grep -Pie "hugo_\d+\.\d+\.\d+_Linux-64bit.tar.gz" \
)

echo "Hugo package url: ${HUGO_PACKAGE_URL}"

HUGO_BINARY_PACKAGE_NAME="hugo_binary"
HUGO_BINARY_PACKAGE="${HUGO_BINARY_PACKAGE_NAME}${EXT}"

curl -Lso "$WORKSPACE/$HUGO_BINARY_PACKAGE" "$HUGO_PACKAGE_URL"

echo "Downloaded hugo binary at $WORKSPACE/$HUGO_BINARY_PACKAGE"

pushd $WORKSPACE
tar -xzf "$HUGO_BINARY_PACKAGE"
HUGO="$(pwd)/hugo"
rm "$HUGO_BINARY_PACKAGE"
popd

echo "Hugo binary: $HUGO"

mkdir -p "${WORKSPACE}/${CONTENT_DIR}/content"
cp -r "${WORKSPACE}/${CONTENT_DIR}/content" "${WORKSPACE}/${SITE_DIR}/content"

ls -al "${WORKSPACE}/${SITE_DIR}"

echo "Running hugo in $WORKSPACE/$SITE_DIR"

pushd "$WORKSPACE/$SITE_DIR"
$HUGO
popd

echo "Moving docs"
rm -rf "${WORKSPACE}/${BUILD_DIR}/docs"
mv "${WORKSPACE}/${SITE_DIR}/docs" "${WORKSPACE}/${BUILD_DIR}/docs"
ls -al "${WORKSPACE}/${BUILD_DIR}/docs"
