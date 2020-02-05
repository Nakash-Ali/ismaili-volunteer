#!/usr/bin/env bash

set -xeuf -o pipefail

cd "$(dirname "$0")"

GCLOUD_TARGET=${1:-"https://ots.the.ismaili"};

sed "s|__GCLOUD_TARGET__|${GCLOUD_TARGET}|g" ./netlify-template.toml > ./netlify.toml

cat ./netlify.toml

./node_modules/.bin/netlify link --id="ce5487fb-610b-45b1-ae66-fd311b1753c9"
./node_modules/.bin/netlify deploy --prod --message="$GCLOUD_TARGET"

rm -f netlify.toml
