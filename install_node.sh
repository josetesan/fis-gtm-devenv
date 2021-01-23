#!/usr/bin/env bash

sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
apt-get update
apt-get install -y --no-install-recommends nodejs node-gyp node-bindings npm
npm install nodem
rm -rf /var/cache/apt/archives

