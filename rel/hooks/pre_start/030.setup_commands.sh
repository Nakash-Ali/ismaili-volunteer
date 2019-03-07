#!/usr/bin/env bash

# set -e
#
# notice "Do apt-get install dependencies for nodejs and puppeteer"
#
# apt-get update \
#   && apt-get install -y libgconf-2-4 ca-certificates gnupg2 \
#   && apt-get install -y wget --no-install-recommends
#
# wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#   && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
#   && apt-get update
#
# apt-get install -y google-chrome-unstable ttf-freefont --no-install-recommends
#
# notice "Install nodejs"
#
# wget -q -O - https://deb.nodesource.com/setup_10.x | bash -
# apt-get install -y nodejs
#
# notice "Install commands"
#
# cd $CONSOLIDATED_DIR/../priv/commands/
# npm install
#
# success "Installed!"
