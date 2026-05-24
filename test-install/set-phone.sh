#!/bin/sh

echo "=== Configuration pour écran smartphone (scale x2) ==="

xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2

echo "Scaling appliqué : x2"
