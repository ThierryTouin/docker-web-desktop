#!/usr/bin/env bash
#
# entrypoint.sh - Démarrage des services Selkies-GStreamer + Sway
#
set -e

echo "=== Selkies-GStreamer WebRTC Desktop ==="
echo "    Wayland (Sway) + WebRTC streaming"
echo ""

# --- Création du runtime directory ---
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/runtime-desktop}"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# --- Création des répertoires utilisateur ---
mkdir -p /home/desktop/.config
mkdir -p /home/desktop/Documents
mkdir -p /home/desktop/Téléchargements
xdg-user-dirs-update 2>/dev/null || true

# --- Configuration PulseAudio ---
mkdir -p /home/desktop/.config/pulse
cat > /home/desktop/.config/pulse/default.pa <<'PULSE'
load-module module-null-sink sink_name=selkies_sink sink_properties=device.description="Selkies_Audio"
set-default-sink selkies_sink
load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket
load-module module-always-sink
PULSE

# --- Détection GPU / Encodeur ---
if [ -d /dev/dri ] && ls /dev/dri/render* &>/dev/null; then
    echo "[GPU] Périphérique DRI détecté, VA-API disponible"
    export SELKIES_ENCODER="${SELKIES_ENCODER:-vah264enc}"
else
    echo "[CPU] Pas de GPU détecté, encodage software (x264)"
    export SELKIES_ENCODER="${SELKIES_ENCODER:-x264enc}"
fi

# --- Lancement via supervisord ---
echo "[START] Lancement des services..."
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/selkies.conf
