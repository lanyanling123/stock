import { request } from '@umijs/max';
import dayjs from 'dayjs';
export async function getStockData(options?: { [key: string]: any }) {
	// 上证指数数据
	let shIndexData = generateStockData(300);
  	return {
    data: shIndexData,
    total: shIndexData.length,
    success: true,
  };
}
// 生成随机上证指数数据
const generateStockData = (count: number) => {
  const data: {
    date: string;
    open: number;
    high: number;
    low: number;
    close: number;
    volume: number;
  }[] = [];
  
  // 以上证指数约3000点为基准开始
  let basePrice = 3000 + Math.random() * 200;
  
  // 生成过去count天的数据
  for (let i = count - 1; i >= 0; i--) {
    const date = dayjs().subtract(i, 'day').format('YYYY-MM-DD');
    
    // 每天的价格波动范围在-1.5%到+1.5%之间
    const dailyChange = (Math.random() - 0.48) * 3 / 100; // 稍微偏向上涨
    const open = basePrice * (1 + (Math.random() - 0.5) * 0.5 / 100);
    const close = open * (1 + dailyChange);
    
    // 确保最高价大于等于开盘价和收盘价，最低价小于等于开盘价和收盘价
    const high = Math.max(open, close) * (1 + Math.random() * 0.5 / 100);
    const low = Math.min(open, close) * (1 - Math.random() * 0.5 / 100);
    
    // 生成成交量，基于价格变动幅度，变动越大成交量越大
    const volumeBase = 1000000000;
    const volumeFactor = 1 + Math.abs(dailyChange) * 10;
    const volume = Math.floor(volumeBase * volumeFactor * (0.8 + Math.random() * 0.4));
    
    // 保留两位小数
    basePrice = close;
    
    data.push({
      date,
      open: Math.round(open * 100) / 100,
      high: Math.round(high * 100) / 100,
      low: Math.round(low * 100) / 100,
      close: Math.round(close * 100) / 100,
      volume,
    });
  }
  
  return data;
};
