using Microsoft.AspNetCore.Mvc;
using StockAPI.Data;
using StockAPI.Service;
using System.Runtime.CompilerServices;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace StockAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StockController : ControllerBase
    {
        private readonly StockListService _stockListService;
        public StockController(StockListService stockListService)
        {
            _stockListService = stockListService;
        }
        /// <summary>
        /// 通用接口，根据数据表名称返回数据
        /// </summary>
        /// <returns></returns>
        [HttpGet("common/{table}")]
        public async Task<IActionResult> GetTableDataCommon(string table)
        {
            try
            {
                // 截取查询字符串?之后的内容
                var queryString = HttpContext.Request.QueryString.HasValue
                                ? HttpContext.Request.QueryString.Value!.TrimStart('?')
                                : string.Empty;

                var data = await _stockListService.GetTableDataByTableName(table, HttpContext.Request.Query);
                return Ok(new RequestResult()
                {
                    success = true,
                    data = data
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new RequestResult()
                {
                    success = false,
                    errorMessage = ex.Message
                });
            }
        }
        // 在API控制器中消费流式数据
        [HttpGet("large-data")]
        public async IAsyncEnumerable<dynamic> GetLargeDataStream()
        {
            await foreach (var item in _stockListService.StreamDynamicQuery("SELECT * FROM very_large_table"))
            {
                // 每读取一行就立即yield返回，实现流式输出
                yield return item;
            }
        }
        // GET: api/<StockController>
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<StockController>/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<StockController>
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<StockController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<StockController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
