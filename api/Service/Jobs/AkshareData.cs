using Dapper;
using Hangfire;
using Microsoft.Extensions.Logging;
using Npgsql;
using StockAPI.Models;
using System.Text.Json;
using System.Threading.Tasks;

namespace StockAPI.Service.Jobs
{
    public class AkshareData
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<AkshareData> _logger;
        private readonly AkshareService _akshareService;
        private readonly StockListService _stockListService;
        // 通过构造函数注入依赖项，如日志、数据库上下文等
        public AkshareData( ILogger<AkshareData> logger, AkshareService akshareService, IConfiguration configuration, StockListService stockListService)
        {
            _logger = logger;
            _akshareService = akshareService;
            _configuration = configuration;
            _stockListService = stockListService;
        }

        public async Task stock_zh_a_hist()
        {
            try
            {
                _logger.LogInformation("stock_zh_a_hist开始下载数据... {CurrentTime}", DateTime.Now);
                // 在这里编写您的核心业务逻辑，例如：
                // 1. 从数据库查询数据
                // 2. 处理数据，生成报表（PDF、Excel等）
                // 3. 发送邮件通知
                // 4. 将结果保存到指定位置
                string start_date = "20220101";
                string end_date = "20251104";
                var stocks = await _stockListService.GetStockList();
                int count = 0;
                int total = stocks.Count();
                foreach (var stock in stocks)
                {
                    // 产生随机数，5-10秒
                    var random = new Random();
                    var delay = random.Next(5, 10);
                    await Task.Delay(TimeSpan.FromSeconds(delay));
                    // 提示完成百分比，用百分比来表示进度
                    count++;
                    var percent = (count / total) * 100;
                    _logger.LogInformation($"stock_zh_a_hist 下载进度 {count}/{total} {percent}%");
                    var parameters = new Dictionary<string, string>
                    {
                        { "symbol", stock.code },
                        { "period", "daily" },
                        { "start_date", start_date },
                        { "end_date", end_date },
                        { "adjust", "qfq" }
                    };
                    try
                    {
                        var jsonData = await _akshareService.FetchJsonDataFromAkshareApi("stock_zh_a_hist", parameters);
                        //_logger.LogInformation("stock_zh_a_hist下载数据成功！");
                        //_logger.LogInformation(jsonData);

                        var connStr = _configuration.GetConnectionString("DefaultConnection");
                        using var connection = new NpgsqlConnection(connStr);
                        // 使用Dapper的DynamicParameters来指定JSON类型
                        var param = new DynamicParameters();
                        param.Add("stock_name", stock.name);
                        param.Add("period", "d");
                        param.Add("data_json", jsonData, System.Data.DbType.String);

                        var results = await connection.ExecuteScalarAsync<int>(
                            "SELECT akshare.ins_stock_zh_a_hist(@stock_name, @period, @data_json::json)",
                            param);
                        if(results > 0){
                            await connection.ExecuteAsync("Insert into akshare.stock_code_temp(code, rows)values(@code, @rows)",new { code = stock.code, rows = results});
                        }
                        //_logger.LogInformation($"stock_zh_a_hist 插入数据库 {results} 条！");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "stock_zh_a_hist下载数据时发生错误。");
                        continue;
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "stock_zh_a_hist下载数据时发生错误。");
                // 抛出异常，Hangfire 会根据配置的重试策略进行处理
                throw;
            }
        }
    }
}
