#!/bin/bash
set -e

echo "=== Установка инструментов для компиляции Rust ==="
# Устанавливаем Rust, используя официальный скрипт (выбираем '1' для стандартной установки)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "=== Клонирование и компиляция Reckless ==="
git clone https://github.com/codedeliveryservice/Reckless.git
cd Reckless

# Компилируем в релизном режиме для максимальной производительности
# Это займет некоторое время, но делается один раз при сборке
cargo build --release

# Копируем готовый бинарник в корневую папку
cp target/release/reckless ../engine

cd ..
rm -rf Reckless
chmod +x ./engine

exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
