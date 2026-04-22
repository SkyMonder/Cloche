#!/bin/bash
set -e

echo "=== Установка Reckless 0.9.0 ==="
mkdir -p temp
cd temp

# Скачивание и распаковка (версия для AVX2)
wget -q https://github.com/codedeliveryservice/Reckless/releases/download/v0.9.0/Reckless-v0.9.0-avx2.zip
unzip -q Reckless-v0.9.0-avx2.zip

# Перемещение бинарника в корневую директорию
cp Reckless-v0.9.0-avx2/reckless-avx2 ../engine
cd ..
rm -rf temp
chmod +x ./engine

exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
