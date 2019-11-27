#!/usr/bin/env bash

set -ex

SELF=$(readlink "$0" || true)
if [ -z "$SELF" ]; then SELF="$0"; fi

PRIV_ROOT="$(cd "$(dirname "$SELF")" && pwd -P)"

for f in $PRIV_ROOT/startup/* ; do
  bash $f -H
done

/app/bin/volunteer start
