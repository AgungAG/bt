#!/bin/bash
set -e

# ===========================================
# Bug Bounty Tools Installer - Permanent v2
# ===========================================

STAMP_FILE="$HOME/.bb_tools_installed"

# Fungsi menampilkan pesan
function print_message {
    echo "==========================================="
    echo "$1"
    echo "==========================================="
}

# Cek apakah sudah pernah diinstall
if [ -f "$STAMP_FILE" ]; then
    print_message "Semua tools sudah terinstall. Tidak perlu install ulang."
    exit 0
fi

# Cek OS
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Script ini hanya untuk Linux."
    exit 1
fi

# Upgrade & update
print_message "Proses Upgrade & Update..."
sudo apt full-upgrade -y || true
sudo apt update -y

# Install packages wajib
print_message "Install paket dasar..."
sudo apt install -y \
    libcurl4-openssl-dev libssl-dev jq ruby-full \
    libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential \
    libgmp-dev zlib1g-dev libffi-dev python3-dev python3-pip \
    python3-setuptools libldns-dev git rename findutils \
    nodejs npm neofetch screen speedtest-cli sqlmap tor \
    unzip cmake wget curl

# Install Python tools
sudo pip3 install uro dnspython

# Copy custom scripts
sudo cp bt.sh /usr/local/bin/bt
sudo cp lab.sh /usr/local/bin/lab
sudo cp gas.sh /usr/local/bin/gas
sudo cp ip.sh /usr/local/bin/cip
sudo chmod +x /usr/local/bin/{bt,lab,gas,cip}

# Konfigurasi TOR
sudo mv /etc/tor/torrc /etc/tor/torrc.bak || true
sudo cp torrc /etc/tor/torrc
sudo service tor restart

# Docker + Lab
print_message "Menginstal Docker..."
sudo apt remove -y containerd || true
sudo apt autoremove -y
sudo apt install -y docker.io
sudo systemctl enable --now docker
docker run --restart=always -d -p 8081:80 zxxsnxx/vulnlabyavuzlar || true

# Pastikan cmake & libpcap-dev terinstall
sudo apt install -y cmake libpcap-dev

# Pastikan Python 3.13 ada
if ! command -v python3.13 >/dev/null 2>&1; then
    print_message "Menginstal Python 3.13..."
    sudo apt install python3.13 -y
    python3.13 -m pip install --upgrade pip --break-system-packages
fi

# Buat folder bug bounty tools
mkdir -p ~/bb_tools
cd ~/bb_tools

# Golang & path
if ! command -v go >/dev/null 2>&1; then
    print_message "Menginstal Golang..."
    sudo apt install -y golang-go
fi
if ! grep -q 'export PATH="$HOME/go/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

# Install Go tools
print_message "Installing Golang tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/incogbyte/shosubgo@latest
go install -v github.com/gwen001/github-subdomains@latest
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/OJ/gobuster/v3@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/hakluke/hakrawler@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/qsreplace@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/tomnomnom/unfurl@latest
go install -v github.com/PentestPad/subzy@latest
go install -v github.com/takshal/freq@latest
go install -v github.com/Emoe/kxss@latest
go install -v github.com/rix4uni/xsschecker@latest
go install -v github.com/KathanP19/Gxss@latest
sudo cp ~/go/bin/* /usr/local/bin/

# CRTSH
if ! command -v crtsh >/dev/null 2>&1; then
    git clone https://github.com/YashGoti/crtsh.py.git
    cd crtsh.py && mv crtsh.py crtsh && chmod +x crtsh
    sudo cp crtsh /usr/local/bin/
    cd ..
fi

# Dirsearch
pip3 install -U dirsearch --break-system-packages

# Arjun
git clone https://github.com/s0md3v/Arjun.git
cd Arjun
sudo python3.13 -m pip install . --break-system-packages
cd ..

# Dirhunt
sudo python3.13 -m pip install dirhunt --break-system-packages --ignore-installed click

# Bhedak
sudo python3.13 -m pip install bhedak --break-system-packages

# .gau.toml
wget -O ~/.gau.toml https://raw.githubusercontent.com/lc/gau/refs/heads/master/.gau.toml

# ParamsPider
if ! command -v paramspider >/dev/null 2>&1; then
    git clone https://github.com/devanshbatham/paramspider
    cd paramspider
    sudo python3.13 -m pip install . --break-system-packages
    cd ..
fi

# URLDedupe
if ! command -v urldedupe >/dev/null 2>&1; then
    git clone https://github.com/ameenmaali/urldedupe.git
    cd urldedupe && cmake CMakeLists.txt && make
    sudo cp urldedupe /usr/local/bin
    cd ..
fi

# LUcek
if ! command -v lucek >/dev/null 2>&1; then
    git clone https://github.com/rootbakar/LUcek.git
    cd LUcek
    bash requirement-mac.sh
    sudo cp lucek.py /usr/local/bin/lucek
    cd ..
fi

# RustScan
if ! command -v rustscan >/dev/null 2>&1; then
    wget https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan-2.3.0-x86_64-linux.zip
    unzip rustscan-2.3.0-x86_64-linux.zip
    sudo cp rustscan-2.3.0-x86_64-linux/rustscan /usr/local/bin/
fi

# Nuclei
if ! command -v nuclei >/dev/null 2>&1; then
    mkdir Nuclei && cd Nuclei
    wget https://github.com/projectdiscovery/nuclei/releases/download/v3.4.7/nuclei_3.4.7_linux_amd64.zip
    unzip nuclei_3.4.7_linux_amd64.zip
    sudo mv nuclei /usr/local/bin/
    cd ..
fi

# Xray
mkdir -p ~/xray && cd ~/xray
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip
unzip -o xray_linux_amd64.zip
rm xray_linux_amd64.zip

# Ngrok
print_message "Menginstal Ngrok..."
cd ~
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip -O ngrok.zip
unzip -o ngrok.zip
sudo mv ngrok /usr/local/bin
rm ngrok.zip
which ngrok || echo "Ngrok gagal terinstall!"

cd ~
mkdir -p html

# Loxs
git clone https://github.com/coffinxp/loxs.git
cd loxs
pip3 install -r requirements.txt

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt -f install -y

# ChromeDriver
wget https://storage.googleapis.com/chrome-for-testing-public/128.0.6613.119/linux64/chromedriver-linux64.zip
unzip -o chromedriver-linux64.zip
sudo mv chromedriver-linux64/chromedriver /usr/bin

# Tandai selesai
touch "$STAMP_FILE"
print_message "Ready to Bug Hunting... Semua tool sudah terpasang permanen."
