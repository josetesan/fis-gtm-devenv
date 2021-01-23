#!/usr/bin/env bash

sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
apt-get update
apt-get install -y --no-install-recommends man info git gdb gdbserver strace valgrind
apt-get build-dep -y fis-gtm

