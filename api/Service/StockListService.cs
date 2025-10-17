using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Npgsql;
using StockAPI.Data;

namespace StockAPI.Service
{
    public class StockListService
    {
        private readonly IConfiguration _configuration;
        public StockListService(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public async Task<dynamic> GetTableDataByTableName(string tableName, IQueryCollection query)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");

            using var connection = new NpgsqlConnection(connStr);
            var where = DBMeta.BuildWhereClause(connStr, tableName, query);
            // 检查表是否存在
            if(!DBMeta.TableExists(connStr, tableName))
            {
                throw new Exception($"Table '{tableName}' does not exist.");
            }
            if (string.IsNullOrEmpty(where.whereClause))
            {
                throw new Exception($"query string is null.");
            }

            var sql = $"SELECT * FROM {tableName} {where.whereClause}";

            // 执行查询
            var results = await connection.QueryAsync<dynamic>(sql, where.parameters);

            return results;
        }
        /// <summary>
        /// 返回动态对象
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <returns></returns>
        public async Task<IEnumerable<dynamic>> GetDynamicData(string searchTerm)
        {
            using var connection = new NpgsqlConnection("DefaultConnection");

            // 直接查询，返回 dynamic 对象集合
            var results = await connection.QueryAsync<dynamic>(
                "SELECT id, name, COALESCE(extra_field, 'N/A') AS dynamic_field FROM my_table WHERE name LIKE @SearchTerm",
                new { SearchTerm = $"%{searchTerm}%" });

            return results;
        }
        /// <summary>
        /// 返回多个结果集
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<(IEnumerable<dynamic> Users, IEnumerable<dynamic> Orders)> GetMultipleResults(int userId)
        {
            using var connection = new NpgsqlConnection("DefaultConnection");

            var sql = @"
        SELECT * FROM users WHERE id = @UserId;
        SELECT * FROM orders WHERE user_id = @UserId;";

            using var multi = await connection.QueryMultipleAsync(sql, new { UserId = userId });

            // 关键：必须按照SQL语句中查询的顺序来读取结果集
            var users = await multi.ReadAsync<dynamic>();
            var orders = await multi.ReadAsync<dynamic>();

            return (users, orders);
        }

        // 封装一个流式查询的辅助方法 [2](@ref)
        public  async IAsyncEnumerable<dynamic> StreamDynamicQuery(string sql, object parameters = null)
        {
            using var connection = new NpgsqlConnection("DefaultConnection");
            await connection.OpenAsync();

            // 使用 CommandBehavior.SequentialAccess 优化流式读取性能
            var results = connection.Query<dynamic>(sql, parameters, buffered: false); // 注意 buffered: false

            foreach (var item in results)
            {
                yield return item;
            }
        }
    }
}
