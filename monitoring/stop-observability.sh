#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Stopping observability stack..."
docker compose -f "$ROOT_DIR/docker-compose.monitoring.yml" down

echo "Stopped."
