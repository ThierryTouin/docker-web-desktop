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

echo "=== Configuration de dbus ==="
mkdir -p /run/dbus
if [ ! -f /var/lib/dbus/machine-id ]; then
    dbus-uuidgen > /var/lib/dbus/machine-id
fi

echo "=== Lancement de dbus ==="
dbus-daemon --system --nofork --nopidfile &
sleep 1

echo "=== Lancement de XFCE ==="
export XDG_RUNTIME_DIR="/tmp/runtime-$(whoami)"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

export DBUS_SESSION_BUS_ADDRESS="$(dbus-daemon --session --fork --print-address)"

startxfce4 &

echo ""
echo "=== Installation terminée, XFCE démarré ==="
echo ""
echo "Pour relancer XFCE après un redémarrage du container :"
echo "   startxfce4"
