using Microsoft.Extensions.Configuration;
using StockAPI.Data;
using System;
using System.Globalization;
using System.Text.Json;

namespace StockAPI.Service
{
    public class AkshareService
    {
        private readonly IConfiguration _configuration;
        private readonly StockListService _stockListService;
        public AkshareService(IConfiguration configuration, StockListService stockListService)
        {
            _configuration = configuration;
            _stockListService = stockListService;
        }
        /// <summary>
        /// 获取历史日线数据
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public async Task<dynamic> stock_zh_a_hist(KLineRequest request,DateTime endDate)
        {
            // 计算大概实际交易日数，假设每月20个交易日，最近count个交易日大约是count / 20 * 30天
            int approxDays = (int)(request.Count / 20.0 * 30);
            string start_date = endDate.AddDays(-approxDays).ToString("yyyyMMdd");
            var parameters = new Dictionary<string, string>
            {
                { "symbol", request.Symbol.Split('.')[0] },
                { "period", "daily" },
                { "start_date", start_date },
                { "end_date", endDate.ToString("yyyyMMdd") },
                { "adjust", "qfq" }
            };

            var rowData = await FetchDataFromAkshareApi("stock_zh_a_hist", parameters);
            if(rowData == null || rowData.Length == 0)
            {
                throw new Exception("No data returned from Akshare API.");
            }
            var rowsList = rowData.Cast<JsonElement>().ToList();
            var result = new List<dynamic[]>();

            for (int i = 0; i < rowsList.Count; i++)
            {
                var currentRow = rowsList[i];
                var dt = DateTime.Parse(currentRow.GetProperty("日期").GetString()!,
                    CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind);

                // 获取前一行数据（如果是第一行则为null）
                JsonElement? previousRow = i > 0 ? rowsList[i - 1] : (JsonElement?)null;

                var rowArray = new dynamic[]
                {
                    int.Parse(dt.ToString("yyyyMMdd", CultureInfo.InvariantCulture)),
                    // 使用前一行收盘价（第一行前一行不存在，设为null）
                    previousRow?.GetProperty("收盘").GetDouble(),
                    currentRow.GetProperty("开盘").GetDouble(),
                    currentRow.GetProperty("最高").GetDouble(),
                    currentRow.GetProperty("最低").GetDouble(),
                    currentRow.GetProperty("收盘").GetDouble(),
                    currentRow.GetProperty("成交量").GetInt64(),
                    (double)currentRow.GetProperty("成交额").GetDecimal()
                };

                result.Add(rowArray);
            }
            // 股票名称
            string stockName = await _stockListService.GetStockName(request.Symbol);
            return new HistoryData
            { 
                code = 0,
                count = result.Count,
                data = result,
                message = null,
                name = stockName,
                symbol = request.Symbol
            };
        }
        /// <summary>
        /// 从 Akshare API 获取数据
        /// </summary>
        /// <param name="functionName">函数名称</param>
        /// <param name="parameters">参数列表</param>
        /// <returns></returns>
        private async Task<object[]?> FetchDataFromAkshareApi(string functionName, Dictionary<string, string> parameters)
        {
            var baseUrl = _configuration.GetValue<string>("AkshareApi");
            var queryString = string.Join("&", parameters.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
            baseUrl = $"{baseUrl}/api/public/{functionName}?{queryString}";
            using var httpClient = new HttpClient();
            var json = await httpClient.GetStringAsync(baseUrl);

            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            var rows = JsonSerializer.Deserialize<object[]>(json, options);

            return rows;
        }

        public async Task<string> FetchJsonDataFromAkshareApi(string functionName, Dictionary<string, string> parameters)
        {
            var baseUrl = _configuration.GetValue<string>("AkshareApi");
            var queryString = string.Join("&", parameters.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
            baseUrl = $"{baseUrl}/api/public/{functionName}?{queryString}";
            using var httpClient = new HttpClient();
            var json = await httpClient.GetStringAsync(baseUrl);
            return json;
        }
    }
}
