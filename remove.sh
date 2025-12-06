#!/usr/bin/env bash

ASCEND_DEFAULT_DIR="${HOME}/.ascend"

REPO_LIST=("testlab" "flockr" "ascend-panel" "ascend-astra")

# stop and remove containers
stop_containers () {
  local base_dir=$1
  local remove_volumes=${2:-true}

  if [ ! -d "$base_dir" ]; then
    echo "Directory ${base_dir} does not exist. Skipping container removal."
    return 0
  fi

  cd "$base_dir" || exit 1

  for repo in "${REPO_LIST[@]}"; do
    local repo_dir="${base_dir}/${repo}"
    if [ -d "${repo_dir}" ]; then
      echo "🛑 Stopping containers for ${repo}..."
      cd "${repo_dir}" || continue
      if [ "$remove_volumes" = true ]; then
        docker compose down -v 2>/dev/null || echo "⚠️  Warning: Failed to stop containers for ${repo}"
      else
        docker compose down 2>/dev/null || echo "⚠️  Warning: Failed to stop containers for ${repo}"
      fi
      cd "$base_dir" || exit 1
    else
      echo "⚠️  Skipping ${repo} - directory does not exist"
    fi
  done
}

# prune unused docker resources
prune_docker () {
  echo "🧹 Pruning unused Docker resources..."
  docker system prune -f 2>/dev/null || echo "⚠️  Warning: Failed to prune Docker resources"
}

# remove base directory
remove_base_dir () {
  local base_dir=$1

  if [ ! -d "$base_dir" ]; then
    echo "Directory ${base_dir} does not exist. Nothing to remove."
    return 0
  fi

  echo "🗑️  Removing ${base_dir}..."
  rm -rf "${base_dir}"
}

# confirm action with user
confirm_removal () {
  local base_dir=$1
  local containers_only=$2

  if [ "$containers_only" = true ]; then
    echo "⚠️  WARNING: This will stop all Ascend containers"
  else
    echo "⚠️  WARNING: This will remove all Ascend services and data from ${base_dir}"
    echo "This action cannot be undone."
  fi
  read -p "Are you sure you want to continue? (y/N): " -r response

  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      echo "Operation cancelled."
      exit 0
      ;;
  esac
}

print_usage () {
  echo "Usage: $0 [OPTIONS] [BASE_DIR]"
  echo ""
  echo "Options:"
  echo "  --stop-only, -s    Stop containers only (keep directories and images)"
  echo "  --yes, -y          Skip confirmation prompt"
  echo "  --help, -h         Show this help message"
  echo ""
  echo "Arguments:"
  echo "  BASE_DIR           Installation directory (default: ${ASCEND_DEFAULT_DIR})"
}

main () {
  local base_dir="${ASCEND_DEFAULT_DIR}"
  local skip_confirm=false
  local stop_only=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --stop-only|-s)
        stop_only=true
        shift
        ;;
      --yes|-y)
        skip_confirm=true
        shift
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      *)
        base_dir="$1"
        shift
        ;;
    esac
  done

  # Confirm with user
  if [ "$skip_confirm" = false ]; then
    confirm_removal "${base_dir}" "${stop_only}"
  fi

  if [ "$stop_only" = true ]; then
    echo "🛑 Stopping Ascend services in ${base_dir}..."
    echo ""
    stop_containers "${base_dir}" false
    echo ""
    echo "✅ Ascend services stopped successfully."
    echo "   Directories and images preserved."
  else
    echo "🗑️  Removing Ascend services from ${base_dir}..."
    echo ""
    stop_containers "${base_dir}" true
    remove_base_dir "${base_dir}"
    prune_docker
    echo ""
    echo "✅ Ascend services removed successfully."
  fi
}

main "$@"
