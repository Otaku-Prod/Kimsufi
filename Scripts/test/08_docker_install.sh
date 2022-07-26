#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Commencer par tout supprimer pour être sur d'avoir la dernière version, s'il y avait des conteneurs, images ou autres, tout est encore la pas de panique

apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd containerd.io docker-compose-plugin runc

# Installation de Docker à partir du dépot officiel

apt-get update

apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

chmod a+r /etc/apt/keyrings/docker.gpg

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin