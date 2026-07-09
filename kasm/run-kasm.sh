#!/usr/bin/env bash
#
# run-kasm.sh - Gestion du bureau Kasm Workspaces
#
set -euo pipefail

COMPOSE_FILE="kasm.yml"
PROJECT_NAME="kasm"
SERVICE_URL="https://localhost:6901"
SERVICE_DESC="Kasm Workspaces (Ubuntu Jammy + KasmVNC)"

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
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d
    echo ""
    echo "✓ ${SERVICE_DESC} démarré"
    echo "  → Accès: ${SERVICE_URL}"
    echo "  → Utilisateur: kasm_user"
    echo "  → Mot de passe: kasm2025"
    echo ""
}

do_stop() {
    echo "Arrêt de ${SERVICE_DESC}..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down
    echo "✓ Arrêté"
}

do_clean() {
    echo "Nettoyage de ${SERVICE_DESC} (conteneurs + volumes)..."
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down -v --remove-orphans
    echo "✓ Nettoyé"
}

do_status() {
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
}

do_logs() {
    $COMPOSE_CMD -f "$COMPOSE_FILE" -p "$PROJECT_NAME" logs -f --tail 100
}

show_help() {
    cat <<EOF
╔══════════════════════════════════════════════════════════╗
║  ${SERVICE_DESC}
╚══════════════════════════════════════════════════════════╝

Usage: $(basename "$0") <commande> [options]

Commandes:
  start     Démarrer le bureau
  stop      Arrêter le bureau
  clean     Arrêter et supprimer volumes/données
  status    Afficher l'état des conteneurs
  logs      Afficher les logs en temps réel

Options:
  --podman  Forcer l'utilisation de Podman
  --docker  Forcer l'utilisation de Docker

Connexion:
  URL:           ${SERVICE_URL}
  Mot de passe:  kasm2025
  (accès via navigateur, certificat auto-signé)

Variables d'environnement:
  USE_PODMAN=1  Forcer Podman
  USE_DOCKER=1  Forcer Docker

Moteur: $(command -v docker &>/dev/null && echo "docker ✓" || echo "docker ✗") | $(command -v podman &>/dev/null && echo "podman ✓" || echo "podman ✗")
EOF
}

# --- Main ---
cd "$(dirname "$0")"

# Extraire l'option engine des arguments
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
    start)  do_start ;;
    stop)   do_stop ;;
    clean)  do_clean ;;
    status) do_status ;;
    logs)   do_logs ;;
    *)      show_help ;;
esac
