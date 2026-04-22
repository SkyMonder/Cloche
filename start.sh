#!/bin/bash
set -e

echo "=== Установка Ethereal 14.45 ==="
mkdir -p temp
cd temp
wget -q https://github.com/AndyGrant/Ethereal/releases/download/14.45/ethereal-14.45-linux-x86-64.zip
unzip -q ethereal-14.45-linux-x86-64.zip
cp ethereal-14.45-linux-x86-64/ethereal ../engine
cd ..
rm -rf temp
chmod +x ./engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
