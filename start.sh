#!/bin/bash
set -e

echo "=== Установка Clover ==="
mkdir -p temp
cd temp
wget -q https://github.com/lucametehau/CloverEngine/releases/download/3.0.3/clover_3.0.3_linux.zip
python3 -c "import zipfile; zipfile.ZipFile('clover_3.0.3_linux.zip').extractall()" || true
if [ -f "clover_3.0.3_linux/clover" ]; then
    cp clover_3.0.3_linux/clover ../engine
    chmod +x ../engine
else
    echo "Clover не найден, пропускаем"
fi
cd ..
rm -rf temp

echo "=== Запускаем движок Clover ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
