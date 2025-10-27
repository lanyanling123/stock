using System.Text.Json.Serialization;

namespace StockAPI.Models;

public class ApiRequest
{
    [JsonPropertyName("date")]
    public string Date { get; set; } = string.Empty;

    [JsonPropertyName("pc")]
    public int Pc { get; set; } = 1;
}
// 响应数据模型
public class ApiResponse
{
    [JsonPropertyName("msg")]
    public string Message { get; set; } = string.Empty;

    [JsonPropertyName("data")]
    public List<ActionFieldData> Data { get; set; } = new();
}

public class ActionFieldData
{
    [JsonPropertyName("date")]
    public string Date { get; set; } = string.Empty;

    [JsonPropertyName("reason")]
    public string Reason { get; set; } = string.Empty;

    [JsonPropertyName("action_field_id")]
    public string ActionFieldId { get; set; } = string.Empty;

    [JsonPropertyName("name")]
    public string Name { get; set; } = string.Empty;

    [JsonPropertyName("count")]
    public int Count { get; set; }

    [JsonPropertyName("list")]
    public List<StockItem>? List { get; set; }
}

public class StockItem
{
    [JsonPropertyName("code")]
    public string Code { get; set; } = string.Empty;

    [JsonPropertyName("name")]
    public string Name { get; set; } = string.Empty;

    [JsonPropertyName("article")]
    public ArticleData Article { get; set; } = new();
}

public class ArticleData
{
    [JsonPropertyName("article_id")]
    public string ArticleId { get; set; } = string.Empty;

    [JsonPropertyName("comment_count")]
    public int CommentCount { get; set; }

    [JsonPropertyName("like_count")]
    public int LikeCount { get; set; }

    [JsonPropertyName("create_time")]
    public string CreateTime { get; set; } = string.Empty;

    [JsonPropertyName("title")]
    public string Title { get; set; } = string.Empty;

    [JsonPropertyName("action_info")]
    public ActionInfo ActionInfo { get; set; } = new();

    [JsonPropertyName("user")]
    public UserInfo User { get; set; } = new();
}

public class ActionInfo
{
    [JsonPropertyName("time")]
    public string Time { get; set; } = string.Empty;

    [JsonPropertyName("num")]
    public string Num { get; set; } = string.Empty;

    [JsonPropertyName("price")]
    public decimal Price { get; set; }

    [JsonPropertyName("day")]
    public int? Day { get; set; }

    [JsonPropertyName("expound")]
    public string Expound { get; set; } = string.Empty;
}

public class UserInfo
{
    [JsonPropertyName("user_id")]
    public string UserId { get; set; } = string.Empty;

    [JsonPropertyName("avatar")]
    public string Avatar { get; set; } = string.Empty;

    [JsonPropertyName("nickname")]
    public string Nickname { get; set; } = string.Empty;
}