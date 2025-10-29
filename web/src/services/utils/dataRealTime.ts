import { stockCode2 } from "./dateUtils";

// 获取股票实时行情数据，转换为所需要的数据
export const stockRealTimePrice = async (stockData: any[]): Promise<any> => {
	// 提取股票代码并转换格式
	const codes = stockData
		.map((item: any) => item.code)
		.filter((code: any) => code && code.length > 0)
		.map((code: string) => stockCode2(code));

	if (codes.length === 0) {
		return;
	}
	// 构建API请求URL
	const codeParams = codes.map(code => `s_${code}`).join(',');
	const apiUrl = `http://qt.gtimg.cn/q=${codeParams}`;

	// 调用API获取实时数据
	const response = await fetch(apiUrl);
	const data = await response.text();

	// 解析返回的结果
	const parsedData: Record<string, any> = {};
	const lines = data.split(';');

	let rowCount = 0;
	let sumPriceChangePercent = 0;
	let upCount = 0;
	let downCount = 0;
	lines.forEach(line => {
		if (!line || !line.includes('=')) return;
		rowCount++;
		try {
			// 提取股票代码和数据部分
			const match = line.match(/v_s_([a-z\d]+)="([^"]+)"/i);
			if (!match) return;

			const stockCode = match[1].substring(2, 8);
			const stockInfo = match[2].split('~');

			// 解析数据
			parsedData[stockCode] = {
				code: stockInfo[2],
				currentPrice: parseFloat(stockInfo[3]),
				priceChange: parseFloat(stockInfo[4]),
				priceChangePercent: parseFloat(stockInfo[5]),
				volume: parseInt(stockInfo[6]),
				amount: (parseFloat(stockInfo[7]) / 10000.0).toFixed(2),
				totalMarketValue: parseFloat(stockInfo[9]),
			};
			sumPriceChangePercent += parsedData[stockCode].priceChangePercent;
			// 统计涨跌家数
			if (parsedData[stockCode].priceChangePercent > 0) {
				upCount++;
			} else if (parsedData[stockCode].priceChangePercent < 0) {
				downCount++;
			}
		} catch (error) {
			console.error('解析股票数据失败:', error);
		}
	});
	// 计算平均涨跌幅
	const avgPriceChangePercent = rowCount > 0 ? (sumPriceChangePercent / rowCount).toFixed(2) : '0.00';

	// 更新股票数据
	const priceData = stockData.map((item: any) => ({
		...item,
		...parsedData[item.code],
	}));
	return {
		priceData,
		avgPriceChangePercent,
		upCount,
		downCount,
	}
};