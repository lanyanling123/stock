from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class StockDataBase(BaseModel):
    symbol: str
    name: str
    date: str
    open: Optional[float] = None
    high: Optional[float] = None
    low: Optional[float] = None
    close: Optional[float] = None
    volume: Optional[float] = None
    amount: Optional[float] = None
    amplitude: Optional[float] = None
    change_rate: Optional[float] = None
    change_amount: Optional[float] = None
    turnover_rate: Optional[float] = None

class StockDataCreate(StockDataBase):
    pass

class StockDataResponse(StockDataBase):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True

class StockQuery(BaseModel):
    symbol: Optional[str] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    limit: int = 100
    offset: int = 0

class ApiResponse(BaseModel):
    success: bool
    message: str
    data: Optional[dict] = None