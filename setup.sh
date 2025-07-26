#!/bin/bash
set -e

function print_message {
    echo -e "\n==========================================="
    echo "$1"
    echo "===========================================\n"
}

# Tambah PATH permanen
if ! grep -q 'export PATH="$HOME/bin:$HOME/go/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$HOME/go/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/bin:$HOME/go/bin:$PATH"

mkdir -p ~/bin ~/bb_tools ~/go/bin ~/xray ~/html
chmod +x ~/bin

print_message "Update & Install minimal packages..."
sudo apt update -y && sudo apt full-upgrade -y
sudo apt install -y build-essential golang-go git wget unzip python3-pip \
    python3-setuptools python3-dev cmake libpcap-dev jq neofetch

print_message "Install Python tools..."
pip3 install --no-cache-dir uro dnspython dirsearch bhedak --break-system-packages

print_message "Install custom scripts..."
for script in bt.sh lab.sh gas.sh ip.sh; do
    if [ -f "$script" ]; then
        cp "$script" ~/bin/$(basename $script .sh)
        chmod +x ~/bin/$(basename $script .sh)
    fi
done

print_message "Install Golang tools..."
export GOBIN=~/bin
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/gf@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/hakluke/hakrawler@latest

print_message "Install RustScan..."
cd ~/bb_tools
wget -q https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan-2.3.0-x86_64-linux.zip
unzip -q rustscan-2.3.0-x86_64-linux.zip
mv rustscan-2.3.0-x86_64-linux/rustscan ~/bin/
rm -rf rustscan-2.3.0-x86_64-linux*

print_message "Install Nuclei..."
wget -q https://github.com/projectdiscovery/nuclei/releases/download/v3.4.7/nuclei_3.4.7_linux_amd64.zip
unzip -q nuclei_3.4.7_linux_amd64.zip
mv nuclei ~/bin/
rm -f nuclei_3.4.7_linux_amd64.zip

print_message "Install Ngrok..."
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip -q ngrok-stable-linux-amd64.zip
mv ngrok ~/bin/
rm -f ngrok-stable-linux-amd64.zip

print_message "Bersihkan cache untuk hemat storage..."
sudo apt clean
sudo rm -rf /var/lib/apt/lists/* ~/.cache ~/.npm

print_message "Setup selesai! Silakan jalankan 'source ~/.bashrc'."
