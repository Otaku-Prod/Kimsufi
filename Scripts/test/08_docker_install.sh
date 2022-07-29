#!/bin/sh

########################################################
# TITRE: 08_docker_install.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Installation de Docker Community Edition
########################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

# Commencer par tout supprimer pour être sur d'avoir la dernière version, s'il y avait des conteneurs, images ou autres, tout est encore la pas de panique

sudo apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd containerd.io docker-compose-plugin runc

# Installation de Docker à partir du dépot officiel

sudo apt-get update

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo chmod a+r /etc/apt/keyrings/docker.gpg

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin