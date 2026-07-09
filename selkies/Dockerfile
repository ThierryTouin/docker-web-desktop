# =============================================================================
# Selkies-GStreamer WebRTC Desktop (Wayland + Sway)
# Bureau Linux accessible via navigateur avec WebRTC
# Base: Ubuntu 24.04 + Sway (Wayland) + Selkies-GStreamer
# =============================================================================
FROM ubuntu:24.04

LABEL maintainer="docker-web-desktop"
LABEL description="Wayland desktop with WebRTC streaming via Selkies-GStreamer"

ARG DEBIAN_FRONTEND=noninteractive
ARG SELKIES_VERSION=1.7.1

# --- Paquets système + Wayland + Desktop ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Base
    ca-certificates curl wget gnupg software-properties-common \
    sudo locales tzdata dbus dbus-x11 \
    # Wayland compositor
    sway swayidle swaylock xwayland \
    # Desktop environment (XFCE sous XWayland pour compatibilité apps)
    xfce4 xfce4-terminal xfce4-pulseaudio-plugin thunar mousepad \
    # Audio
    pulseaudio pavucontrol \
    # GStreamer (requis par Selkies)
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav gstreamer1.0-pulseaudio \
    gstreamer1.0-x gstreamer1.0-gl gstreamer1.0-vaapi \
    libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    # Python
    python3 python3-pip python3-venv python3-dev python3-gi \
    python3-websockets python3-xdg python3-gst-1.0 \
    # Outils
    xdg-utils xdg-user-dirs mesa-utils libgl1-mesa-dri \
    fonts-dejavu fonts-liberation2 fonts-noto-color-emoji \
    supervisor tini git \
    # Navigateur
    firefox \
    && rm -rf /var/lib/apt/lists/*

# --- Locale FR ---
RUN sed -i '/fr_FR.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=fr_FR.UTF-8 \
    LANGUAGE=fr_FR:fr \
    LC_ALL=fr_FR.UTF-8

# --- Utilisateur desktop ---
RUN useradd -m -s /bin/bash -G sudo,video,audio,render desktop && \
    echo "desktop:desktop" | chpasswd && \
    echo "desktop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/desktop

# --- Selkies-GStreamer (WebRTC) ---
RUN python3 -m pip install --break-system-packages --no-cache-dir \
    selkies-gstreamer==${SELKIES_VERSION}

# --- Selkies-GStreamer Web Frontend ---
RUN SELKIES_WEB_URL="https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-web_v${SELKIES_VERSION}.tar.gz" && \
    mkdir -p /opt/selkies-web && \
    curl -fsSL "$SELKIES_WEB_URL" | tar -xz -C /opt/selkies-web

# --- Configuration Sway (Wayland compositor headless) ---
RUN mkdir -p /home/desktop/.config/sway
COPY config/sway-config /home/desktop/.config/sway/config
RUN chown -R desktop:desktop /home/desktop/.config

# --- Supervisord ---
COPY config/supervisord.conf /etc/supervisor/conf.d/selkies.conf

# --- Entrypoint ---
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# --- Ports ---
# 8080: Interface web Selkies-GStreamer
EXPOSE 8080

# --- Volumes ---
VOLUME ["/home/desktop"]

# --- Healthcheck ---
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

USER desktop
WORKDIR /home/desktop

ENV XDG_RUNTIME_DIR=/tmp/runtime-desktop \
    WLR_BACKENDS=headless \
    WLR_LIBINPUT_NO_DEVICES=1 \
    WAYLAND_DISPLAY=wayland-0 \
    XDG_SESSION_TYPE=wayland \
    DISPLAY=:0 \
    PULSE_SERVER=unix:/tmp/pulseaudio.socket

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]
