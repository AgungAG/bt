#!/bin/bash

# Function to display messages
function print_message {
    echo "==========================================="
    echo "$1"
    echo "==========================================="
}

# Function to check if a command is installed
function is_installed {
    command -v "$1" >/dev/null 2>&1

    if [ -f "/usr/bin/$1" ] || [ -f "/usr/local/bin/$1" ]; then
        return 0
    else
        return 1
    fi
}

# Pastikan hanya dijalankan di Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Script ini hanya untuk Linux. Sistem operasi Anda tidak didukung."
    exit 1
fi

# Mengupgrade
print_message "Proses Upgrade..."
sudo apt full-upgrade -y

# Memperbarui daftar paket
print_message "Memperbarui daftar paket untuk Linux..."
sudo apt update -y

# Tools Wajib
sudo apt install libcurl4-openssl-dev -y
sudo apt install libssl-dev -y
sudo apt install jq -y
sudo apt install ruby-full -y
sudo apt install libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev -y
sudo apt install build-essential libssl-dev libffi-dev python-dev -y
sudo apt install python-setuptools -y
sudo apt install libldns-dev -y
sudo apt install python-dnspython -y
sudo apt install git -y
sudo apt install rename -y
sudo apt install findutils -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo apt install python3-pip -y
sudo apt install neofetch -y
sudo apt install screen -y
sudo apt install speedtest-cli -y
sudo apt install wpscan -y
sudo apt install sqlmap -y
sudo apt install tor -y
sudo pip3 install uro
sudo pip3 install dnspython -y
sudo cp bt.sh /usr/local/bin/bt
sudo cp lab.sh /usr/local/bin/lab
sudo cp gas.sh /usr/local/bin/gas
sudo cp ip.sh /usr/local/bin/cip
sudo chmod +x /usr/local/bin/bt
sudo chmod +x /usr/local/bin/lab
sudo chmod +x /usr/local/bin/gas
sudo chmod +x /usr/local/bin/cip
sudo mv /etc/tor/torrc /etc/tor/torrc.b
sudo cp torrc /etc/tor/torrc
sudo service tor restart

# Run Lab Yavunzlar
sudo systemctl enable docker
docker run --restart=always -d -p 8081:80 zxxsnxx/vulnlabyavuzlar


# Deleting command using apt
print_message "Remove cmake, libpcap-dev..."
sudo apt remove cmake -y
sudo apt remove -y libpcap-dev
sudo apt remove ffuf -y
sudo rm -rf /usr/local/go
cd ~/

# Menginstal CMake dan libpcap
if ! is_installed cmake; then
    print_message "Menginstal CMake..."
    sudo apt install cmake -y
else
    print_message "CMake sudah terinstal."
fi

if ! is_installed libpcap-dev; then
    print_message "Menginstal libpcap..."
    sudo apt install libpcap-dev -y
else
    print_message "libpcap sudah terinstal."
fi

# Menginstal Python 3.11
if ! is_installed "python$python_version"; then
    print_message "Menginstal Python $python_version..."
    sudo apt install python3.13 -y
    python3.13 -m pip install --upgrade pip --break-system-packages
else
    print_message "Python $python_version sudah terinstal."
fi

# Creating folder for bug bounty tools
print_message "Creating bb_tools directory..."
mkdir -p ~/bb_tools
cd ~/bb_tools

# Installing Golang
if ! is_installed go; then
    print_message "Installing Golang..."
    sudo apt install golang-go -y
else
    print_message "Golang is already installed."
fi

# Installing Golang tools
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

# Copying Go tools to /usr/local/bin
print_message "Copying Go tools to /usr/local/bin..."
cd /usr/local/bin
sudo rm -f subfinder assetfinder shosubgo github-subdomains chaos ffuf gobuster naabu gau waybackurls katana hakrawler gf qsreplace httpx httprobe anew unfurl subzy freq kxss xsschecker arjun dirhunt urldedupe lucek rustscan crtsh Gxss 
sudo apt autoremove -y
cd ~/go/bin
sudo cp * /usr/local/bin/

# Returning to bb_tools directory
cd ~/bb_tools

# Installing CRTSH
if ! is_installed crtsh; then
    print_message "Installing CRTSH..."
    git clone https://github.com/YashGoti/crtsh.py.git
    cd crtsh.py
    mv crtsh.py crtsh
    chmod +x crtsh
    sudo cp crtsh /usr/local/bin/
else
    print_message "CRTSH is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

# Installing Dirsearch
if ! is_installed dirsearch; then
    print_message "Installing Dirsearch..."
    pip3 install -U dirsearch --break-system-packages
else
    print_message "Dirsearch is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

# Installing Arjun
print_message "Installing Arjun..."
git clone https://github.com/s0md3v/Arjun.git
cd Arjun
sudo python3.13 -m pip install . --break-system-packages

# Returning to bb_tools directory
cd ~/bb_tools

# Installing Dirhunt
print_message "Installing Dirhunt..."
sudo python3.13 -m pip install dirhunt --break-system-packages --ignore-installed click

# Returning to bb_tools directory
cd ~/bb_tools

# Installing Bhedak
sudo python3.13 -m pip install bhedak --break-system-packages

# Returning to bb_tools directory
cd ~/bb_tools

# Download .gau.toml
print_message "Downloading .gau.toml..."
wget https://raw.githubusercontent.com/lc/gau/refs/heads/master/.gau.toml
mv .gau.toml ~/

# Returning to bb_tools directory
cd ~/bb_tools

# Installing ParamsPider
if ! is_installed paramspider; then
    print_message "Installing ParamsPider..."
    git clone https://github.com/devanshbatham/paramspider
    cd paramspider
    sudo python3.13 -m pip install . --break-system-packages
else
    print_message "ParamsPider is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

# Installing URLDedupe
if ! is_installed urldedupe; then
    print_message "Installing URLDedupe..."
    git clone https://github.com/ameenmaali/urldedupe.git
    cd urldedupe
    cmake CMakeLists.txt
    make
    sudo cp urldedupe /usr/local/bin
else
    print_message "URLDedupe is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

# Installing LUcek
if ! is_installed LUcek; then
    print_message "Installing LUcek..."
    git clone https://github.com/rootbakar/LUcek.git
    cd LUcek
    bash requirement-mac.sh
    sudo cp lucek.py /usr/local/bin/lucek
else
    print_message "LUcek is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

# Installing RustScan
if ! is_installed rustscan; then
    print_message "Installing RustScan..."
    wget https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan-2.3.0-x86_64-linux.zip
    unzip rustscan-2.3.0-x86_64-linux.zip
    cd tmp
    cd rustscan-2.3.0-x86_64-linux
    sudo cp rustscan /usr/local/bin/
    sudo rm -f rustscan-2.3.0-x86_64-linux.zip
else
    print_message "RustScan is already installed."
fi

# Installing Nuclei
if ! is_installed nuclei; then
    mkdir Nuclei
    cd Nuclei
    wget https://github.com/projectdiscovery/nuclei/releases/download/v3.4.7/nuclei_3.4.7_linux_amd64.zip
    unzip nuclei_3.4.7_linux_amd64.zip
    sudo mv nuclei /usr/local/bin/
    nuclei -version
    nuclei
else
    print_message "Nuclei is already installed."
fi

# Returning to bb_tools directory
cd ~/bb_tools

mkdir xray
cd ~/xray
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip
unzip xray_linux_amd64.zip
rm xray_linux_amd64.zip

# Returning to bb_tools directory
cd ~/bb_tools

# Install ngrok
sudo apt install unzip -y
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin

cd
mkdir html

# Installing Loxs

#Clone the repository
git clone https://github.com/coffinxp/loxs.git
cd loxs
pip3 install -r requirements.txt	

#Chrome Installation
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

#Chrome Driver Installation
wget https://storage.googleapis.com/chrome-for-testing-public/128.0.6613.119/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
cd chromedriver-linux64 
sudo mv chromedriver /usr/bin

cd
cip

print_message "Ready to Bug Hunting..."
