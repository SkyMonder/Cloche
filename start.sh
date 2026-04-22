#!/bin/bash
set -e
echo "=== Установка Clover 9.1 ==="
mkdir -p temp
cd temp
# Ссылка на последнюю версию
wget -q https://github.com/lucametehau/CloverEngine/releases/download/9.1/clover-9.1-linux.zip
unzip -q clover-9.1-linux.zip
cp clover-9.1-linux/clover ../clover_engine
cd ..
rm -rf temp
chmod +x ./clover_engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
