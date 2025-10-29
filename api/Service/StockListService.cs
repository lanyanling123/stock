using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Configuration;
using Npgsql;
using StockAPI.Data;
using System.Data;

namespace StockAPI.Service
{
    public class StockListService
    {
        private readonly IConfiguration _configuration;
        public StockListService(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        /// <summary>
        /// 获取股票名称
        /// </summary>
        /// <param name="symbol"></param>
        /// <returns></returns>
        public async Task<string> GetStockName (string symbol)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var sql = "SELECT name FROM stock_board_industry_cons_em WHERE code = @Symbol LIMIT 1";
            var name = await connection.QueryFirstOrDefaultAsync<string>(sql, new { Symbol = symbol.Split('.')[0] });
            return name ?? "Unknown";
        }
        /// <summary>
        /// 删除自选
        /// </summary>
        /// <param name="subjectid"></param>
        /// <param name="date1"></param>
        /// <param name="date2"></param>
        /// <returns></returns>
        public async Task<bool> DeleteSelfStock(int subjectid, int t_date, string code)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var parameters = new DynamicParameters();
            parameters.Add("subjectid", subjectid);
            parameters.Add("t_date", t_date);
            parameters.Add("code", code);
            // 删除
            var sql = @"Delete from fupan_ticai_select where t_date=@t_date and subject_id = @subjectid and code = @code";
            var result = await connection.ExecuteAsync(sql, parameters);
            return result > 0;
        }
        /// <summary>
        /// 自选股最新日期
        /// </summary>
        /// <returns></returns>
        public async Task<int> MaxDataDate(int tableid)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            string? tableName = GetDBObjectName(connStr, tableid);
            if (tableName == null)
            {
                throw new Exception($"Table '{tableid}' does not exist.");
            }
            // 删除
            var sql = @$"Select max(t_date) as maxdate from {tableName}";
            var result = await connection.ExecuteScalarAsync<int>(sql);
            return result;
        }
        /// <summary>
        /// 导入主题题材自选股
        /// </summary>
        /// <param name="subjectid"></param>
        /// <param name="date1"></param>
        /// <param name="date2"></param>
        /// <returns></returns>
        public async Task<bool> ImportSelfStock(int subjectid,int date1,int date2)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var parameters = new DynamicParameters();
            parameters.Add("subjectid", subjectid);
            parameters.Add("date2", date2);
            // 先删除，再导入
            var sql = @"Delete from fupan_ticai_select where t_date=@date2 and subject_id = @subjectid";
            await connection.ExecuteAsync(sql, parameters);

            sql = @"Insert into fupan_ticai_select(t_date,subject_id,code,tags,order_no,flag)
                           select @date2, subject_id,code,tags,order_no,flag from fupan_ticai_select
                           where t_date=@date1 and subject_id = @subjectid
                          ON CONFLICT (subject_id,t_date,code) DO NOTHING;";

            parameters.Add("date1", date1);
            var result = await connection.ExecuteAsync(sql, parameters);
            return result > 0;
        }
        /// <summary>
        /// 从异动题材导入到自定义题材
        /// </summary>
        /// <param name="plate_id">异动题材ID</param>
        /// <param name="subject_id">自定义题材ID</param>
        /// <param name="t_date">异动日期</param>
        /// <returns></returns>
        public async Task<bool> ImportSubjectStock(int plate_id, int subject_id, int t_date)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            var parameters = new DynamicParameters();
            parameters.Add("plate_id", plate_id);
            parameters.Add("subject_id", subject_id);
            parameters.Add("t_date", t_date);

            string sql = @"Insert into fupan_ticai_stock(subject_id,code,name)
                           select @subject_id, code,name from jygs_yidong_stock
                           where t_date=@t_date and plate_id = @plate_id
                          ON CONFLICT (subject_id,code) DO NOTHING;";

            var result = await connection.ExecuteAsync(sql, parameters);
            return result > 0;
        }
        /// <summary>
        /// 通用更新数据库表数据
        /// </summary>
        /// <param name="tableid"></param>
        /// <param name="query"></param>
        /// <returns></returns>
        public async Task<bool> UpdateDataByTableName(int tableid, IQueryCollection query)
        { 
            // 默认 查询字符串格式：?pk=field1,field2&name=test&extra_field=extra
            // pk 值 为 数据库表 主键 字段名称
            // 其他字段 为 数据库表 字段名称
            // 如果 查询字符串 中 包含 pk 字段 则 更新 数据库表 主键 字段 否则 插入 数据库表 数据
            
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            string? tableName = GetDBObjectName(connStr,tableid);
            if (tableName == null)
            {
                throw new Exception($"Table '{tableid}' does not exist.");
            }
            // 检查表是否存在
            if (!DBMeta.TableExists(connStr, tableName))
            {
                throw new Exception($"Table '{tableName}' does not exist.");
            }
            
            // 获取表的所有字段信息
            var columns = await GetTableColumns(connStr, tableName);
            
            // 分离主键字段和其他字段
            var pkFields = new List<string>();
            var pkValues = new Dictionary<string, object>();
            var dataFields = new Dictionary<string, object>();

            foreach (var item in query)
            {
                string key = item.Key.Replace("[]", "");
                string value = item.Value.ToString().Trim();
                
                // 检查字段是否存在
                if (!columns.ContainsKey(key) && key != "pk") continue;
                if (key.Equals("pk", StringComparison.OrdinalIgnoreCase))
                {
                    // pk字段包含主键字段名称，用逗号分隔
                    pkFields.AddRange(value.Split(',').Select(s => s.Trim()));
                }
                else
                {
                    var convertedValue = string.IsNullOrEmpty(value) ? "":  ConvertToDbType(value, columns[key]);
                    if (pkFields.Contains(key))
                    {
                        // 转换数据类型
                        pkValues[key] = convertedValue;
                    }
                    else
                    {
                        dataFields[key] = convertedValue;
                    }
                }
            }
            
            // 验证主键字段
            foreach (var pkField in pkFields)
            {
                if (!columns.ContainsKey(pkField))
                {
                    throw new Exception($"Primary key field '{pkField}' does not exist in table '{tableName}'.");
                }
            }
            
            using var connection = new NpgsqlConnection(connStr);
            await connection.OpenAsync();
            
            if (pkFields.Count > 0 && dataFields.Count > 0)
            {
                // 更新操作
                return await UpdateRecord(connection, tableName, pkFields, dataFields, pkValues);
            }
            else if (dataFields.Count > 0)
            {
                // 插入操作
                return await InsertRecord(connection, tableName, dataFields);
            }
            else
            {
                throw new Exception("No valid data fields provided for update/insert operation.");
            }
        }
        /// <summary>
        /// 获取数据库表数据
        /// </summary>
        /// <param name="tableid"></param>
        /// <param name="query"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public async Task<dynamic> GetTableDataByTableName(int tableid, IQueryCollection query)
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            string? tableName = GetDBObjectName(connStr,tableid);
            if(tableName == null)
            {
                throw new Exception($"Table '{tableid}' does not exist.");
            }

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

        #region UpdateDataByTableName 辅助方法

        /// <summary>
        /// 获取表的所有字段信息
        /// </summary>
        private async Task<Dictionary<string, string>> GetTableColumns(string connectionString, string tableName)
        {
            var columns = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            const string columnSql = @"
                SELECT column_name, data_type
                FROM information_schema.columns
                WHERE table_schema = 'public' AND table_name = @tableName;
            ";

            using var connection = new NpgsqlConnection(connectionString);
            await connection.OpenAsync();
            
            using var command = new NpgsqlCommand(columnSql, connection);
            command.Parameters.AddWithValue("tableName", tableName);
            
            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                columns[reader.GetString(0)] = reader.GetString(1);
            }
            
            return columns;
        }

        /// <summary>
        /// 数据类型转换
        /// </summary>
        private object ConvertToDbType(string value, string dataType)
        {
            if (string.IsNullOrEmpty(value)) return DBNull.Value;
            
            return dataType.ToLower() switch
            {
                "integer" => int.TryParse(value, out var i) ? i : DBNull.Value,
                "bigint" => long.TryParse(value, out var l) ? l : DBNull.Value,
                "boolean" => bool.TryParse(value, out var b) ? b : DBNull.Value,
                "numeric" or "double precision" or "real" => double.TryParse(value, out var d) ? d : DBNull.Value,
                "timestamp without time zone" or "timestamp with time zone" or "date" => DateTime.TryParse(value, out var dt) ? dt : DBNull.Value,
                _ => value
            };
        }

        /// <summary>
        /// 更新记录
        /// </summary>
        private async Task<bool> UpdateRecord(NpgsqlConnection connection, string tableName, List<string> pkFields, Dictionary<string, object> dataFields, Dictionary<string, object> pkValues)
        {
            // 构建SET子句
            var setClauses = dataFields.Keys.Select(field => $"\"{field}\" = @{field}");
            var setClause = string.Join(", ", setClauses);
            
            // 构建WHERE子句
            var whereClauses = pkFields.Select(field => $"\"{field}\" = @pk_{field}");
            var whereClause = string.Join(" AND ", whereClauses);
            
            var sql = $"UPDATE \"{tableName}\" SET {setClause} WHERE {whereClause}";
            
            // 合并参数
            var parameters = new DynamicParameters();
            foreach (var field in dataFields)
            {
                parameters.Add(field.Key, field.Value);
            }
            foreach (var pkField in pkFields)
            {
                // 从dataFields中获取主键值，如果不存在则使用默认值
                var pkValue = pkValues.ContainsKey(pkField) ? pkValues[pkField] : DBNull.Value;
                parameters.Add($"pk_{pkField}", pkValue);
            }
            
            var result = await connection.ExecuteAsync(sql, parameters);
            return result > 0;
        }

        /// <summary>
        /// 插入记录
        /// </summary>
        private async Task<bool> InsertRecord(NpgsqlConnection connection, string tableName, Dictionary<string, object> dataFields)
        {
            var fieldNames = dataFields.Keys.Select(field => $"\"{field}\"").ToList();
            var paramNames = dataFields.Keys.Select(field => $"@{field}").ToList();
            
            var primaryString = GetTablePrimaryKey(connection, tableName);
            var sql = $"INSERT INTO \"{tableName}\" ({string.Join(", ", fieldNames)}) VALUES ({string.Join(", ", paramNames)}) ON CONFLICT ({primaryString}) DO NOTHING";
            
            var parameters = new DynamicParameters();
            foreach (var field in dataFields)
            {
                parameters.Add(field.Key, field.Value);
            }
            
            var result = await connection.ExecuteAsync(sql, parameters);
            return result > 0;
        }
        /// <summary>
        /// 获取数据库对象名称
        /// </summary>
        /// <param name="tableid"></param>
        /// <returns></returns>
        private string? GetDBObjectName(string connStr, int tableid)
        {
            string sql = @"select table_name from public.setting_table_mapping where map_id = @map_id";
            using var connection = new NpgsqlConnection(connStr);
            return connection.ExecuteScalar<string>(sql,new {map_id = tableid});
        }
        /// <summary>
        ///  获取表主键字段
        /// </summary>
        /// <param name="connStr"></param>
        /// <param name="tableName"></param>
        /// <returns></returns>
        private string? GetTablePrimaryKey(NpgsqlConnection connection, string tableName)
        {
            List<string> pkList = new List<string>();
            try
            {

                string sql = @"SELECT kcu.column_name as code FROM information_schema.table_constraints tco
                            JOIN information_schema.key_column_usage kcu ON tco.constraint_name = kcu.constraint_name AND tco.table_schema = kcu.table_schema AND tco.table_name = kcu.table_name
                            WHERE tco.table_schema = 'public'
                                AND tco.table_name = @tableName
                                AND tco.constraint_type = 'UNIQUE';";
                var dataList = connection.Query<StockAPI.Models.Subjects>(sql, new { tableName = tableName });
                foreach (var item in dataList)
                {
                    pkList.Add(item.code);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return string.Join(",", pkList);
        }
        #endregion
    }
}
