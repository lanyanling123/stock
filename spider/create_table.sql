-- 创建异动解析数据表
CREATE TABLE stock_movement_analysis (
    id SERIAL PRIMARY KEY,
    plate_name VARCHAR(100) NOT NULL COMMENT '板块名称',
    stock_name VARCHAR(100) NOT NULL COMMENT '股票名称',
    latest_price DECIMAL(10, 2) NOT NULL COMMENT '最新价',
    change_percent DECIMAL(10, 2) NOT NULL COMMENT '涨跌幅(%)',
    limit_up_time VARCHAR(50) COMMENT '涨停时间',
    analysis_text TEXT COMMENT '解析内容',
    crawl_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '爬取时间',
    source_url VARCHAR(500) COMMENT '来源URL'
);

-- 创建索引以提高查询性能
CREATE INDEX idx_stock_name ON stock_movement_analysis(stock_name);
CREATE INDEX idx_plate_name ON stock_movement_analysis(plate_name);
CREATE INDEX idx_crawl_time ON stock_movement_analysis(crawl_time);

-- 添加唯一约束，避免重复数据
ALTER TABLE stock_movement_analysis ADD CONSTRAINT unique_stock_analysis 
UNIQUE (stock_name, plate_name, crawl_time);