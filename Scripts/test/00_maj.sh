#!/bin/sh

#####################################################################
# TITRE: 00_maj.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Mettre à jour la distribution Ubuntu
#####################################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
if [[ "$(id -u)" != 0 ]]
then
  echo "vous n'êtes pas root !"
  echo "Tentative en sudo:"
  exec sudo bash "$0"
else
  echo "vous êtes root !"
fi

sudo apt-get -y update
sudo apt-get -y dist-upgrade
