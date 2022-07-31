#!/bin/sh

##############################################
# TITRE: 09_docker_compose_v270.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Installation de Docker Compose
##############################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
if [[ "$(id -u)" != 0 ]]
then
  echo "Vous n'êtes pas root !"
  echo "Tentative en sudo:"
  exec sudo bash $0
else
  echo "Vous êtes root !"
  echo "Le script peut continuer..."
fi

# Installation

sudo wget https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 && sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && docker-compose --version