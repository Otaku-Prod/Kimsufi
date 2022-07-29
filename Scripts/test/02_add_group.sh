#!/bin/sh

##################################################################################
# TITRE: 02_add_group.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Ajouter un ou plusieurs groupe à un utilisateur au choix également
##################################################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

# Saisie des informations

read -p "Quels groupes ? (ex: 'root,adm,sudo'): " otaku_script_group

read -p "Pour qui ? (ex: 'kevin'): " otaku_script_login

sudo usermod -aG $otaku_script_group $otaku_script_login

# Suppression des variables

unset otaku_script_login
unset otaku_script_group