#!/bin/bash
set -e

echo "=== Установка Clover ==="
DOWNLOADED=false

# Функция для попытки скачать и распаковать
try_download() {
    local url=$1
    local output=$2
    echo "Попытка скачать с: $url"
    if wget -q --spider "$url"; then
        wget -q "$url" -O "$output"
        if [ -f "$output" ]; then
            echo "Файл $output успешно скачан."
            return 0
        fi
    fi
    echo "Не удалось скачать с $url"
    return 1
}

# Попытка 1: Скачать последнюю версию по тегу 'latest'
echo "Попытка 1: Поиск последней версии через GitHub API..."
LATEST_URL=$(curl -s https://api.github.com/repos/lucametehau/CloverEngine/releases/latest | grep "browser_download_url.*linux.zip" | cut -d '"' -f 4)
if [ -n "$LATEST_URL" ]; then
    if try_download "$LATEST_URL" "clover-latest.zip"; then
        unzip -q clover-latest.zip && chmod +x clover && mv clover ./clover_engine && DOWNLOADED=true
    fi
fi

# Попытка 2: Скачать версию 9.1 (если первая не удалась)
if [ "$DOWNLOADED" = false ]; then
    echo "Попытка 2: Скачать Clover 9.1..."
    try_download "https://github.com/lucametehau/CloverEngine/releases/download/9.1/clover-9.1-linux.zip" "clover-9.1.zip"
    if [ -f "clover-9.1.zip" ]; then
        unzip -q clover-9.1.zip && chmod +x clover && mv clover ./clover_engine && DOWNLOADED=true
    fi
fi

# Попытка 3: Скачать версию 8.2.1
if [ "$DOWNLOADED" = false ]; then
    echo "Попытка 3: Скачать Clover 8.2.1..."
    try_download "https://github.com/lucametehau/CloverEngine/releases/download/8.2.1/clover-8.2.1-linux.zip" "clover-8.2.1.zip"
    if [ -f "clover-8.2.1.zip" ]; then
        unzip -q clover-8.2.1.zip && chmod +x clover && mv clover ./clover_engine && DOWNLOADED=true
    fi
fi

# Попытка 4: Скачать скомпилированную версию от Jim Ablett (JA)
if [ "$DOWNLOADED" = false ]; then
    echo "Попытка 4: Скачать сборку Clover 7.1 от JA..."
    try_download "https://drive.proton.me/urls/SCB7KRZ3K8#0bbKRsdKLLcB" "clover-ja.zip"
    if [ -f "clover-ja.zip" ]; then
        unzip -q clover-ja.zip && chmod +x clover && mv clover ./clover_engine && DOWNLOADED=true
    fi
fi

# Если все попытки не удались, используем Stockfish как запасной вариант
if [ "$DOWNLOADED" = false ]; then
    echo "Не удалось загрузить Clover. Используем Stockfish в качестве запасного варианта."
    apt-get update && apt-get install -y stockfish
    cp /usr/games/stockfish ./clover_engine
    chmod +x ./clover_engine
fi

exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
