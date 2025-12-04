#!/usr/bin/env bash

ASCEND_DEFAULT_DIR="${HOME}/.ascend"
GIT_ORG="dream11" # TODO: change this to dream-horizon-org

REPO_LIST=("testlab" "flockr" "ascend-panel" "ascend-astra")
BRANCH_LIST=("main" "temp/develop-merge" "feat/docker-compose" "main") # TODO: change branches to main/master

# Detect user's preferred git clone protocol (SSH or HTTPS)
get_git_clone_prefix () {
  local use_ssh=false

  # Check if user has configured git to use SSH instead of HTTPS
  if git config --get url."git@github.com:".insteadOf 2>/dev/null | grep -q "https://github.com/"; then
    use_ssh=true
  # Check if user has SSH configured in their git config
  elif git config --get core.sshCommand &>/dev/null; then
    use_ssh=true
  # Check if user has GitHub SSH key configured
  elif ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    use_ssh=true
  fi

  if [ "$use_ssh" = true ]; then
    echo "git@github.com:${GIT_ORG}"
  else
    echo "https://github.com/${GIT_ORG}"
  fi
}

# Create base directory if it doesn't exist
ensure_base_dir () {
  local base_dir=$1

  if [ ! -d "$base_dir" ]; then
    echo "Creating directory ${base_dir}..."
    mkdir -p "$base_dir" || {
      echo "❌ Failed to create directory ${base_dir}"
      exit 1
    }
  fi
}

get_package_manager () {
  # Check for apt (Debian/Ubuntu)
  if command -v apt &> /dev/null; then
    echo "apt"
  # Check for yum (RHEL/CentOS)
  elif command -v yum &> /dev/null; then
    echo "yum"
  # Check for dnf (Fedora)
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  # Check for brew (macOS)
  elif command -v brew &> /dev/null; then
    echo "brew"
  else
    echo "Package manager not supported. Supported package managers are: apt, yum, dnf, brew."
    exit 1
  fi
}

install_git () {
  local package_manager=$(get_package_manager)
  case $package_manager in
    "apt")
      sudo apt update
      sudo apt install -y git
      ;;
    "yum")
      sudo yum install -y git
      ;;
    "dnf")
      sudo dnf install -y git
      ;;
    "brew")
      sudo brew install git
      ;;
    *)
      echo "Package manager not supported for git install. Please install git manually."
      exit 1
  esac
  echo "git installed successfully."
}

install_docker () {
  local package_manager=$(get_package_manager)
  case $package_manager in
    "apt")
      sudo apt update
      sudo apt install -y docker.io
      sudo systemctl enable --now docker
      ;;
    "yum")
      sudo yum install -y docker
      sudo systemctl enable --now docker
      ;;
    "dnf")
      sudo dnf install -y docker
      sudo systemctl enable --now docker
      ;;
    "brew")
      sudo brew install docker
      sudo systemctl enable --now docker
      ;;
    *)
      echo "Package manager not supported for docker install. Please install docker manually."
      exit 1
  esac
  echo "docker installed successfully."
}

# install requirements if not already installed
install_requirements () {
  # git
  if ! command -v git &> /dev/null; then
    echo "git not found, installing..."
    install_git
  else
    echo "git is already installed."
  fi

  # docker
  if ! command -v docker &> /dev/null; then
    echo "docker not found, installing..."
    install_docker
  else
    echo "docker is already installed."
  fi
}

# checkout repos
checkout_repos () {
  local base_dir=$1
  local force=${2:-false}
  local git_prefix=$(get_git_clone_prefix)

  for index in "${!REPO_LIST[@]}"; do
    local repo="${REPO_LIST[${index}]}"
    local branch="${BRANCH_LIST[${index}]}"

    local repo_url="${git_prefix}/${repo}.git"
    local repo_dir="${base_dir}/${repo}"

    # Check if repo already exists
    if [ -d "${repo_dir}" ]; then
      if [ "$force" = true ]; then
        echo "Removing existing ${repo_dir}..."
        rm -rf "${repo_dir}"
      else
        echo "⚠️  Skipping ${repo} - directory already exists at ${repo_dir}"
        echo "   Use --force to overwrite existing repositories"
        continue
      fi
    fi

    # Clone the repository
    echo "Cloning repository from ${repo_url}..."
    git clone --branch "${branch}" --single-branch --depth 1 "${repo_url}" "${repo_dir}"

    if [ $? -eq 0 ]; then
      echo "✅ Successfully cloned ${repo} into ${repo_dir}"
    else
      echo "❌ Failed to clone ${repo}"
      exit 1
    fi
  done
}

start_services () {
  local base_dir=$1

  for repo in "${REPO_LIST[@]}"; do
    local repo_dir="${base_dir}/${repo}"

    if [ ! -d "${repo_dir}" ]; then
      echo "⚠️  Skipping ${repo} - directory does not exist"
      continue
    fi

    echo "Starting services for ${repo}..."
    cd "${repo_dir}" || continue

    if docker compose up -d 2>/dev/null; then
      echo "✅ Started ${repo} services"
    else
      echo "❌ Failed to start services for ${repo}"
    fi
  done
}

print_usage () {
  echo "Usage: $0 [OPTIONS] [BASE_DIR]"
  echo ""
  echo "Options:"
  echo "  --force, -f    Overwrite existing repositories"
  echo "  --help, -h     Show this help message"
  echo ""
  echo "Arguments:"
  echo "  BASE_DIR       Installation directory (default: ${ASCEND_DEFAULT_DIR})"
}

main () {
  local base_dir="${ASCEND_DEFAULT_DIR}"
  local force=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force|-f)
        force=true
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

  echo "🚀 Installing Ascend platform to ${base_dir}..."
  echo ""

  echo "📦 Installing requirements..."
  install_requirements

  echo ""
  echo "📁 Setting up installation directory..."
  ensure_base_dir "${base_dir}"

  echo ""
  echo "📥 Checking out repositories..."
  checkout_repos "${base_dir}" "${force}"

  echo ""
  echo "🐳 Starting dependent services..."
  start_services "${base_dir}"

  echo ""
  echo "✅ Ascend platform installed successfully in ${base_dir}"
  echo "🌐 Ascend started at http://localhost:9000"
}

main "$@"
