#!/usr/bin/env bash
#
# run-selkies.sh - Gestion du bureau Selkies-GStreamer (Wayland + WebRTC)
#
set -euo pipefail

COMPOSE_FILE="selkies.yml"
PROJECT_NAME="selkies"
SERVICE_URL="http://localhost:8080"
SERVICE_DESC="Selkies-GStreamer (Wayland + WebRTC)"

# --- Détection du moteur de conteneurs ---
detect_engine() {
    if [[ "${USE_PODMAN:-}" == "1" ]] || [[ "${1:-}" == "--podman" ]]; then
        COMPOSE_CMD="podman compose"
    elif [[ "${USE_DOCKER:-}" == "1" ]] || [[ "${1:-}" == "--docker" ]]; then
        COMPOSE_CMD="docker compose"
    elif command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
    elif command -v podman &>/dev/null; then
        COMPOSE_CMD="podman compose"
    else
        echo "Erreur: ni docker ni podman n'est disponible." >&2
        exit 1
    fi
}

# --- Commandes ---
do_start() {
    echo "Démarrage de ${SERVICE_DESC}..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d --build
    echo ""
    echo "✓ ${SERVICE_DESC} démarré"
    echo "  → Accès: ${SERVICE_URL}"
    echo "  → Utilisateur: desktop"
    echo "  → Mot de passe: desktop2025"
    echo ""
    echo "  ℹ  WebRTC = streaming fluide, faible latence"
    echo "  ℹ  Codec: H.264 software (x264) ou VA-API si GPU disponible"
    echo ""
}

do_stop() {
    echo "Arrêt de ${SERVICE_DESC}..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down
    echo "✓ Arrêté"
}

do_restart() {
    echo "Redémarrage de ${SERVICE_DESC}..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d --build
    echo ""
    echo "✓ ${SERVICE_DESC} redémarré"
    echo "  → Accès: ${SERVICE_URL}"
    echo ""
}

do_clean() {
    echo "Nettoyage de ${SERVICE_DESC} (conteneurs + volumes + images)..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down -v --remove-orphans --rmi local
    echo "✓ Nettoyé (volumes et images locales supprimés)"
}

do_status() {
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
}

do_logs() {
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" logs -f --tail 100
}

show_help() {
    cat <<EOF
╔══════════════════════════════════════════════════════════════╗
║  ${SERVICE_DESC}
╚══════════════════════════════════════════════════════════════╝

Usage: $(basename "$0") <commande> [options]

Commandes:
  start     Démarrer le bureau (build + up)
  stop      Arrêter le bureau
  restart   Redémarrer le bureau
  clean     Arrêter et supprimer volumes/images/données
  status    Afficher l'état des conteneurs
  logs      Afficher les logs en temps réel
  help      Afficher cette aide

Options:
  --podman  Forcer l'utilisation de Podman
  --docker  Forcer l'utilisation de Docker

Connexion:
  URL:           ${SERVICE_URL}
  Utilisateur:   desktop
  Mot de passe:  desktop2025

Architecture:
  • Compositor:  Sway (Wayland, wlroots)
  • Streaming:   Selkies-GStreamer (WebRTC)
  • Desktop:     XFCE4 (via XWayland)
  • Audio:       PulseAudio → WebRTC
  • Codec:       H.264 (x264 soft) / VA-API (si GPU)

Variables d'environnement:
  USE_PODMAN=1  Forcer Podman
  USE_DOCKER=1  Forcer Docker

Moteur: $(command -v docker &>/dev/null && echo "docker ✓" || echo "docker ✗") | $(command -v podman &>/dev/null && echo "podman ✓" || echo "podman ✗")
EOF
}

# --- Main ---
cd "$(dirname "$0")"

# Extraire l'option engine et la commande des arguments
ENGINE_OPT=""
CMD=""
for arg in "$@"; do
    case "$arg" in
        --podman|--docker) ENGINE_OPT="$arg" ;;
        *) CMD="$arg" ;;
    esac
done

detect_engine "$ENGINE_OPT"

case "${CMD}" in
    start)   do_start ;;
    stop)    do_stop ;;
    restart) do_restart ;;
    clean)   do_clean ;;
    status)  do_status ;;
    logs)    do_logs ;;
    help|*)  show_help ;;
esac
