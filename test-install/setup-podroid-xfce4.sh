#!/bin/sh

set -e

echo "=== Installation du bureau XFCE pour Podroid ==="

# Vérifier root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être lancé en root"
    exit 1
fi

# Activer le dépôt community si nécessaire
sed -i 's/^#\(.*community.*\)$/\1/' /etc/apk/repositories

echo "=== Mise à jour des paquets ==="
apk update
apk upgrade

echo "=== Installation de XFCE et dépendances ==="
apk add \
    xfce4 \
    xfce4-terminal \
    xfce4-screensaver \
    dbus \
    adw-gtk3 \
    adwaita-xfce-icon-theme \
    font-dejavu

echo ""
echo "=== Installation terminée ==="
echo ""
echo "Pour démarrer XFCE :"
echo "   ./start-xfce4.sh"
echo ""
echo "Pour changer le scaling :"
echo "   Smartphone : ./set-phone.sh"
echo "   Écran externe : ./set-external.sh"
echo ""
