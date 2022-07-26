#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Saisie des informations

read -p "Pour qui ? (ex: 'kevin'): " otaku_script_login

read -p "Quel dossier ? (ex: '/'): " otaku_script_dir

usermod --home $otaku_script_dir $otaku_script_login
  

# Suppression des variables

unset otaku_script_login
unset otaku_script_dir