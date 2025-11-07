from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import uvicorn
import logging

from database import db_connection
from routers import stock_router, job_router, scheduler_router
from jobs.job_manager import JobManager

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 初始化任务管理器
job_manager = JobManager()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # 启动时执行
    logger.info("应用启动中...")
    
    # 注册所有任务
    job_manager.register_jobs()
    
    # 启动定时任务
    job_manager.start_all_jobs()
    
    yield
    
    # 关闭时执行
    logger.info("应用关闭中...")
    job_manager.stop_all_jobs()

# 创建FastAPI应用
app = FastAPI(
    title="股票数据API",
    description="基于FastAPI的股票数据采集和查询API",
    version="1.0.0",
    lifespan=lifespan
)

# 添加CORS中间件
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册路由
app.include_router(stock_router.router, prefix="/api/v1", tags=["stock"])
app.include_router(job_router.router, prefix="/api/v1", tags=["jobs"])
app.include_router(scheduler_router.router, tags=["scheduler"])

@app.get("/")
async def root():
    return {"message": "股票数据API服务运行中", "status": "healthy"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": "2025-01-01T00:00:00Z"}

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )