# 股票数据API项目

基于FastAPI的股票数据采集和查询API服务，集成akshare数据源和PostgreSQL数据库。

## 功能特性

- ✅ FastAPI Web API框架
- ✅ 定时任务自动采集股票数据
- ✅ PostgreSQL数据库存储
- ✅ akshare数据源集成
- ✅ RESTful API接口
- ✅ 实时数据查询
- ✅ 历史数据查询
- ✅ 数据管理功能

## 项目结构

```
apipy/
├── main.py                 # 主程序入口
├── config.py               # 配置文件
├── database.py             # 数据库配置
├── models.py               # 数据模型
├── schemas.py              # Pydantic模型
├── requirements.txt         # 依赖包列表
├── .env.example            # 环境变量示例
└── README.md               # 项目说明
├── routers/                # API路由
│   └── stock_router.py     # 股票数据路由
└── services/               # 业务服务
    ├── __init__.py
    ├── akshare_service.py  # akshare数据服务
    └── database_service.py # 数据库服务
```

## 安装步骤

### 1. 安装Python依赖

```bash
pip install -r requirements.txt
```

### 2. 配置数据库

1. 安装PostgreSQL数据库
2. 创建数据库：
   ```sql
   CREATE DATABASE stock_db;
   ```
3. 复制环境变量文件：
   ```bash
   cp .env.example .env
   ```
4. 修改`.env`文件中的数据库连接信息

### 3. 运行应用

```bash
# 开发模式（自动重载）
python main.py

# 或使用uvicorn
python -m uvicorn main:app --host 0.0.0.0 --port 8090 --reload
```

## API接口文档

启动服务后访问：http://localhost:8080/docs

### 主要接口

- `GET /` - 服务状态检查
- `GET /health` - 健康检查
- `GET /api/v1/stocks` - 获取股票数据列表
- `GET /api/v1/stocks/{symbol}` - 获取指定股票数据
- `GET /api/v1/stocks/{symbol}/latest` - 获取最新股票数据
- `GET /api/v1/stocks/{symbol}/realtime` - 获取实时股票数据
- `POST /api/v1/stocks/refresh` - 手动刷新股票数据
- `GET /api/v1/stocks/symbols` - 获取所有股票代码

## 定时任务配置

项目内置了两个定时任务：

1. **每日任务** - 每天9:30执行数据采集
2. **测试任务** - 每30分钟执行一次（用于测试）

可以在`main.py`中修改定时任务配置：

```python
# 每天9:30执行
scheduler.add_job(
    akshare_service.fetch_and_save_stock_data,
    trigger=CronTrigger(hour=9, minute=30),
    id="daily_stock_data"
)

# 每30分钟执行（测试用）
scheduler.add_job(
    akshare_service.fetch_and_save_stock_data,
    trigger=CronTrigger(minute="*/30"),
    id="test_stock_data"
)
```

## 配置说明

### 股票代码配置

在`.env`文件中配置需要监控的股票代码：

```
STOCK_SYMBOLS=000001,000002,600000,600036,000858,600519
```

### 数据库表结构

```sql
CREATE TABLE stock_data (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    date VARCHAR(10) NOT NULL,
    open FLOAT,
    high FLOAT,
    low FLOAT,
    close FLOAT,
    volume FLOAT,
    amount FLOAT,
    amplitude FLOAT,
    change_rate FLOAT,
    change_amount FLOAT,
    turnover_rate FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE INDEX idx_stock_symbol ON stock_data(symbol);
CREATE INDEX idx_stock_date ON stock_data(date);
```

## 开发说明

### 添加新的数据源

1. 在`services/`目录下创建新的服务类
2. 实现数据获取和转换逻辑
3. 在`main.py`中集成到定时任务

### 扩展API接口

1. 在`routers/`目录下创建新的路由文件
2. 在`main.py`中注册路由
3. 添加对应的数据模型和服务

## 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查PostgreSQL服务是否启动
   - 验证`.env`文件中的数据库连接信息

2. **akshare数据获取失败**
   - 检查网络连接
   - 验证akshare API是否可用

3. **定时任务不执行**
   - 检查时区配置
   - 查看日志文件确认任务状态

## 部署说明

### 生产环境部署

1. 设置生产环境变量
2. 使用gunicorn部署：
   ```bash
   gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
   ```
3. 配置反向代理（如Nginx）
4. 设置进程守护（如systemd）

## 许可证


您可以立即测试以下功能：

访问 http://localhost:8080 检查服务状态
访问 http://localhost:8080/docs 查看所有API接口
访问 http://localhost:8080/scheduler 管理定时任务

MIT License