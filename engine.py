import requests, urllib.parse, traceback
from fastapi import FastAPI, HTTPException

app = FastAPI()
HEADERS = {"User-Agent": "SkyBotinok/1.0 (https://lichess.org/@/SkyBotinok)"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/get_move")
async def get_move(data: dict):
    try:
        fen = data.get("fen")
        encoded = urllib.parse.quote(fen)
        url = f"https://lichess.org/api/cloud-eval?fen={encoded}&multiPv=1"
        resp = requests.get(url, headers=HEADERS, timeout=2.0)
        if resp.status_code == 200:
            result = resp.json()
            pvs = result.get('pvs')
            if pvs and len(pvs) > 0:
                moves = pvs[0].get('moves')
                if moves:
                    best_move = moves.split()[0]
                    return {"move": best_move}
        raise HTTPException(status_code=500, detail="No move")
    except Exception as e:
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
