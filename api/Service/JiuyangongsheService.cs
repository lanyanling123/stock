using Dapper;
using Microsoft.AspNetCore.Http.HttpResults;
using Npgsql;
using StockAPI.Data;
using StockAPI.Models;
using System;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;

namespace StockAPI.Service;

public class JiuyangongsheService
{
    private readonly HttpClient _httpClient;
    private const string BaseUrl = "https://app.jiuyangongshe.com";
    private const string ApiPath = "/jystock-app/api/v1/action/field";
    private readonly IConfiguration _configuration;
    private readonly TradeDateService _tradeDateService;
    public JiuyangongsheService(IConfiguration configuration, TradeDateService tradeDateService)
    {
        // 配置HttpClient
        var handler = new HttpClientHandler()
        {
            AutomaticDecompression = System.Net.DecompressionMethods.GZip |
                                   System.Net.DecompressionMethods.Deflate |
                                   System.Net.DecompressionMethods.Brotli
        };

        _httpClient = new HttpClient(handler)
        {
            BaseAddress = new Uri(BaseUrl),
            Timeout = TimeSpan.FromSeconds(30)
        };

        // 设置默认请求头
        SetDefaultHeaders();
        _configuration = configuration;
        _tradeDateService = tradeDateService;
    }
    private void SetDefaultHeaders()
    {
        _httpClient.DefaultRequestHeaders.Clear();
        _httpClient.DefaultRequestHeaders.Add("Accept", "application/json, text/plain, */*");
        _httpClient.DefaultRequestHeaders.Add("Accept-Encoding", "gzip, deflate, br, zstd");
        _httpClient.DefaultRequestHeaders.Add("Accept-Language", "zh-CN,zh;q=0.9");
        _httpClient.DefaultRequestHeaders.Add("Connection", "keep-alive");
        _httpClient.DefaultRequestHeaders.Add("Host", "app.jiuyangongshe.com");
        _httpClient.DefaultRequestHeaders.Add("Origin", "https://jiuyangongshe.com");
        _httpClient.DefaultRequestHeaders.Add("Referer", "https://jiuyangongshe.com/");
        _httpClient.DefaultRequestHeaders.Add("Sec-Fetch-Dest", "empty");
        _httpClient.DefaultRequestHeaders.Add("Sec-Fetch-Mode", "cors");
        _httpClient.DefaultRequestHeaders.Add("Sec-Fetch-Site", "same-site");
        _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36");
        _httpClient.DefaultRequestHeaders.Add("platform", "3");
        _httpClient.DefaultRequestHeaders.Add("sec-ch-ua", "\"Google Chrome\";v=\"141\", \"Not?A_Brand\";v=\"8\", \"Chromium\";v=\"141\"");
        _httpClient.DefaultRequestHeaders.Add("sec-ch-ua-mobile", "?0");
        _httpClient.DefaultRequestHeaders.Add("sec-ch-ua-platform", "\"Windows\"");
    }

    public async Task<ApiResponse?> GetActionFieldDataAsync(string date)
    {
        try
        {
            // 创建请求体
            var requestBody = new ApiRequest
            {
                Date = date,
                Pc = 1
            };
            // 创建请求内容（根据示例，请求体是空对象）
            var jsonContent = JsonSerializer.Serialize(requestBody);
            var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            // 创建请求消息以便添加特定的头信息
            var request = new HttpRequestMessage(HttpMethod.Post, ApiPath)
            {
                Content = content
            };

            var jygsToken = await GetToken();
            // 添加时间戳和token（这些可能是动态生成的）
            var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            request.Headers.Add("timestamp", timestamp.ToString());
            //request.Headers.Add("token", "f120fd90f6e1b40dbaa3006ebd2ed5a8");
            request.Headers.Add("token", jygsToken.token);
            // 添加Cookie
            //request.Headers.Add("Cookie", "SESSION=ZDBlY2JkMjMtN2Y3MS00NjFkLWExZWUtYmEzNDc4NjExNjlm; Hm_lvt_58aa18061df7855800f2a1b32d6da7f4=1758760787,1760014888,1760964085; Hm_lpvt_58aa18061df7855800f2a1b32d6da7f4=1761313154");
            request.Headers.Add("Cookie", jygsToken.cookie);
            Console.WriteLine($"发送请求到: {BaseUrl}{ApiPath}");
            // 发送请求
            var response = await _httpClient.SendAsync(request);

            Console.WriteLine($"响应状态: {response.StatusCode}");

            if (response.IsSuccessStatusCode)
            {
                var responseContent = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"响应内容长度: {responseContent.Length} 字符");

                // 反序列化响应
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                    WriteIndented = true
                };

                var apiResponse = JsonSerializer.Deserialize<ApiResponse>(responseContent, options);
                return apiResponse;
            }
            else
            {
                Console.WriteLine($"请求失败: {response.StatusCode}");
                var errorContent = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"错误内容: {errorContent}");
                return null;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"请求异常: {ex.Message}");
            return null;
        }
    }

    /// <summary>
    /// 从数据库获取cookie和token
    /// </summary>
    /// <returns></returns>
    public async Task<jygs_token> GetToken()
    {
        var connStr = _configuration.GetConnectionString("DefaultConnection");
        using var connection = new NpgsqlConnection(connStr);
        var sql = "select * from jygs_token where id = 1";
        var token = await connection.QueryFirstAsync<jygs_token>(sql);
        return token;
    }
    /// <summary>
    /// 更新cookie和token
    /// </summary>
    /// <param name="token"></param>
    public void UpdateToken(jygs_token token)
    {
        if(string.IsNullOrEmpty(token.token) || string.IsNullOrEmpty(token.cookie))
        {
            throw new ArgumentException("Token或Cookie不能为空");
        }
        var connStr = _configuration.GetConnectionString("DefaultConnection");
        using var connection = new NpgsqlConnection(connStr);
        var sql = "update jygs_token set cookie = @Cookie, token = @Token, updated_at = now() where id = 1";
        connection.Execute(sql, new { Cookie = token.cookie, Token = token.token });
    }
    /// <summary>
    /// 保存数据到数据库
    /// </summary>
    /// <param name="response"></param>
    /// <returns></returns>
    public bool SaveDataToDB(ApiResponse response)
    {
        try
        {
            var connStr = _configuration.GetConnectionString("DefaultConnection");
            using var connection = new NpgsqlConnection(connStr);
            foreach (var fieldData in response.Data)
            {
                if(fieldData.List== null || fieldData.List.Count == 0)
                {
                    continue;
                }
                // 批量插入或更新数据
                var sql = @"INSERT INTO jygs_yidong (name, t_date, zt_count, reason)
                                VALUES (@Name, @T_date, @Zt_count, @Reason)
                                ON CONFLICT (name, t_date) DO UPDATE 
                                SET zt_count = EXCLUDED.zt_count
                                RETURNING plate_id;";
                var plate_id = connection.ExecuteScalar<int>(sql, new
                {
                    Name = fieldData.Name,
                    T_date = int.Parse(DateTime.Parse(fieldData.Date).ToString("yyyyMMdd")),
                    Zt_count = fieldData.Count,
                    Reason = fieldData.Reason
                });
                //Console.WriteLine($"保存异动字段: {fieldData.Name} 日期: {fieldData.Date} 记录ID: {plate_id}");
                foreach (var stock in fieldData.List)
                {
                    sql = @"INSERT INTO jygs_yidong_stock (code,code2, name, title, time, num, price, day, expound, plate_id, t_date)
                                VALUES (@code, @code2, @name, @title, @time, @num, @price, @day, @expound, @plate_id, @t_date)
                                ON CONFLICT (code, t_date) DO NOTHING ;";
                    connection.Execute(sql, new
                    {
                        code = stock.Code.Substring(2),
                        code2 = stock.Code,
                        name = stock.Name,
                        title = stock.Article.Title,
                        time = stock.Article.ActionInfo.Time,
                        num = stock.Article.ActionInfo.Num,
                        price = stock.Article.ActionInfo.Price / 100m,
                        day = stock.Article.ActionInfo.Day,
                        expound = stock.Article.ActionInfo.Expound,
                        plate_id = plate_id,
                        t_date = int.Parse(DateTime.Parse(stock.Article.CreateTime).ToString("yyyyMMdd")),
                    });
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"保存数据异常: {ex.Message}");
            return false;
        }
    }
    public void DisplayResults(ApiResponse? response)
    {
        if (response == null)
        {
            Console.WriteLine("没有获取到数据");
            return;
        }

        Console.WriteLine($"\n=== 韭研公社API响应 ===");
        Console.WriteLine($"消息: {response.Message}");
        Console.WriteLine($"数据项数量: {response.Data.Count}");

        foreach (var fieldData in response.Data)
        {
            Console.WriteLine($"\n--- {fieldData.Name} ({fieldData.Date}) ---");
            Console.WriteLine($"计数: {fieldData.Count}");

            if (fieldData.List != null && fieldData.List.Any())
            {
                Console.WriteLine("股票列表:");
                foreach (var stock in fieldData.List)
                {
                    Console.WriteLine($"  代码: {stock.Code}");
                    Console.WriteLine($"  名称: {stock.Name}");
                    Console.WriteLine($"  标题: {stock.Article.Title}");
                    Console.WriteLine($"  时间: {stock.Article.ActionInfo.Time}");
                    Console.WriteLine($"  连板: {stock.Article.ActionInfo.Num}");
                    Console.WriteLine($"  价格: {stock.Article.ActionInfo.Price / 100:C}");
                    Console.WriteLine($"  天数: {stock.Article.ActionInfo.Day}天");
                    Console.WriteLine($"  作者: {stock.Article.User.Nickname}");
                    Console.WriteLine($"  简述: {TruncateText(stock.Article.ActionInfo.Expound, 100)}");
                    Console.WriteLine("  " + new string('-', 50));
                }
            }
        }
    }

    private string TruncateText(string text, int maxLength)
    {
        if (string.IsNullOrEmpty(text) || text.Length <= maxLength)
            return text;

        return text.Substring(0, maxLength) + "...";
    }

    public void Dispose()
    {
        _httpClient?.Dispose();
    }
}