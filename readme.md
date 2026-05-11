# Docker Web Desktop

Bureau Linux accessible via navigateur web, compatible Docker et Podman.

## Utilisation rapide

```bash
./run-kasm.sh start
```

## Interface du script

```
./run-kasm.sh <commande> [options]

Commandes:
  start     Démarrer le bureau
  stop      Arrêter le bureau
  clean     Arrêter et supprimer volumes/données
  status    Afficher l'état des conteneurs
  logs      Afficher les logs en temps réel
  (aucune)  Afficher l'aide et infos de connexion

Options:
  --podman  Forcer l'utilisation de Podman
  --docker  Forcer l'utilisation de Docker
```

Le moteur (Docker ou Podman) est auto-détecté. Priorité : Docker > Podman.
Forçage possible via `--podman` ou variable `USE_PODMAN=1`.

## Connexion

- **URL**: https://localhost:6901
- **Utilisateur**: `kasm_user`
- **Mot de passe**: `kasm2025`

## Compatibilité ARM64 (Motorola Edge Pro / Android)

L'image est multi-arch (amd64 + arm64). Pour utiliser sur un smartphone via Termux + Podman :

```bash
# Dans Termux
pkg install podman
./run-kasm.sh start --podman
```

## Version de l'image

| Image | Version |
|-------|---------|
| kasmweb/ubuntu-jammy-desktop | 1.16.0 |

## Structure du projet

```
├── kasm.yml            # Compose Kasm
├── run-kasm.sh         # Script de gestion
└── readme.md
```

## Structure du projet

```
├── webtop.yml          # Compose Webtop
├── kasm.yml            # Compose Kasm
├── neko.yml            # Compose n.eko
├── run-webtop.sh       # Script de gestion Webtop
├── run-kasm.sh         # Script de gestion Kasm
├── run-neko.sh         # Script de gestion n.eko
├── config/
│   ├── webtop/         # Données persistantes Webtop
│   ├── kasm/           # Données persistantes Kasm
│   └── neko/           # Données persistantes n.eko
└── readme.md
```
