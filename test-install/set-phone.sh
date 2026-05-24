#!/bin/sh

echo "=== Configuration pour écran smartphone (scale x2) ==="

# Scaling factor GDK (GTK3/GTK4)
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -n -t int -s 2

# DPI élevé (96 x 2 = 192)
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 192

# Variable d'environnement pour les apps GTK en cours
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

echo "Scaling appliqué : x2 (DPI=192)"
echo ""
echo "Note : les applications déjà ouvertes peuvent nécessiter"
echo "un redémarrage pour prendre en compte le changement."
echo "Pour que GDK_SCALE persiste, ajoutez dans ~/.profile :"
echo "  export GDK_SCALE=2"
echo "  export GDK_DPI_SCALE=0.5"
