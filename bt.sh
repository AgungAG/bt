#!/bin/bash

# Fungsi untuk menangani Ctrl+C
cleanup() {
    echo -e "\n[!] Ctrl+C terdeteksi. Menghentikan ngrok dan server..."
    pkill ngrok
    pkill -f "http.server"
    exit 0
}

# Tangkap sinyal Ctrl+C (SIGINT)
trap cleanup SIGINT

# Masuk ke direktori HTML
cd ~/html || exit 1

# Jalankan server HTML di background
echo "[*] Menjalankan server lokal di port 8080..."
python3 -m http.server 8080 &

# Jalankan ngrok
echo "[*] Membuka tunnel ngrok..."
ngrok http 8080

# Cleanup tetap dijalankan kalau ngrok berhenti
cleanup
