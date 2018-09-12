#!/usr/bin/env bash

set -e

notice "Do apt-get install dependencies for nodejs and puppeteer"

apt-get update
apt-get install -y \
  ca-certificates \
  curl \
  fonts-liberation \
  gconf-service \
  gnupg \
  libappindicator1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  lsb-release \
  wget \
  xdg-utils \

notice "Install nodejs"

curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y nodejs

notice "Install commands"

env
cd $RELEASE_ROOT_DIR/lib/volunteer-1.1.0/priv/commands/
npm install

success "Installed!"
