#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

apt-get -y update
apt-get -y dist-upgrade
