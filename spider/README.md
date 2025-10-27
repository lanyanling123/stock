# 九阳公社异动解析爬虫

这是一个用于爬取九阳公社网站异动解析数据的Python爬虫程序。

## 功能特性

- 爬取九阳公社网站的异动解析数据
- 提取板块名称、股票名称、最新价、涨跌幅、涨停时间、解析内容
- 数据存储到PostgreSQL数据库
- 支持自动重试和错误处理
- 详细的日志记录

## 安装依赖

首先安装所需的Python库：

```bash
pip install -r requirements.txt
```

### 依赖库列表

- `requests==2.31.0` - HTTP请求库
- `beautifulsoup4==4.12.2` - HTML解析库
- `psycopg2-binary==2.9.9` - PostgreSQL数据库连接
- `lxml==4.9.3` - XML/HTML解析器
- `fake-useragent==1.4.0` - 随机User-Agent生成
- `pandas==2.1.1` - 数据处理
- `python-dotenv==1.0.0` - 环境变量管理

## 数据库配置

### 1. 创建数据库

首先在PostgreSQL中创建数据库：

```sql
CREATE DATABASE stock_db;
```

### 2. 创建数据表

执行SQL脚本创建数据表：

```bash
psql -d stock_db -f create_table.sql
```

或者直接在psql中执行：

```sql
\i create_table.sql
```

### 3. 配置数据库连接

编辑 `.env` 文件，配置数据库连接信息：

```env
# PostgreSQL数据库配置
DB_HOST=localhost
DB_PORT=5432
DB_NAME=stock_db
DB_USER=postgres
DB_PASSWORD=your_password_here

# 爬虫配置
REQUEST_TIMEOUT=30
RETRY_COUNT=3
DELAY_BETWEEN_REQUESTS=2
```

## 使用方法

### 运行爬虫

```bash
python run_spider.py
```

或者直接运行主程序：

```bash
python stock_spider.py
```

### 查看日志

爬虫运行日志会输出到控制台，同时保存到 `spider.log` 文件。

## 项目结构

```
spider/
├── stock_spider.py      # 主爬虫程序
├── run_spider.py        # 运行脚本
├── requirements.txt     # Python依赖库
├── create_table.sql     # 数据库表创建脚本
├── .env                 # 环境配置文件
├── .env.example         # 环境配置示例文件
└── README.md           # 说明文档
```

## 数据表结构

表名：`stock_movement_analysis`

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | SERIAL | 主键ID |
| plate_name | VARCHAR(100) | 板块名称 |
| stock_name | VARCHAR(100) | 股票名称 |
| latest_price | DECIMAL(10,2) | 最新价 |
| change_percent | DECIMAL(10,2) | 涨跌幅(%) |
| limit_up_time | VARCHAR(50) | 涨停时间 |
| analysis_text | TEXT | 解析内容 |
| crawl_time | TIMESTAMP | 爬取时间 |
| source_url | VARCHAR(500) | 来源URL |

## 注意事项

1. **网站结构变化**：如果网站HTML结构发生变化，可能需要调整解析逻辑
2. **反爬虫机制**：程序使用了随机User-Agent，但如果遇到反爬虫限制，可能需要增加代理IP等机制
3. **数据库连接**：确保PostgreSQL服务正常运行，且连接信息正确
4. **网络环境**：确保网络连接正常，能够访问目标网站

## 调试

如果爬虫无法正常解析数据，程序会自动保存原始HTML到 `debug_page.html` 文件，可以用于分析网站结构。

## 许可证

MIT License