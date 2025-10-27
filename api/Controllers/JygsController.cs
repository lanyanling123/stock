using Microsoft.AspNetCore.Mvc;
using StockAPI.Data;
using StockAPI.Service;
using System;
using System.Threading.Tasks;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace StockAPI.Controllers
{
    /// <summary>
    /// 韭研公社接口
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class JygsController : ControllerBase
    {
        private readonly JiuyangongsheService _jiuyangongsheService;
        private readonly TradeDateService _tradeDateService;
        public JygsController(JiuyangongsheService jiuyangongsheService,TradeDateService tradeDateService) { 
            _jiuyangongsheService = jiuyangongsheService;
            _tradeDateService = tradeDateService;
        }
        // GET: api/<JygsController>
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }
        /// <summary>
        /// 异动
        /// </summary>
        /// <param name="date">日期</param>
        /// <returns></returns>
        // GET api/<JygsController>/5
        [HttpGet("yidong")]
        public async Task<dynamic> Get(string date)
        {
            string dateStr = date ?? DateTime.Now.ToString("yyyy-MM-dd");
            var data = await _jiuyangongsheService.GetActionFieldDataAsync(dateStr);
            if (data != null)
            {
                _jiuyangongsheService.SaveDataToDB(data);
            }
            return data;
        }
        // GET api/<JygsController>/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }
        /// <summary>
        /// 更新cookie和token
        /// </summary>
        /// <param name="value"></param>
        // POST api/<JygsController>
        [HttpPost("updatetoken")]
        public void Post([FromBody] jygs_token value)
        {
             _jiuyangongsheService.UpdateToken(value);
        }
        // PUT api/<JygsController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<JygsController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
