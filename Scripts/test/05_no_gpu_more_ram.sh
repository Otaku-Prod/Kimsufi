#!/bin/sh

# Root ou Sudo ?

[ "$(id -u)" != 0 ] && exec sudo "$0"

echo "gpu_mem=16" | sudo tee -a /boot/config.txt > /dev/null
