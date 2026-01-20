#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NETWORK_NAME="observability-net"

echo "Ensuring docker network '$NETWORK_NAME' exists..."
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  docker network create "$NETWORK_NAME"
  echo "Created network $NETWORK_NAME"
else
  echo "Network $NETWORK_NAME already exists"
fi

echo "Starting observability stack..."
docker compose -f "$ROOT_DIR/monitoring/docker-compose.monitoring.yml" up -d

echo "Done. URLs:"
echo "  Grafana:   http://localhost:3000 (admin / admin)"
echo "  Prometheus: http://localhost:9090"
echo "  Tempo:      http://localhost:3200"
