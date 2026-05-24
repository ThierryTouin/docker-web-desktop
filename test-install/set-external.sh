#!/bin/sh

echo "=== Configuration pour écran externe (scale x1) ==="

xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 1

echo "Scaling appliqué : x1"
