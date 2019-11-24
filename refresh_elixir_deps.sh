#!/usr/bin/env bash

set -ex

mix deps.get
mix deps.unlock --unused
mix deps.clean --unused
