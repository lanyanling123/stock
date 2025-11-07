import logging
import time
import akshare as ak
import pandas as pd
from datetime import datetime
from apscheduler.triggers.cron import CronTrigger

from services.akshare_service import AkshareService
from services.database_service import DatabaseService
from database import db_connection
logger = logging.getLogger(__name__)

# 股票历史数据采集任务，补充数据时候执行
class stock_zh_a_hist:
    """股票数据采集任务"""
    
    def __init__(self):
        self.akshare_service = AkshareService()
        self.db_service = DatabaseService()
        self.db = db_connection
        self.job_id = "stock_zh_a_hist"
        
    def get_job_config(self):
        """获取任务配置"""
        return {
            "id": self.job_id,
            "func": self.execute,
            "trigger": CronTrigger(year="*", month="11", day="5", hour=21, minute=59),
            "name": "股票数据采集任务",
            "description": "股票历史数据采集任务，补充数据时候执行"
        }
    
    def execute(self):
        """执行股票数据采集任务"""
        logger.info(f"开始执行股票数据采集任务 - {datetime.now()}")
        
        dt = datetime.now()
        today = dt.strftime('%Y%m%d')
        # today = '20250623'
        # 下载起始日期
        lastday = "20220101"
        # lastday = today

        try:
            stock_symbols = self.db_service.get_all_stock_symbols()
            
            success_count = 0
            error_count = 0
            cursor = self.db.get_cursor()
            count_rows = len(stock_symbols)
            # 遍历股票代码
            idx = 0
            for stock_info in stock_symbols:
                # 获取股票代码
                idx += 1
                a = (100 * idx)/count_rows
                print(format(a, '.2f') + '%')
                time.sleep(3)

                symbol = stock_info['code']
                stock_name = stock_info['name']
                try:
                    # 获取股票数据
                    logger.info(f"正在获取股票 {symbol}({stock_name}) 数据")
                    ak_df = ak.stock_zh_a_hist(symbol=symbol,
                                            period= 'daily',
                                            start_date=lastday,
                                            end_date=today,
                                            adjust="qfq")
                    row_data = ak_df.to_json(orient="records",
                                            force_ascii=False,
                                            date_format='iso')
                    cursor.execute("SELECT akshare.ins_stock_zh_a_hist(@stock_name, @period, @data_json::json)"
                                , {'stock_name': stock_name, 'period': 'd', 'data_json': row_data})

                    # 记录已经导入成功的股票代码和行数
                    cursor.execute("Insert into akshare.stock_code_temp(code, rows)values(@code, @rows)"
                                , {'code': symbol, 'rows': len(ak_df)})
                    self.db.connection.commit()
                        
                except Exception as e:
                    error_count += 1
                    logger.error(f"股票 {symbol} 数据采集异常: {e}")
            
            logger.info(f"股票数据采集任务完成 - 成功: {success_count}, 失败: {error_count}")
            
            return {
                "success": True,
                "message": f"股票数据采集完成 - 成功: {success_count}, 失败: {error_count}",
                "success_count": success_count,
                "error_count": error_count,
                "total": len(stock_symbols),
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"股票数据采集任务执行失败: {e}")
            
            return {
                "success": False,
                "message": f"任务执行失败: {str(e)}",
                "timestamp": datetime.now().isoformat()
            }