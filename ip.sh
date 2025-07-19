while true; do
    IP=$(curl --socks5-hostname 127.0.0.1:9050 -s icanhazip.com)
    echo -e "\e[32m$IP\e[0m"
    sleep 10
done
