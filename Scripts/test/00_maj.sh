#!/bin/sh

# Force le lancement du script en root ou sudo

[ "$(id -u)" != 0 ] && exec sudo bash "$0"


apt-get -y update
apt-get -y dist-upgrade
