#!/bin/sh

########################################################################
# TITRE: 03_repertoire_par_defaut.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Définir le répertoire par défaut de l'utilisateur choisi
########################################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

# Saisie des informations

read -p "Pour qui ? (ex: 'kevin'): " otaku_script_login

read -p "Quel dossier ? (ex: '/'): " otaku_script_dir

sudo usermod --home $otaku_script_dir $otaku_script_login
  

# Suppression des variables

unset otaku_script_login
unset otaku_script_dir