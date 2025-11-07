import psycopg2
from psycopg2.extras import RealDictCursor
from config import settings

class DatabaseConnection:
    """数据库连接管理类"""
    
    def __init__(self):
        self.connection = None
        self.connect()
    
    def connect(self):
        """建立数据库连接"""
        try:
            self.connection = psycopg2.connect(
                settings.DATABASE_URL,
                cursor_factory=RealDictCursor
            )
            print("数据库连接成功")
        except Exception as e:
            print(f"数据库连接失败: {e}")
            raise
    
    def get_cursor(self):
        """获取数据库游标"""
        if not self.connection or self.connection.closed:
            self.connect()
        return self.connection.cursor()
    
    def close(self):
        """关闭数据库连接"""
        if self.connection and not self.connection.closed:
            self.connection.close()
            print("数据库连接已关闭")
    
    def __del__(self):
        """析构函数，确保连接关闭"""
        self.close()

# 全局数据库连接实例
db_connection = DatabaseConnection()

# 依赖注入函数
def get_db():
    """获取数据库连接（用于依赖注入）"""
    return db_connection