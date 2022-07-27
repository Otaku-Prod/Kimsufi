#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Saisie des informations

read -p "Saisir le nom d'identification à supprimer (ex: 'ubuntu'): " otaku_script_login

# Création du compte

apt-get update
apt-get install perl
deluser --remove-home $otaku_script_login

# Suppression des variables

unset otaku_script_login
