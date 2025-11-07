import logging
from datetime import datetime
from apscheduler.triggers.cron import CronTrigger

logger = logging.getLogger(__name__)

class TestJob:
    """测试任务"""
    
    def __init__(self):
        self.job_id = "test_job"
        self.execution_count = 0
        
    def get_job_config(self):
        """获取任务配置"""
        return {
            "id": self.job_id,
            "func": self.execute,
            "trigger": CronTrigger(minute="*/5"),  # 每5分钟执行一次
            "name": "测试任务",
            "description": "测试任务，每5分钟执行一次"
        }
    
    def execute(self):
        """执行测试任务"""
        self.execution_count += 1
        
        logger.info(f"测试任务执行 - 第{self.execution_count}次 - {datetime.now()}")
        
        return {
            "success": True,
            "message": f"测试任务第{self.execution_count}次执行成功",
            "execution_count": self.execution_count,
            "timestamp": datetime.now().isoformat()
        }