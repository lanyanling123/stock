namespace StockAPI.Data
{
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
}
