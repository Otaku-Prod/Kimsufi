#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Saisie des informations

read -p "Quels groupes ? (ex: 'root,adm,sudo'): " otaku_script_group

read -p "Pour qui ? (ex: 'kevin'): " otaku_script_login

usermod -aG $otaku_script_group $otaku_script_login

# Suppression des variables

unset otaku_script_login
unset otaku_script_group