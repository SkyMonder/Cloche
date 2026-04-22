#!/bin/bash
set -e

echo "=== Установка Viridithas 18.0.0 ==="
mkdir -p temp
cd temp
# Прямая ссылка на официальный бинарник для Linux
wget -q https://github.com/cosmobobak/viridithas/releases/download/v18.0.0/viridithas-18.0.0-linux-v3.zip
unzip -q viridithas-18.0.0-linux-v3.zip
cp viridithas-18.0.0-linux-v3/viridithas ../engine
cd ..
rm -rf temp
chmod +x ./engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
