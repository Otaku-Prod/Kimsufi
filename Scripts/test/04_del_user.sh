#!/bin/sh

###################################################################
# TITRE: 04_del_user.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Suppression d'un utilisateur et de son dossier home
###################################################################

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

# Saisie des informations

read -p "Saisir le nom d'identification à supprimer (ex: 'ubuntu'): " otaku_script_login

# Création du compte

sudo apt-get update
sudo apt-get install perl
sudo deluser --remove-home $otaku_script_login

# Suppression des variables

unset otaku_script_login
