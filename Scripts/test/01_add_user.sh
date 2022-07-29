#!/bin/sh

#########################################################################################
# TITRE: 01_add_user.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Ajouter un utilisateur avec choix du groupe et création du dossier "home"
#########################################################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

# Saisie des informations

read -p "Saisir votre nom d'identification (ex: 'kevin'): " otaku_script_login
read -p "Saisir votre nom complet (ex: 'Kevin DUPONT'): " otaku_script_fullname
read -p "Saisir le groupe de l'utilisateur (ex: 'users'): " otaku_script_group_id

# Création du compte

sudo useradd --create-home --gid "$otaku_script_group_id" --comment "$otaku_script_fullname" "$otaku_script_login"

# Création du mot de passe

passwd $otaku_script_login

# Suppression des variables

unset otaku_script_login
unset otaku_script_fullname
unset otaku_script_group_id
