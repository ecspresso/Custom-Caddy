#!/bin/bash

UPDATE=false

###############################
#           CADDY             #
###############################

OLD_DIGEST="$(cat caddy.digest)"
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
  echo $NEW_DIGEST
  UPDATE=true
fi


###############################
#       CADDY BUILDER         #
###############################

OLD_DIGEST="$(cat caddy-builder.digest)"
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
  echo $NEW_DIGEST
fi



###############################
#             MIB             #
###############################

OLD_SHA="$(cat mib.sha)"
NEW_SHA=""
OWNER="fabriziosalmi"
REPOSITORY="caddy-mib"
BRANCH="main"

NEW_SHA="$(curl -s "https://api.github.com/repos/${OWNER}/${REPOSITORY}/branches/${BRANCH}" | jq -r '.commit.sha')"

if [ "$OLD_SHA" != "$NEW_SHA" ]; then
  echo $NEW_SHA
  UPDATE=true
fi


###############################
#            BROTLI           #
###############################

OLD_SHA="$(cat brotli.sha)"
NEW_SHA=""
OWNER="ueffel"
REPOSITORY="caddy-brotli"
BRANCH="master"

NEW_SHA="$(curl -s "https://api.github.com/repos/${OWNER}/${REPOSITORY}/branches/${BRANCH}" | jq -r '.commit.sha')"

if [ "$OLD_SHA" != "$NEW_SHA" ]; then
  echo $NEW_SHA
  UPDATE=true
fi

if [ $UPDATE ]; then
  echo "update"
fi