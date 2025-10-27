using Dapper;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Npgsql;
using StockAPI.Models;

namespace StockAPI.Service
{
    public class TradeDateService
    {
        private readonly IConfiguration _configuration;
        public TradeDateService(IConfiguration configuration = null)
        {
            _configuration = configuration;
        }
        /// <summary>
        /// 获取最新交易日期列表
        /// </summary>
        /// <param name="count"></param>
        /// <returns></returns>
        public async Task<IEnumerable<TradeDate>> GetTradeDates(int count, int lastdate)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            // 直接查询，返回 TradeDate 对象集合
            var results = await connection.QueryAsync<TradeDate>(
                "SELECT * FROM tool_trade_date_hist_sina ttdhs where t_date<=@today order by t_date desc limit @count ",
                new { today = lastdate, count = count });
            return results;
        }
        /// <summary>
        /// 获取最新交易日期
        /// </summary>
        /// <returns></returns>
        public int GetLatestTradeDate()
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var date =int.Parse(DateTime.Now.ToString("yyyyMMdd"));
            var result = connection.ExecuteScalar<int>(
                "SELECT t_date FROM tool_trade_date_hist_sina ttdhs where t_date<=@date order by t_date desc limit 1",
                new { date = date });
            return result;
        }
        // 判断某日期是否为交易日
        public async Task<bool> IsTradeDate(int date)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var result = await connection.QueryFirstOrDefaultAsync<int?>(
                "SELECT 1 FROM tool_trade_date_hist_sina ttdhs where t_date=@date limit 1",
                new { date = date });
            return result.HasValue;
        }
    }
}
