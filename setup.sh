#!/bin/bash

# ===============================
# Setup Script - Persistent Version (Updated)
# ===============================

# Fungsi menampilkan pesan
function print_message {
    echo "==========================================="
    echo "$1"
    echo "==========================================="
}

# Membuat folder permanen
mkdir -p ~/bin ~/bb_tools ~/go/bin ~/xray ~/html
chmod +x ~/bin

# Tambahkan PATH permanen ke ~/.bashrc jika belum ada
if ! grep -q 'export PATH="$HOME/bin:$HOME/go/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$HOME/go/bin:$PATH"' >> ~/.bashrc
fi

# Tambahkan PATH ke sesi ini agar langsung bisa digunakan
export PATH="$HOME/bin:$HOME/go/bin:$PATH"

# Pastikan hanya dijalankan di Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Script ini hanya untuk Linux. Sistem operasi Anda tidak didukung."
    exit 1
fi

# Update paket
print_message "Update & Upgrade paket..."
sudo apt update -y && sudo apt full-upgrade -y

# Install paket wajib
print_message "Menginstal paket wajib..."
sudo apt install -y \
    libcurl4-openssl-dev libssl-dev jq ruby-full \
    libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev \
    zlib1g-dev libffi-dev python3-dev python3-pip python3-setuptools \
    libldns-dev git rename findutils nodejs npm neofetch screen \
    speedtest-cli sqlmap tor unzip wget cmake

sudo pip3 install uro dnspython dirsearch bhedak --break-system-packages

# Salin script custom ke ~/bin
print_message "Menyalin script custom..."
cp bt.sh ~/bin/bt
cp lab.sh ~/bin/lab
cp gas.sh ~/bin/gas
cp ip.sh ~/bin/cip
chmod +x ~/bin/*

# Setup Tor dengan konfigurasi custom
print_message "Setup Tor..."
mkdir -p ~/.tor
cp torrc ~/.tor/torrc

# Tambahkan alias torcustom ke ~/.bashrc jika belum ada
if ! grep -q 'alias torcustom=' ~/.bashrc; then
    echo 'alias torcustom="tor -f \$HOME/.tor/torrc"' >> ~/.bashrc
fi

# Aktifkan alias torcustom untuk sesi ini
alias torcustom="tor -f $HOME/.tor/torrc"

# Golang & Tools
print_message "Instal Golang tools..."
sudo apt install -y golang-go
cd ~/bb_tools

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

# Install CRTSH
print_message "Install CRTSH..."
if [ ! -f ~/bin/crtsh ]; then
    git clone https://github.com/YashGoti/crtsh.py.git
    cd crtsh.py
    mv crtsh.py ~/bin/crtsh
    chmod +x ~/bin/crtsh
fi

# Install Arjun
print_message "Install Arjun..."
git clone https://github.com/s0md3v/Arjun.git ~/bb_tools/Arjun
cd ~/bb_tools/Arjun
sudo python3 -m pip install . --break-system-packages

# Install Dirhunt
print_message "Install Dirhunt..."
sudo python3 -m pip install dirhunt --break-system-packages --ignore-installed click

# Install ParamsPider
print_message "Install ParamsPider..."
git clone https://github.com/devanshbatham/paramspider ~/bb_tools/paramspider
cd ~/bb_tools/paramspider
sudo python3 -m pip install . --break-system-packages

# Install URLDedupe
print_message "Install URLDedupe..."
git clone https://github.com/ameenmaali/urldedupe.git ~/bb_tools/urldedupe
cd ~/bb_tools/urldedupe
cmake CMakeLists.txt && make
cp urldedupe ~/bin/

# Install RustScan
print_message "Install RustScan..."
cd ~/bb_tools
wget https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan-2.3.0-x86_64-linux.zip
unzip rustscan-2.3.0-x86_64-linux.zip
mv rustscan-2.3.0-x86_64-linux/rustscan ~/bin/

# Install Nuclei
print_message "Install Nuclei..."
cd ~/bb_tools
wget https://github.com/projectdiscovery/nuclei/releases/download/v3.4.7/nuclei_3.4.7_linux_amd64.zip
unzip nuclei_3.4.7_linux_amd64.zip
mv nuclei ~/bin/

# Install Xray
print_message "Install Xray..."
cd ~/xray
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip
unzip xray_linux_amd64.zip
chmod +x xray
mv xray ~/bin/

# Install Ngrok
print_message "Install Ngrok..."
cd ~/bb_tools
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
mv ngrok ~/bin/

print_message "Setup selesai! Semua tools bisa langsung digunakan tanpa source ulang."
