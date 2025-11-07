import os
from typing import List
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # 数据库配置
    DATABASE_URL: str = "postgresql://xxx:xxx@xxxxxx:xxxx/xxx"
    
    # akshare配置
    AKSHARE_BASE_URL: str = "https://akshare.akfamily.xyz/"
    
    # 定时任务配置
    SCHEDULER_TIMEZONE: str = "Asia/Shanghai"
    
    # 股票代码配置（使用逗号分隔的字符串，在环境变量中配置）
    STOCK_SYMBOLS: str = "000001,000002,600000,600036"
    
    # 获取股票代码列表的方法
    @property
    def stock_symbols_list(self) -> List[str]:
        """将逗号分隔的股票代码字符串转换为列表"""
        return [symbol.strip() for symbol in self.STOCK_SYMBOLS.split(",") if symbol.strip()]
    
    class Config:
        env_file = ".env"

# 创建配置实例
settings = Settings()
