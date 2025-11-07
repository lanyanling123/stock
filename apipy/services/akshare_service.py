import akshare as ak
import pandas as pd
import logging
from typing import List, Dict, Any
from datetime import datetime, timedelta

from config import settings
from services.database_service import DatabaseService

logger = logging.getLogger(__name__)

class AkshareService:
    def __init__(self):
        self.db_service = DatabaseService()
        
    def get_stock_list(self) -> List[Dict[str, Any]]:
        """获取股票列表"""
        try:
            # 获取A股股票列表
            stock_info_a_code_name_df = ak.stock_info_a_code_name()
            return stock_info_a_code_name_df.to_dict('records')
        except Exception as e:
            logger.error(f"获取股票列表失败: {e}")
            return []
    
    def get_stock_data(self, symbol: str, period: str = "daily") -> pd.DataFrame:
        """获取单个股票的历史数据"""
        try:
            if period == "daily":
                # 获取日线数据
                stock_data = ak.stock_zh_a_hist(symbol=symbol, period="daily")
            elif period == "weekly":
                # 获取周线数据
                stock_data = ak.stock_zh_a_hist(symbol=symbol, period="周线")
            else:
                # 默认日线
                stock_data = ak.stock_zh_a_hist(symbol=symbol, period="daily")
                
            return stock_data
        except Exception as e:
            logger.error(f"获取股票{symbol}数据失败: {e}")
            return pd.DataFrame()
    
    def get_realtime_data(self, symbol: str) -> Dict[str, Any]:
        """获取实时股票数据"""
        try:
            # 获取实时数据
            realtime_data = ak.stock_zh_a_spot_em()
            
            # 过滤指定股票
            stock_data = realtime_data[realtime_data['代码'] == symbol]
            
            if not stock_data.empty:
                return stock_data.iloc[0].to_dict()
            else:
                return {}
        except Exception as e:
            logger.error(f"获取股票{symbol}实时数据失败: {e}")
            return {}
    
    def fetch_and_save_stock_data(self):
        """获取并保存股票数据"""
        logger.info("开始执行股票数据采集任务...")
        
        success_count = 0
        error_count = 0
        
        for symbol in settings.stock_symbols_list:
            try:
                # 获取股票数据
                stock_data = self.get_stock_data(symbol)
                
                if stock_data.empty:
                    logger.warning(f"股票{symbol}数据为空")
                    continue
                
                # 转换数据格式
                for _, row in stock_data.iterrows():
                    data_dict = {
                        'symbol': symbol,
                        'name': f"股票{symbol}",  # 实际应用中可以从其他接口获取名称
                        'date': row['日期'],
                        'open': row['开盘'],
                        'high': row['最高'],
                        'low': row['最低'],
                        'close': row['收盘'],
                        'volume': row['成交量'],
                        'amount': row['成交额'],
                        'amplitude': row['振幅'],
                        'change_rate': row['涨跌幅'],
                        'change_amount': row['涨跌额'],
                        'turnover_rate': row['换手率']
                    }
                    
                    # 保存到数据库
                    self.db_service.create_stock_data(data_dict)
                
                success_count += 1
                logger.info(f"成功保存股票{symbol}数据，共{len(stock_data)}条记录")
                
            except Exception as e:
                error_count += 1
                logger.error(f"处理股票{symbol}数据失败: {e}")
        
        logger.info(f"股票数据采集任务完成，成功: {success_count}, 失败: {error_count}")
        
        return {
            "success_count": success_count,
            "error_count": error_count,
            "total": len(settings.stock_symbols_list)
        }