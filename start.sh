#!/bin/bash
set -e

echo "=== Установка Ethereal из официального репозитория ==="
# Обновляем список пакетов и устанавливаем ethereal-chess
apt-get update
apt-get install -y ethereal-chess

# После установки бинарник будет лежать в /usr/games/ethereal
cp /usr/games/ethereal ./engine
chmod +x ./engine

echo "=== Запуск Ethereal ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
