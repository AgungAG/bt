#!/bin/bash

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
apt full-upgrade && apt update -y

# Install packages wajib
print_message "Install paket dasar..."
apt install libcurl4-openssl-dev libssl-dev jq ruby-full libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev libffi-dev python3-dev python3-pip python3-setuptools libldns-dev git rename findutils nodejs npm neofetch screen speedtest-cli sqlmap tor unzip cmake wget curl gnupg -y

# Install Python tools
pip3 install uro dnspython

# Copy custom scripts
cp bt.sh /usr/local/bin/bt
cp lab.sh /usr/local/bin/lab
cp gas.sh /usr/local/bin/gas
cp ip.sh /usr/local/bin/cip
chmod +x /usr/local/bin/{bt,lab,gas,cip}

# Konfigurasi TOR
mv /etc/tor/torrc /etc/tor/torrc.bak || true
cp torrc /etc/tor/torrc
service tor restart

# Docker + Lab
print_message "Menginstal Docker..."
apt remove -y containerd || true
apt autoremove -y
apt install -y docker.io
systemctl enable --now docker
docker run --restart=always -d -p 8081:80 zxxsnxx/vulnlabyavuzlar || true

# Pastikan cmake & libpcap-dev terinstall
apt install -y cmake libpcap-dev

# Install Python 3.13 jika belum
if ! command -v python3.13 >/dev/null 2>&1; then
    print_message "Menginstal Python 3.13..."
    apt install python3.13 -y
    python3.13 -m pip install --upgrade pip --break-system-packages
fi

# Install Golang jika belum
if ! command -v go >/dev/null 2>&1; then
    print_message "Menginstal Golang..."
    wget https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
    sudo tar -xvf go1.24.5.linux-amd64.tar.gz
    sudo mv go /usr/local
fi

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOBIN=/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bash_profile
echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile
echo 'export GOBIN=/usr/local/bin' >> ~/.bash_profile
source ~/.bash_profile


# Install Go tools ke /usr/local/bin
print_message "Installing Golang tools..."
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/incogbyte/shosubgo@latest
go install github.com/gwen001/github-subdomains@latest
go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/OJ/gobuster/v3@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/httprobe@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/unfurl@latest
go install github.com/PentestPad/subzy@latest
go install github.com/takshal/freq@latest
go install github.com/Emoe/kxss@latest
go install github.com/rix4uni/xsschecker@latest
go install github.com/KathanP19/Gxss@latest

# CRTSH
if ! command -v crtsh >/dev/null 2>&1; then
    git clone https://github.com/YashGoti/crtsh.py.git
    cd crtsh.py && mv crtsh.py crtsh && chmod +x crtsh
    cp crtsh /usr/local/bin/
    cd ..
fi

# Dirsearch
pip3 install -U dirsearch --break-system-packages

# Arjun
git clone https://github.com/s0md3v/Arjun.git
cd Arjun
python3.13 -m pip install . --break-system-packages
cd ..

# Dirhunt
python3.13 -m pip install dirhunt --break-system-packages --ignore-installed click

# Bhedak
python3.13 -m pip install bhedak --break-system-packages

# .gau.toml
wget -O ~/.gau.toml https://raw.githubusercontent.com/lc/gau/refs/heads/master/.gau.toml

# ParamsPider
if ! command -v paramspider >/dev/null 2>&1; then
    git clone https://github.com/devanshbatham/paramspider
    cd paramspider
    python3.13 -m pip install . --break-system-packages
    cd ..
fi

# URLDedupe
if ! command -v urldedupe >/dev/null 2>&1; then
    git clone https://github.com/ameenmaali/urldedupe.git
    cd urldedupe && cmake CMakeLists.txt && make
    cp urldedupe /usr/local/bin
    cd ..
fi

# LUcek
if ! command -v lucek >/dev/null 2>&1; then
    git clone https://github.com/rootbakar/LUcek.git
    cd LUcek
    bash requirement-mac.sh
    cp lucek.py /usr/local/bin/lucek
    cd ..
fi

# RustScan
if ! command -v rustscan >/dev/null 2>&1; then
    wget https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan-2.3.0-x86_64-linux.zip
    unzip rustscan-2.3.0-x86_64-linux.zip
    cp rustscan-2.3.0-x86_64-linux/rustscan /usr/local/bin/
fi

# Nuclei
if ! command -v nuclei >/dev/null 2>&1; then
    mkdir Nuclei && cd Nuclei
    wget https://github.com/projectdiscovery/nuclei/releases/download/v3.4.7/nuclei_3.4.7_linux_amd64.zip
    unzip nuclei_3.4.7_linux_amd64.zip
    mv nuclei /usr/local/bin/
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
mv ngrok /usr/local/bin
rm ngrok.zip
which ngrok || echo "Ngrok gagal terinstall!"

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt -f install -y

# ChromeDriver
wget https://storage.googleapis.com/chrome-for-testing-public/128.0.6613.119/linux64/chromedriver-linux64.zip
unzip -o chromedriver-linux64.zip
mv chromedriver-linux64/chromedriver /usr/bin

# Loxs
git clone https://github.com/coffinxp/loxs.git
cd loxs
pip3 install -r requirements.txt
chmod *.sh

# Folder HTML
cd ~
mkdir -p html

# Tandai selesai
touch "$STAMP_FILE"
print_message "Ready to Bug Hunting... Semua tool sudah terpasang permanen."
