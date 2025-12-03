#!/bin/bash

ASCEND_DEFAULT_DIR="${HOME}/.ascend"
GIT_REPO_BASE_URL="https://github.com/dream-horizon-org"

# WORKS ONLY WHEN THEY ARE MADE PUBLIC
REPO_LIST=("testlab" "flockr" "ascend-panel")
BRANCH_LIST=("main" "master" "main")

# install requirements if not already installed
install_requirements_linux () {
    # git
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo "git not found, installing..."
        # Check for apt (Debian/Ubuntu)
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y git
        # Check for yum (RHEL/CentOS)
        elif command -v yum &> /dev/null; then
            sudo yum install -y git
        # Check for dnf (Fedora)
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y git
        else
            echo "Package manager not supported for git install. Please install git manually."
            exit 1
        fi
    else
        echo "git is already installed."
    fi

    # unzip
    # Check if unzip is installed
    if ! command -v unzip &> /dev/null; then
        echo "unzip not found, installing..."
        # Check for apt (Debian/Ubuntu)
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y unzip
        # Check for yum (RHEL/CentOS)
        elif command -v yum &> /dev/null; then
            sudo yum install -y unzip
        # Check for dnf (Fedora)
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y unzip
        else
            echo "Package manager not supported for unzip install. Please install unzip manually."
            exit 1
        fi
    else
        echo "unzip is already installed."
    fi

    # docker
    # Check if docker is installed
    if ! command -v docker &> /dev/null; then
        echo "docker not found, installing..."
        # Check for apt (Debian/Ubuntu)
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y docker.io
            sudo systemctl enable --now docker
        # Check for yum (RHEL/CentOS)
        elif command -v yum &> /dev/null; then
            sudo yum install -y docker
            sudo systemctl enable --now docker
        # Check for dnf (Fedora)
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y docker
            sudo systemctl enable --now docker
        else
            echo "Package manager not supported for docker install. Please install docker manually."
            exit 1
        fi
    else
        echo "docker is already installed."
    fi
}

# checkout repos
checkout_repos () {

    local base_dir=$1

    for index in "${!REPO_LIST[@]}"; do
        local repo="${REPO_LIST[${index}]}"
        local branch="${BRANCH_LIST[${index}]}"

        REPO_ZIP_URL="${GIT_REPO_BASE_URL}/${repo}/archive/refs/heads/${branch}.zip"
        REPO_DIR="${base_dir}/${repo}"

        # Download the ZIP file
        echo "Downloading repository zip from $REPO_ZIP_URL..."
        curl -L -o ${repo}.zip "$REPO_ZIP_URL"

        # Unzip the repo into REPO_DIR
        echo "Unzipping repository into ${REPO_DIR}..."
        unzip -qq ${repo}.zip -d "${base_dir}"
        mv "${base_dir}/${repo}-${branch}" "${REPO_DIR}"

        # Clean up zip file
        rm ${repo}.zip
    done
}

start_services () {

    local base_dir=$1

    for repo in "${REPO_LIST[@]}"; do
        local repo_dir="${base_dir}/${repo}"
        cd "${repo_dir}"
        docker compose up -d
    done
}

main () {

    local base_dir=${1:-${ASCEND_DEFAULT_DIR}}
    install_requirements_linux
    checkout_repos "${base_dir}"
    start_services "${base_dir}"
    echo "Ascend platform installed successfully in ${base_dir}"
}

main "$@"
