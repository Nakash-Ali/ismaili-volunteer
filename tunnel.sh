#!/usr/bin/env bash

set -ex

ssh -R ots-ftoihbpimedesrvmpuwh:80:localhost:4000 serveo.net
