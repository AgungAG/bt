#!/bin/bash

cd ~/html
python3 -m http.server 8080 &
ngrok http 8080
