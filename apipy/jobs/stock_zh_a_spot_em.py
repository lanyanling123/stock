import logging
import akshare as ak
import pandas as pd
from datetime import datetime
from apscheduler.triggers.cron import CronTrigger

from routers.stock_router import db_service
from services.akshare_service import AkshareService
from services.database_service import DatabaseService
from database import db_connection
logger = logging.getLogger(__name__)

# 描述: 东方财富网-沪深京 A 股-实时行情数据
# 限量: 单次返回所有沪深京 A 股上市公司的实时行情数据
class stock_zh_a_spot_em:
    """股票数据采集任务"""
    
    def __init__(self):
        self.akshare_service = AkshareService()
        self.db_service = DatabaseService()
        self.db = db_connection
        self.job_id = "stock_zh_a_spot_em"
        
    def get_job_config(self):
        """获取任务配置"""
        # 周一到周五下午15:15分钟执行
        return {
            "id": self.job_id,
            "func": self.execute,
            "trigger": CronTrigger(year="*", month="*", day="*", hour=21, minute=59),
            "name": "实时行情数据",
            "description": "东方财富网-沪深京 A 股-实时行情数据"
        }
    
    def execute(self):
        """执行股票数据采集任务"""
        dt = datetime.now()
        today = dt.strftime('%Y%m%d')
        # 将字符串转换为整数传递给 date_is_trade_day
        if not self.db_service.date_is_trade_day(int(today)):
            logger.info(f"非交易日，不采集实时行情数据")
            return
        logger.info(f"实时行情数据数据采集任务 - {datetime.now()}")

        try:
            cursor = self.db.get_cursor()
            logger.info(f"打开数据库连接 - {datetime.now()}")
            ak_df = ak.stock_zh_a_spot_em()
            logger.info(f"实时行情数据数据行数 {len(ak_df)} - {datetime.now()}")

            row_data = ak_df.to_json(orient="records",
                                            force_ascii=False,
                                            date_format='iso')
            cursor.execute("SELECT akshare.ins_stock_zh_a_spot_em(@t_date, @data_json::json)"
                                , {'t_date': today, 'data_json': row_data})
            self.db.connection.commit()
            
            return {
                "success": True,
                "message": f"实时行情数据采集完成 - 成功",
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"实时行情数据采集任务执行失败: {e}")
            
            return {
                "success": False,
                "message": f"任务执行失败: {str(e)}",
                "timestamp": datetime.now().isoformat()
            }