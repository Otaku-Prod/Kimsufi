#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

# Saisie des informations

read -p "Qui utilisera docker ? (ex: 'kevin'): " otaku_script_login

# Pour éviter de taper sudo chaque fois que vous exécutez la commande docker

usermod -aG docker $otaku_script_login

# Pour appliquer la nouvelle appartenance au groupe

su - $otaku_script_login

# Suppression des variables

unset otaku_script_login