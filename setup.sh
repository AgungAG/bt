#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ===========================================
# Bug Bounty Tools Installer - Permanent v2 (Cleaned)
# ===========================================

STAMP_FILE="$HOME/.bb_tools_installed"

print_message() {
    echo -e "\n==========================================="
    echo "$1"
    echo "===========================================\n"
}

install_script() {
    src="$1"
    dest="/usr/local/bin/$(basename "$src" .sh)"
    cp "$src" "$dest"
    chmod +x "$dest"
}

check_os() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        echo "Script ini hanya mendukung Linux."
        exit 1
    fi
}

init_apt() {
    print_message "Proses Upgrade & Update..."
    apt update -y && apt full-upgrade -y
}

install_base_packages() {
    print_message "Install paket dasar..."
    apt install -y --no-install-recommends \
        build-essential curl wget git unzip jq ruby-full python3 python3-pip \
        python3-dev python3-setuptools libssl-dev libffi-dev libxml2-dev \
        libxslt1-dev libgmp-dev libldns-dev zlib1g-dev nodejs npm screen \
        tor cmake rename gnupg neofetch speedtest-cli sqlmap
}

install_python_tools() {
    pip3 install --break-system-packages uro dnspython
}

configure_custom_scripts() {
    for script in bt.sh lab.sh gas.sh ip.sh; do
        install_script "$script"
    done
}

configure_tor() {
    TOR_CONF="/etc/tor/torrc"
    if [[ -f "$TOR_CONF" ]]; then
        mv "$TOR_CONF" "$TOR_CONF.bak"
    fi
    cp torrc "$TOR_CONF"
    systemctl restart tor
}

setup_docker_lab() {
    print_message "Menginstal Docker..."
    apt remove -y containerd || true
    apt autoremove -y
    apt install -y docker.io
    systemctl enable --now docker
    docker run --restart=always -d -p 8081:80 zxxsnxx/vulnlabyavuzlar || true
}

install_python_313() {
    if ! command -v python3.13 >/dev/null 2>&1; then
        print_message "Menginstal Python 3.13..."
        apt install -y python3.13
        python3.13 -m ensurepip --upgrade
        python3.13 -m pip install --upgrade pip --break-system-packages
    fi
}

install_golang() {
    if ! command -v go >/dev/null 2>&1; then
        print_message "Menginstal Golang..."
        wget https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
        tar -xvf go1.24.5.linux-amd64.tar.gz
        mv go /usr/local
        rm go1.24.5.linux-amd64.tar.gz
    fi

    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export GOBIN=/usr/local/bin
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$GOBIN

    grep -qxF "export PATH=\$PATH:/usr/local/go/bin" ~/.bash_profile || echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bash_profile
}

install_go_tools() {
    print_message "Installing Golang tools..."
    TOOLS=(
        github.com/projectdiscovery/subfinder/v2/cmd/subfinder
        github.com/tomnomnom/assetfinder
        github.com/incogbyte/shosubgo
        github.com/gwen001/github-subdomains
        github.com/projectdiscovery/chaos-client/cmd/chaos
        github.com/ffuf/ffuf/v2
        github.com/OJ/gobuster/v3
        github.com/projectdiscovery/naabu/v2/cmd/naabu
        github.com/lc/gau/v2/cmd/gau
        github.com/tomnomnom/waybackurls
        github.com/projectdiscovery/katana/cmd/katana
        github.com/hakluke/hakrawler
        github.com/tomnomnom/gf
        github.com/tomnomnom/qsreplace
        github.com/projectdiscovery/httpx/cmd/httpx
        github.com/tomnomnom/httprobe
        github.com/tomnomnom/anew
        github.com/tomnomnom/unfurl
        github.com/PentestPad/subzy
        github.com/takshal/freq
        github.com/Emoe/kxss
        github.com/rix4uni/xsschecker
        github.com/KathanP19/Gxss
    )
    for tool in "${TOOLS[@]}"; do
        go install "${tool}@latest"
    done
}

finalize_setup() {
    mkdir -p ~/html
    touch "$STAMP_FILE"
    print_message "Ready to Bug Hunting... Semua tool sudah terpasang permanen."
}

main() {
    if [[ -f "$STAMP_FILE" ]]; then
        print_message "Semua tools sudah terinstall. Tidak perlu install ulang."
        exit 0
    fi

    check_os
    init_apt
    install_base_packages
    install_python_tools
    configure_custom_scripts
    configure_tor
    setup_docker_lab
    install_python_313
    install_golang
    install_go_tools
    finalize_setup
}

main "$@"
