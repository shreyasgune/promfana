from fastapi import FastAPI, Request, HTTPException
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST, REGISTRY
from starlette.responses import Response
from pydantic import BaseModel
import time
import psutil

app = FastAPI()

# Pydantic model for item creation
class Item(BaseModel):
    name: str

# In-memory storage for items
items = {}

# Custom metrics
REQUEST_COUNT = Counter('http_request_total', 'Total HTTP Requests', ['method', 'status', 'path'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP Request Duration', ['method', 'status', 'path'])
REQUEST_IN_PROGRESS = Gauge('http_requests_in_progress', 'HTTP Requests in progress', ['method', 'path'])

# System metrics
CPU_USAGE = Gauge('process_cpu_usage', 'Current CPU usage in percent')
MEMORY_USAGE = Gauge('process_memory_usage_bytes', 'Current memory usage in bytes')

def update_system_metrics():
    CPU_USAGE.set(psutil.cpu_percent())
    MEMORY_USAGE.set(psutil.Process().memory_info().rss)

@app.middleware("http")
async def monitor_requests(request: Request, call_next):
    method = request.method
    path = request.url.path

    REQUEST_IN_PROGRESS.labels(method=method, path=path).inc()
    
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    
    status = response.status_code
    REQUEST_COUNT.labels(method=method, status=status, path=path).inc()
    REQUEST_LATENCY.labels(method=method, status=status, path=path).observe(duration)
    REQUEST_IN_PROGRESS.labels(method=method, path=path).dec()

    return response

@app.get("/")
async def root():
    return {"message": "Hello Shreyas"}

@app.post("/items")
async def create_item(item: Item):
    item_id = len(items) + 1
    items[item_id] = item.name
    return {"item_id": item_id, "name": item.name, "status": "created"}

@app.get("/items/{item_id}")
async def read_item(item_id: int):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"item_id": item_id, "name": items[item_id]}

@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    items[item_id] = item.name
    return {"item_id": item_id, "name": item.name, "status": "updated"}

@app.delete("/items/{item_id}")
async def delete_item(item_id: int):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    del items[item_id]
    return {"item_id": item_id, "status": "deleted"}

@app.get("/metrics")
async def metrics():
    update_system_metrics()
    return Response(generate_latest(REGISTRY), media_type=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)