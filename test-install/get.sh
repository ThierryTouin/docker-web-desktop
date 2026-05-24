#!/bin/sh

set -e

BASE_URL="https://raw.githubusercontent.com/ThierryTouin/docker-web-desktop/refs/heads/main/test-install"

SCRIPTS="setup-podroid-xfce4.sh start-xfce4.sh set-phone.sh set-external.sh"

echo "=== Téléchargement des scripts ==="

for script in $SCRIPTS; do
    echo "  -> $script"
    wget -q -O "$script" "$BASE_URL/$script"
    chmod +x "$script"
done

echo "=== Terminé ==="
