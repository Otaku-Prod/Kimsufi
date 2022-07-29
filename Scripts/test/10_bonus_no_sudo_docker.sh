#!/bin/sh

############################################################
# TITRE: 10_bonus_no_sudo_docker.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Ajout d'un utilisateur dans le groupe Docker
############################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

# Saisie des informations

read -p "Qui utilisera docker ? (ex: 'kevin'): " otaku_script_login

# Pour éviter de taper sudo chaque fois que vous exécutez la commande docker

sudo usermod -aG docker $otaku_script_login

# Pour appliquer la nouvelle appartenance au groupe

su - $otaku_script_login

echo "Attention vous êtes de retour à votre répertoire par défaut !"

# Suppression des variables

unset otaku_script_login