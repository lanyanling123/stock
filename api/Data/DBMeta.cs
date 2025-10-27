using Npgsql;
using System.Web;

namespace StockAPI.Data
{
    public static class DBMeta
    {
        // 根据表名称检查 postgresql 数据库中是否存在表对象
        /// <summary>
        /// 检查指定表名在 PostgreSQL 数据库中是否存在。
        /// </summary>
        /// <param name="connectionString">数据库连接字符串</param>
        /// <param name="tableName">要检查的表名（区分大小写）</param>
        /// <returns>如果表存在返回 true，否则返回 false</returns>
        public static bool TableExists(string connectionString, string tableName)
        {
            const string sql = @"
                SELECT EXISTS (
                    SELECT 1
                    FROM information_schema.tables
                    WHERE table_schema = 'public'
                      AND table_name = @tableName
                );
            ";

            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("tableName", tableName);

            return (bool)cmd.ExecuteScalar()!;
        }
        /// <summary>
        /// 根据表名和url查询字符串动态构建where条件（只包含表中存在的字段）。
        /// </summary>
        /// <param name="connectionString">数据库连接字符串</param>
        /// <param name="tableName">表名</param>
        /// <param name="queryString">url查询字符串，如：userid=admin&age=15</param>
        /// <returns>动态构建的where子句和参数字典</returns>
        public static (string whereClause, Dictionary<string, object> parameters) BuildWhereClause(string connectionString, string tableName, IQueryCollection query)
        {
            // 解析查询字符串
            if (query.Count == 0)
                return (string.Empty, new Dictionary<string, object>());

            // 查询表字段及类型
            var columns = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            const string columnSql = @"
                SELECT column_name, data_type
                FROM information_schema.columns
                WHERE table_schema = 'public' AND table_name = @tableName;
            ";

            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();
                using var cmd = new NpgsqlCommand(columnSql, conn);
                cmd.Parameters.AddWithValue("tableName", tableName);
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    columns[reader.GetString(0)] = reader.GetString(1);
                }
            }

            var whereList = new List<string>();
            var parameters = new Dictionary<string, object>();

            foreach (var item in query)
            {
                string key = item.Key.Replace("[]", "");
                string value = item.Value.ToString().Trim();
                if (!columns.ContainsKey(key)) continue; // 字段不存在则忽略

                var paramName = $"@{key}";
                if (item.Key.Contains("[]"))
                {
                    // t_date[]=20251016,t_date=20251017  这种格式，转换为 t_date >= 20251016 and t_date <= 20251017
                    parameters[$"@{key}_start"] = ConvertToDbType(value.Split(',')[0], columns[key]);
                    parameters[$"@{key}_end"] = ConvertToDbType(value.Split(',')[1], columns[key]);

                    whereList.Add($"\"{key}\" >= @{key}_start AND \"{key}\" <= @{key}_end");
                }
                else if (value.Contains(","))
                {
                    // 包含逗号的，则使用in查询
                    var paramList = new List<string>();
                    var arr = value.Split(',').Select(s => s.Trim()).ToArray();
                    for (int i = 0; i < arr.Length; i++)
                    {
                        var singleParam = $"{paramName}_in_{i}";
                        paramList.Add(singleParam);
                        parameters[singleParam] = ConvertToDbType(arr[i], columns[key]);
                    }
                    whereList.Add($"\"{key}\" in ({string.Join(",", paramList)})");
                }
                else
                {
                    if(whereList.Contains($"\"{key}\" = {paramName}"))
                    {
                        // t_date=20251016&t_date=20251017  这种格式，转换为 t_date >= 20251016 and t_date <= 20251017
                        whereList.Remove($"\"{key}\" = {paramName}");
                        parameters.Remove(paramName);

                        parameters[$"@{key}_start"] = parameters[paramName];
                        parameters[$"@{key}_end"] = ConvertToDbType(value, columns[key]);

                        whereList.Add($"\"{key}\" >= @{key}_start AND \"{key}\" <= @{key}_end");
                    }
                    else
                    {
                        parameters[paramName] = ConvertToDbType(value, columns[key]);
                        if(value.Contains("%"))
                        {
                            whereList.Add($"\"{key}\" like {paramName}");
                        }
                        else
                        {
                            whereList.Add($"\"{key}\" = {paramName}");
                        }
                    }
                }
            }

            var whereClause = whereList.Count > 0 ? "WHERE " + string.Join(" AND ", whereList) : string.Empty;
            return (whereClause, parameters);
        }

        // 简单类型转换，可根据需要扩展
        private static object ConvertToDbType(string? value, string dataType)
        {
            if (value == null) return DBNull.Value;
            return dataType switch
            {
                "integer" => int.TryParse(value, out var i) ? i : DBNull.Value,
                "bigint" => long.TryParse(value, out var l) ? l : DBNull.Value,
                "boolean" => bool.TryParse(value, out var b) ? b : DBNull.Value,
                "numeric" or "double precision" or "real" => double.TryParse(value, out var d) ? d : DBNull.Value,
                "timestamp without time zone" or "timestamp with time zone" or "date" => DateTime.TryParse(value, out var dt) ? dt : DBNull.Value,
                _ => value
            };
        }
    }
}
