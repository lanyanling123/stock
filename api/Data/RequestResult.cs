namespace StockAPI.Data
{
    public class jygs_token
    {
        public int id { get; set; }
        public string cookie { get; set; }
        public string token { get; set; }
    }

    public class RequestResult
    {
        public RequestResult() { }
        /// <summary>
        /// 请求结构
        /// </summary>
        public bool success { get; set; } = true;

        /// <summary>
        /// 数据
        /// </summary>
        public object? data { get; set; }

        public string? errorCode { get; set; }

        public string? errorMessage { get; set; }

        public int showType { get; set; }

        public string? traceId { get; set; }

        public string? host { get; set; }
    }
    // 请求模型类
    public class KLineRequest
    {
        /// <summary>
        /// 包含字段 ['name', 'symbol', 'yclose', 'open', 'price', 'high', 'low', 'vol']
        /// </summary>
        public List<string>? Field { get; set; }
        public string Symbol { get; set; }
        public int Start { get; set; }
        public int Count { get; set; }

        public string? EndDate { get; set; }
    }

    public class HistoryData
    {
        public int code { get; set; }
        public string name { get; set; }
        
        public string symbol { get; set; }

        public int count { get; set; }

        public object data { get; set; }

        public string? message { get; set; }

        public int ticket { get; set; } = 0;

        public string version { get; set; } = "2.0";
    }
}
