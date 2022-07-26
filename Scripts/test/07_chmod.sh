#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

read -p "Pour qui ? (ex: 'u' ou 'g'): " otaku_script_valeur1

read -p "Que fait-on ? (ex: '+' ou '-'): " otaku_script_valeur2

read -p "Quel changement ? (ex: 'rxw'): " otaku_script_valeur3

read -p "Ou ? (ex: '/'): " otaku_script_dir

# Autoriser l'utilisateur à créer des fichier dans le dossier root > pour que vs code puisse écrire

chmod $otaku_script_valeur1$otaku_script_valeur2$otaku_script_valeur3 $otaku_script_dir
