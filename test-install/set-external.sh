#!/bin/sh

echo "=== Configuration pour écran externe (scale x1) ==="

# Scaling factor GDK (GTK3/GTK4)
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -n -t int -s 1

# DPI standard
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 96

# Variable d'environnement pour les apps GTK en cours
export GDK_SCALE=1
unset GDK_DPI_SCALE

echo "Scaling appliqué : x1 (DPI=96)"
echo ""
echo "Note : les applications déjà ouvertes peuvent nécessiter"
echo "un redémarrage pour prendre en compte le changement."
echo "Pour que GDK_SCALE persiste, ajoutez dans ~/.profile :"
echo "  export GDK_SCALE=1"
