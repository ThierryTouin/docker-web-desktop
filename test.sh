#!/bin/sh

set -e

echo "=== Installation XFCE sans démarrage automatique ==="

# Vérifier root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être lancé en root"
    exit 1
fi

# Activer community si nécessaire
sed -i 's/^#\(.*community.*\)$/\1/' /etc/apk/repositories

echo "=== Mise à jour ==="
apk update
apk upgrade

echo "=== Installation des composants ==="
apk add \
    xorg-server \
    xfce4 \
    xfce4-terminal \
    xfce4-screensaver \
    dbus \
    elogind \
    adw-gtk3 \
    adwaita-xfce-icon-theme \
    font-dejavu

echo "=== Services nécessaires ==="
rc-update add dbus
rc-update add elogind

service dbus start
service elogind start

echo "=== Création ~/.xinitrc ==="

TARGET_USER=${SUDO_USER:-$(logname)}

su - "$TARGET_USER" -c '
cat > ~/.xinitrc <<EOF
exec startxfce4
EOF
chmod +x ~/.xinitrc
'

echo ""
echo "Installation terminée."
echo ""
echo "Pour démarrer XFCE manuellement :"
echo "   startx"
