#!/bin/sh

######################################################
# TITRE: 05_no_gpu_more_ram.sh
#
# AUTEUR: Otaku-Prod
# VERSION: 1.0
# CREATION: 29/07/2022
# MODIFIE: 29/07/2022
#
# DESCRIPTION: Réduit l'utilisation de la mémoire GPU
######################################################

# Forcing de l'exécution du script en tant que "Root" ou "Sudo"
[ "$(id -u)" != 0 ] && echo "vous n'êtes pas root !"
echo "Tentative en sudo:" 
exec sudo bash "$0"

sudo echo "gpu_mem=16" | sudo tee -a /boot/config.txt > /dev/null
