@echo off
echo ========================================
echo   股票数据API项目安装脚本
echo ========================================
echo.

REM 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误: 未找到Python，请先安装Python 3.8+
    pause
    exit /b 1
)

echo ✅ Python已安装

REM 安装依赖包
echo.
echo 📦 正在安装依赖包...
pip install -r requirements.txt

if errorlevel 1 (
    echo ❌ 依赖包安装失败
    pause
    exit /b 1
)

echo ✅ 依赖包安装完成

REM 创建环境变量文件
if not exist ".env" (
    echo.
    echo 📝 创建环境变量文件...
    copy .env.example .env
    echo ✅ 请编辑.env文件配置数据库连接信息
)

echo.
echo ========================================
echo   安装完成！
echo ========================================
echo.
echo 🚀 启动应用:
echo    python main.py
echo.
echo 📖 或使用uvicorn:
echo    uvicorn main:app --host 0.0.0.0 --port 8000 --reload
echo.
echo 🌐 访问地址: http://localhost:8000
echo 📚 API文档: http://localhost:8000/docs
echo.
pause