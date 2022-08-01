#!/bin/sh

##############################################################
# TITRE: 0.2_upgrade.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.1
# CREATION: 29/07/2022
# MODIFIE: 31/07/2022
#
# DESCRIPTION: Installation "intéligente" des derniers paquets
###############################################################

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

# Début du script

# Dist-Upgrade

sudo apt-get -y dist-upgrade

# Fin du script