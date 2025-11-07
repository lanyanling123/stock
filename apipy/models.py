# 股票数据表结构定义（仅用于文档参考）
# 实际表结构已在数据库中创建

STOCK_DATA_TABLE_SCHEMA = """
CREATE TABLE IF NOT EXISTS stock_data (
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

CREATE INDEX IF NOT EXISTS idx_stock_symbol ON stock_data(symbol);
CREATE INDEX IF NOT EXISTS idx_stock_date ON stock_data(date);
"""

# 表字段列表，用于SQL查询
STOCK_DATA_FIELDS = [
    "id", "symbol", "name", "date", "open", "high", "low", "close", 
    "volume", "amount", "amplitude", "change_rate", "change_amount", 
    "turnover_rate", "created_at", "updated_at"
]