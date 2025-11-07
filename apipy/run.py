#!/usr/bin/env python3
"""
运行脚本 - 用于快速启动应用
"""

import uvicorn
import os

if __name__ == "__main__":
    # 检查环境变量文件
    if not os.path.exists(".env"):
        print("⚠️  警告: 未找到.env文件，请复制.env.example并配置数据库连接")
        print("   命令: cp .env.example .env")
    
    # 启动应用
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )