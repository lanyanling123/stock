#!/usr/bin/env python3
"""
数据库初始化脚本
用于创建股票数据表结构
"""

import psycopg2
from config import settings

def create_tables():
    """创建数据库表结构"""
    
    # 表结构定义
    table_schema = """
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
    
    try:
        # 连接数据库
        conn = psycopg2.connect(settings.DATABASE_URL)
        cursor = conn.cursor()
        
        # 执行创建表语句
        cursor.execute(table_schema)
        conn.commit()
        
        print("✅ 数据库表创建成功")
        
        # 检查表是否存在
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'stock_data'
        """)
        
        if cursor.fetchone():
            print("✅ stock_data 表已存在")
        else:
            print("❌ stock_data 表创建失败")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ 数据库初始化失败: {e}")

if __name__ == "__main__":
    print("开始初始化数据库...")
    create_tables()
    print("数据库初始化完成")