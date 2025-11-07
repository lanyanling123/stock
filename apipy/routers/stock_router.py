from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Optional

from schemas import StockDataResponse, StockQuery, ApiResponse
from services.database_service import DatabaseService
from services.akshare_service import AkshareService

router = APIRouter()

# 初始化服务
db_service = DatabaseService()
akshare_service = AkshareService()

@router.get("/stocks", response_model=List[StockDataResponse])
async def get_stocks(
    symbol: Optional[str] = Query(None, description="股票代码"),
    start_date: Optional[str] = Query(None, description="开始日期 (YYYY-MM-DD)"),
    end_date: Optional[str] = Query(None, description="结束日期 (YYYY-MM-DD)"),
    limit: int = Query(100, description="返回记录数"),
    offset: int = Query(0, description="偏移量")
):
    """获取股票数据"""
    try:
        if symbol:
            if start_date and end_date:
                stocks = db_service.get_stock_data_by_date_range(symbol, start_date, end_date)
            else:
                stocks = db_service.get_stock_data(symbol, limit)
        else:
            # 如果没有指定股票代码，返回空列表
            stocks = []
        
        # 应用偏移量
        if offset > 0 and stocks:
            stocks = stocks[offset:offset+limit]
        
        return stocks
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

@router.get("/stocks/{symbol}", response_model=List[StockDataResponse])
async def get_stock_by_symbol(
    symbol: str,
    limit: int = Query(100, description="返回记录数")
):
    """根据股票代码获取数据"""
    try:
        stocks = db_service.get_stock_data(symbol, limit)
        
        if not stocks:
            raise HTTPException(status_code=404, detail="未找到该股票数据")
        
        return stocks
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

@router.get("/stocks/{symbol}/latest", response_model=StockDataResponse)
async def get_latest_stock_data(symbol: str):
    """获取最新股票数据"""
    try:
        stock_data = db_service.get_latest_stock_data(symbol)
        
        if not stock_data:
            raise HTTPException(status_code=404, detail="未找到该股票数据")
        
        return stock_data
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

@router.get("/stocks/symbols", response_model=List[str])
async def get_all_stock_symbols():
    """获取所有股票代码"""
    try:
        symbols = db_service.get_all_stock_symbols()
        return symbols
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

@router.post("/stocks/refresh", response_model=ApiResponse)
async def refresh_stock_data():
    """手动刷新股票数据"""
    try:
        result = akshare_service.fetch_and_save_stock_data()
        
        return ApiResponse(
            success=True,
            message=f"数据刷新完成，成功: {result['success_count']}, 失败: {result['error_count']}",
            data=result
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"数据刷新失败: {str(e)}")

@router.get("/stocks/{symbol}/realtime")
async def get_realtime_stock_data(symbol: str):
    """获取实时股票数据"""
    try:
        realtime_data = akshare_service.get_realtime_data(symbol)
        
        if not realtime_data:
            raise HTTPException(status_code=404, detail="未找到该股票实时数据")
        
        return {
            "success": True,
            "data": realtime_data
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取实时数据失败: {str(e)}")

@router.delete("/stocks/{symbol}/{date}", response_model=ApiResponse)
async def delete_stock_data(symbol: str, date: str):
    """删除指定股票数据"""
    try:
        success = db_service.delete_stock_data(symbol, date)
        
        if success:
            return ApiResponse(
                success=True,
                message=f"成功删除股票{symbol}在{date}的数据"
            )
        else:
            raise HTTPException(status_code=404, detail="未找到要删除的数据")
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"删除失败: {str(e)}")