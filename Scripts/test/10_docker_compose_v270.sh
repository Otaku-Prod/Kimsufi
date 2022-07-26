#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Installation

wget https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 && sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && docker-compose --version#