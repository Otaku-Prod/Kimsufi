#!/bin/sh

################################################
# TITRE: 07_chmod.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Modifier les droits d'un dossier
################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

read -p "Pour qui ? (ex: 'u' ou 'g'): " otaku_script_valeur1

read -p "Que fait-on ? (ex: '+' ou '-'): " otaku_script_valeur2

read -p "Quel changement ? (ex: 'rxw'): " otaku_script_valeur3

read -p "Ou ? (ex: '/'): " otaku_script_dir

# Autoriser l'utilisateur à créer des fichier dans le dossier root > pour que vs code puisse écrire

sudo chmod $otaku_script_valeur1$otaku_script_valeur2$otaku_script_valeur3 $otaku_script_dir
