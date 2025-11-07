from numpy import number
import psycopg2
from psycopg2.extras import RealDictCursor
from typing import List, Dict, Any, Optional
import logging

from database import db_connection
from models import STOCK_DATA_FIELDS

logger = logging.getLogger(__name__)

class DatabaseService:
    def __init__(self):
        self.db = db_connection
    
    def create_stock_data(self, stock_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """创建股票数据记录"""
        try:
            cursor = self.db.get_cursor()
            
            # 检查是否已存在相同记录
            check_sql = """
                SELECT id FROM stock_data 
                WHERE symbol = %s AND date = %s
            """
            cursor.execute(check_sql, (stock_data['symbol'], stock_data['date']))
            existing = cursor.fetchone()
            
            if existing:
                logger.info(f"股票{stock_data['symbol']}在{stock_data['date']}的数据已存在，跳过")
                return existing
            
            # 创建新记录
            insert_sql = """
                INSERT INTO stock_data (
                    symbol, name, date, open, high, low, close, volume, 
                    amount, amplitude, change_rate, change_amount, turnover_rate
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING *
            """
            
            cursor.execute(insert_sql, (
                stock_data['symbol'], stock_data['name'], stock_data['date'],
                stock_data.get('open'), stock_data.get('high'), stock_data.get('low'),
                stock_data.get('close'), stock_data.get('volume'), stock_data.get('amount'),
                stock_data.get('amplitude'), stock_data.get('change_rate'),
                stock_data.get('change_amount'), stock_data.get('turnover_rate')
            ))
            
            result = cursor.fetchone()
            self.db.connection.commit()
            
            return dict(result) if result else None
            
        except psycopg2.Error as e:
            self.db.connection.rollback()
            logger.error(f"创建股票数据失败: {e}")
            return None
    
    def get_stock_data(self, symbol: str, limit: int = 100) -> List[Dict[str, Any]]:
        """获取指定股票的数据"""
        try:
            cursor = self.db.get_cursor()
            
            sql = f"""
                SELECT {', '.join(STOCK_DATA_FIELDS)} 
                FROM stock_data 
                WHERE symbol = %s 
                ORDER BY date DESC 
                LIMIT %s
            """
            
            cursor.execute(sql, (symbol, limit))
            results = cursor.fetchall()
            
            return [dict(row) for row in results]
            
        except psycopg2.Error as e:
            logger.error(f"查询股票数据失败: {e}")
            return []
    
    def get_stock_data_by_date_range(self, symbol: str, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """获取指定日期范围的股票数据"""
        try:
            cursor = self.db.get_cursor()
            
            sql = f"""
                SELECT {', '.join(STOCK_DATA_FIELDS)} 
                FROM stock_data 
                WHERE symbol = %s 
                AND date >= %s 
                AND date <= %s
                ORDER BY date ASC
            """
            
            cursor.execute(sql, (symbol, start_date, end_date))
            results = cursor.fetchall()
            
            return [dict(row) for row in results]
            
        except psycopg2.Error as e:
            logger.error(f"查询股票数据失败: {e}")
            return []
    
    def get_all_stock_symbols(self):
        """获取所有股票代码"""      
        try:
            cursor = self.db.get_cursor()
            
            # sql = "SELECT * FROM akshare.stock_list limit 3"
            sql = "SELECT a.* FROM akshare.stock_list a left join akshare.stock_code_temp b on a.code = b.code where b.rows is null limit 3"
            cursor.execute(sql)
            results = cursor.fetchall()
            
            return results
            
        except psycopg2.Error as e:
            logger.error(f"查询股票代码失败: {e}")
            return []
    
    def date_is_trade_day(self, t_date: number) -> bool:
        """判断是否是交易日"""
        try:
            cursor = self.db.get_cursor()
            
            sql = "SELECT t_date FROM akshare.tool_trade_date_hist_sina where t_date=%s limit 1"
            cursor.execute(sql, (t_date,))
            result = cursor.fetchone()
            
            return result is not None
            
        except psycopg2.Error as e:
            logger.error(f"查询交易日失败: {e}")
            return False

    def get_latest_stock_data(self, symbol: str) -> Optional[Dict[str, Any]]:
        """获取最新股票数据"""
        try:
            cursor = self.db.get_cursor()
            
            sql = f"""
                SELECT {', '.join(STOCK_DATA_FIELDS)} 
                FROM stock_data 
                WHERE symbol = %s 
                ORDER BY date DESC 
                LIMIT 1
            """
            
            cursor.execute(sql, (symbol,))
            result = cursor.fetchone()
            
            return dict(result) if result else None
            
        except psycopg2.Error as e:
            logger.error(f"查询最新股票数据失败: {e}")
            return None
    
    def delete_stock_data(self, symbol: str, date: str) -> bool:
        """删除指定股票数据"""
        try:
            cursor = self.db.get_cursor()
            
            sql = "DELETE FROM stock_data WHERE symbol = %s AND date = %s"
            cursor.execute(sql, (symbol, date))
            
            affected_rows = cursor.rowcount
            self.db.connection.commit()
            
            return affected_rows > 0
            
        except psycopg2.Error as e:
            self.db.connection.rollback()
            logger.error(f"删除股票数据失败: {e}")
            return False
    
    def execute_raw_sql(self, sql: str, params: tuple = None) -> List[Dict[str, Any]]:
        """执行原生SQL查询"""
        try:
            cursor = self.db.get_cursor()
            
            if params:
                cursor.execute(sql, params)
            else:
                cursor.execute(sql)
            
            results = cursor.fetchall()
            return [dict(row) for row in results]
            
        except psycopg2.Error as e:
            logger.error(f"执行SQL查询失败: {e}")
            return []