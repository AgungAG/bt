#!/bin/bash

# Fungsi untuk membersihkan saat Ctrl+C ditekan
function cleanup {
    echo -e "\n[+] Menghentikan ngrok dan Docker container..."
    pkill ngrok
    docker stop vulnlab
    docker rm vulnlab
    echo "[✓] Semua proses dihentikan."
    exit 0
}

# Tangkap sinyal Ctrl+C (SIGINT)
trap cleanup SIGINT

# Aktifkan Docker agar otomatis jalan saat boot
echo "[+] Mengaktifkan Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# Jalankan container Docker
echo "[+] Menjalankan Docker container..."
docker run --restart=always --name vulnlab -d -p 8081:80 zxxsnxx/vulnlabyavuzlar

# Jalankan ngrok di background
echo "[+] Menjalankan ngrok..."
ngrok http 8081 &

# Tampilkan info
echo "[*] Tekan Ctrl+C untuk menghentikan semua proses."

# Tunggu selamanya (supaya trap bisa aktif)
while true; do
    sleep 1
done
