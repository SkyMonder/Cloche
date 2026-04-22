#!/bin/bash
set -e

echo "=== Установка Combusken ==="
mkdir -p temp
cd temp

# Скачиваем последнюю стабильную версию Combusken для Linux
wget -q https://github.com/mhib/combusken/releases/download/v1.3.0/combusken-1.3.0-linux-amd64.zip
unzip -q combusken-1.3.0-linux-amd64.zip

# Копируем бинарный файл в корневую директорию
cp combusken-1.3.0-linux-amd64/combusken ../engine

cd ..
rm -rf temp
chmod +x ./engine

# Запускаем веб-сервер для связи с Lichess
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
