#!/bin/bash
set -e

echo "=== Установка Defenchess 2.3 ==="
mkdir -p temp
cd temp

# Скачивание бинарника Defenchess для Linux с проверенного источника
wget -q https://github.com/cetincan0/Defenchess/releases/download/2.3/defenchess-2.3-linux.zip
unzip -q defenchess-2.3-linux.zip

# Копирование бинарного файла в корневую директорию
cp defenchess-2.3-linux/defenchess ../engine

cd ..
rm -rf temp
chmod +x ./engine

# Запуск веб-сервера для связи с Lichess
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
