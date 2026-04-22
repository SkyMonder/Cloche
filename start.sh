#!/bin/bash
set -e

echo "=== Установка Ethereal ==="
# Устанавливаем движок из официального репозитория Ubuntu.
apt-get update && apt-get install -y ethereal-chess

# Копируем бинарный файл в корневую директорию.
cp /usr/games/ethereal ./engine
chmod +x ./engine

echo "=== Запуск Ethereal ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
