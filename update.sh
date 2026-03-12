#!/bin/bash

###############################
#           CADDY             #
###############################

DIGEST_FILE="caddy.digest"
OLD_DIGEST="$(cat $DIGEST_FILE)"
NEW_DIGEST=""
NAMESPACE="caddyserver"
REPOSITORY="caddy"
TAG="latest"

# Step 1: Get a bearer token
TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:library/${REPOSITORY}:pull" | jq -r '.token')

# Step 2: Get the image manifest.
MANIFEST="$(curl -s https://registry-1.docker.io/v2/library/${REPOSITORY}/manifests/${TAG} \
                 -H "Authorization: Bearer $TOKEN" \
                 -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json')"

# Step 3: Extract digest
NEW_DIGEST="$(echo $MANIFEST | jq -r '.manifests[] | select(.platform.architecture == "amd64" and .platform.os == "linux") | .digest')"

if [ "$OLD_DIGEST" != "$NEW_DIGEST" ]; then
  echo $NEW_DIGEST > $DIGEST_FILE
fi


###############################
#       CADDY BUILDER         #
###############################

DIGEST_FILE="caddy-builder.digest"
OLD_DIGEST="$(cat $DIGEST_FILE)"
NEW_DIGEST=""
NAMESPACE="caddyserver"
REPOSITORY="caddy"
TAG="builder"

# Step 1: Get a bearer token
TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:library/${REPOSITORY}:pull" | jq -r '.token')

# Step 2: Get the image manifest.
MANIFEST="$(curl -s https://registry-1.docker.io/v2/library/${REPOSITORY}/manifests/${TAG} \
                 -H "Authorization: Bearer $TOKEN" \
                 -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json')"

# Step 3: Extract digest
NEW_DIGEST="$(echo $MANIFEST | jq -r '.manifests[] | select(.platform.architecture == "amd64" and .platform.os == "linux") | .digest')"

if [ "$OLD_DIGEST" != "$NEW_DIGEST" ]; then
  echo $NEW_DIGEST > $DIGEST_FILE
fi



###############################
#             MIB             #
###############################

SHA_FILE="mib.sha"
OLD_SHA="$(cat $SHA_FILE)"
NEW_SHA=""
OWNER="fabriziosalmi"
REPOSITORY="caddy-mib"
BRANCH="main"

NEW_SHA="$(curl -s "https://api.github.com/repos/${OWNER}/${REPOSITORY}/branches/${BRANCH}" | jq -r '.commit.sha')"

if [ "$OLD_SHA" != "$NEW_SHA" ]; then
  echo $NEW_SHA > $SHA_FILE
fi


###############################
#            BROTLI           #
###############################

SHA_FILE="brotli.sha"
OLD_SHA="$(cat $SHA_FILE)"
NEW_SHA=""
OWNER="ueffel"
REPOSITORY="caddy-brotli"
BRANCH="master"

NEW_SHA="$(curl -s "https://api.github.com/repos/${OWNER}/${REPOSITORY}/branches/${BRANCH}" | jq -r '.commit.sha')"

if [ "$OLD_SHA" != "$NEW_SHA" ]; then
  echo $NEW_SHA > $SHA_FILE
fi