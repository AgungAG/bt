#!/bin/bash

# Nama image di Docker Hub
REMOTE_IMAGE="ageajah/age"

# Ambil container yang aktif
CONTAINER_ID=$(docker ps -q | head -n 1)

if [ -z "$CONTAINER_ID" ]; then
    echo "❌ Tidak ada container aktif!"
    exit 1
fi

# Tag lokal sementara
LOCAL_IMAGE="age-temp:latest"

# Commit container jadi image lokal
echo "⚡ Commit container $CONTAINER_ID menjadi image lokal $LOCAL_IMAGE"
docker commit $CONTAINER_ID $LOCAL_IMAGE

# Tag versi timestamp
TAG=${1:-$(date +%Y%m%d%H%M)}
docker tag $LOCAL_IMAGE $REMOTE_IMAGE:$TAG
docker tag $LOCAL_IMAGE $REMOTE_IMAGE:latest

# Push ke Docker Hub
echo "📤 Push $REMOTE_IMAGE ke Docker Hub..."
docker push $REMOTE_IMAGE:$TAG
docker push $REMOTE_IMAGE:latest

echo "✅ Selesai! Image tersedia di Docker Hub:"
echo "   👉 $REMOTE_IMAGE:$TAG"
echo "   👉 $REMOTE_IMAGE:latest"
