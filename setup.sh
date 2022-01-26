#!/usr/bin/env bash
set -eo pipefail

WORKSPACE="$1"
SITE_DIR="$2"
CONTENT_DIR="$3"

echo "Working on WORKSPACE=${WORKSPACE}, with SITE_DIR=${SITE_DIR} and CONTENT_DIR=${CONTENT_DIR}"

JQ=$(which jq | head -n 1 2> /dev/null || :)
if [ -n "$JQ" ] ; then
    JQ="$WORKSPACE/jq"
    curl -Lso "$JQ" https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    chmod +x "$JQ"
fi

EXT=".tar.gz"

BINARY=$(curl -Ls "https://api.github.com/repos/gohugoio/hugo/releases/latest" | \
$JQ -r '.assets[] | {name, browser_download_url} | select(.name | test("hugo_\\d+\\.\\d+\\.\\d+_Linux-64bit\\${EXT}")).browser_download_url')

HUGO_BINARY_PACKAGE_NAME="hugo_binary"
HUGO_BINARY_PACKAGE="${HUGO_BINARY_PACKAGE}${EXT}"

curl -Lso "$WORKSPACE/$HUGO_BINARY_PACKAGE" "$BINARY"
pushd $WORKSPACE
tar -xzf "$HUGO_BINARY_PACKAGE"
mv "$HUGO_BINARY_PACKAGE_NAME/*" ./
HUGO="${WORKSPACE}/hugo"
rm -rf hugo-binary
popd

mkdir -p ${WORKSPACE}/${CONTENT_DIR}/docs
ln "${WORKSPACE}/${CONTENT_DIR}/content" "${WORKSPACE}/${SITE_DIR}/content"
ln "${WORKSPACE}/${CONTENT_DIR}/docs" "${WORKSPACE}/${SITE_DIR}/docs" 

pushd "$WORKSPACE/$SITE_DIR"
$HUGO
popd
