import os, chess, requests, traceback
from fastapi import FastAPI, HTTPException
import urllib.parse

app = FastAPI()

# --- НАСТРОЙКИ ---
# Для brasche (атакующий API):
API_URL_BEST = "https://www.chessdb.cn/cdb.php"
# Для cloche (список ходов):
API_URL_LEGAL = "https://alpha.pawnpal.pbou.dev/standard/"
# --- КОНЕЦ НАСТРОЕК ---

def get_best_move_from_api(fen):
    """Запрашивает лучший ход у ChessDB"""
    try:
        # Кодируем FEN для URL
        encoded_fen = urllib.parse.quote(fen)
        params = {
            "action": "queryall",
            "board": encoded_fen
        }
        # Отправляем GET-запрос к API
        resp = requests.get(API_URL_BEST, params=params, timeout=2.0)
        if resp.status_code == 200:
            data = resp.json()
            # Ищем ход с максимальной оценкой
            best_move = max(data, key=lambda x: x.get('score', -9999))
            if best_move and best_move.get('move'):
                return best_move['move']
    except Exception as e:
        print(f"Ошибка ChessDB: {e}")
    return None

def get_legal_moves_from_api(fen):
    """Запрашивает список легальных ходов у Pawn Pal и выбирает первый"""
    try:
        # Кодируем FEN для URL
        encoded_fen = urllib.parse.quote(fen)
        url = f"{API_URL_LEGAL}{encoded_fen}"
        resp = requests.get(url, timeout=1.0)
        if resp.status_code == 200:
            moves = resp.json()
            if moves:
                # Выбираем первый ход из списка
                move = moves[0]
                return f"{move['from'].lower()}{move['to'].lower()}"
    except Exception as e:
        print(f"Ошибка Pawn Pal: {e}")
    return None

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/get_move")
async def get_move(data: dict):
    try:
        fen = data.get("fen")
        engine_type = data.get("type", "best") # type = "best" или "legal"
        
        move = None
        if engine_type == "best":
            move = get_best_move_from_api(fen)
        else:
            move = get_legal_moves_from_api(fen)
        
        if not move:
            raise HTTPException(status_code=500, detail="No move found")
        
        return {"move": move}
    except Exception as e:
        print(f"Критическая ошибка: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
