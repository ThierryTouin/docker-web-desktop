#!/bin/sh

set -e

echo "=== Démarrage de XFCE4 ==="

# Configuration de dbus
mkdir -p /run/dbus
if [ ! -f /var/lib/dbus/machine-id ]; then
    dbus-uuidgen > /var/lib/dbus/machine-id
fi

# Lancement de dbus system
dbus-daemon --system --nofork --nopidfile &
sleep 1

# Variables d'environnement
export XDG_RUNTIME_DIR="/tmp/runtime-$(whoami)"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

export DBUS_SESSION_BUS_ADDRESS="$(dbus-daemon --session --fork --print-address)"

# Lancement de XFCE
startxfce4 &

echo ""
echo "=== XFCE4 démarré ==="
echo ""
echo "Pour changer le scaling :"
echo "  Smartphone : ./set-phone.sh"
echo "  Écran externe : ./set-external.sh"
echo ""
