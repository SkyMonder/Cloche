import os, chess, chess.engine
from fastapi import FastAPI, HTTPException

app = FastAPI()
engine = None

def init_engine():
    global engine
    # Пытаемся найти бинарник: сначала clover_engine, затем clover
    binary = "./clover_engine"
    if not os.path.exists(binary):
        binary = "./clover"
    engine = chess.engine.SimpleEngine.popen_uci(binary)
    engine.configure({
        "Skill Level": 20,
        "Hash": 64,
        "Threads": 1,
        "Move Overhead": 50,
    })

@app.on_event("startup")
async def startup():
    init_engine()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/get_move")
async def get_move(data: dict):
    try:
        fen = data.get("fen")
        move_time = data.get("move_time", 1.0)
        board = chess.Board(fen)
        result = engine.play(board, chess.engine.Limit(time=move_time))
        return {"move": result.move.uci() if result.move else None}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
