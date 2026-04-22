#!/bin/bash
set -e
echo "=== Установка Clover ==="
mkdir -p temp
cd temp
wget -q https://github.com/lucametehau/CloverEngine/releases/download/v4.1/clover-4.1-linux.zip
unzip -q clover-4.1-linux.zip
cp clover-4.1-linux/clover ../clover_engine
cd ..
chmod +x ./clover_engine
rm -rf temp
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
