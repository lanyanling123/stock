#!/bin/bash

echo "========================================"
echo "   股票数据API项目安装脚本"
echo "========================================"
echo

# 检查Python是否安装
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到Python3，请先安装Python 3.8+"
    exit 1
fi

echo "✅ Python已安装"

# 安装依赖包
echo
echo "📦 正在安装依赖包..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ 依赖包安装失败"
    exit 1
fi

echo "✅ 依赖包安装完成"

# 创建环境变量文件
if [ ! -f ".env" ]; then
    echo
echo "📝 创建环境变量文件..."
    cp .env.example .env
    echo "✅ 请编辑.env文件配置数据库连接信息"
fi

echo
echo "========================================"
echo "   安装完成！"
echo "========================================"
echo
echo "🚀 启动应用:"
echo "   python3 main.py"
echo
echo "📖 或使用uvicorn:"
echo "   uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
echo
echo "🌐 访问地址: http://localhost:8000"
echo "📚 API文档: http://localhost:8000/docs"