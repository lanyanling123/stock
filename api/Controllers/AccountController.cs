using Microsoft.AspNetCore.Mvc;
using StockAPI.Data;
// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace StockAPI.Controllers
{
    [Route("api")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        // GET api/<AccountController>/5
        [HttpGet("currentUser")]
        public dynamic Get()
        {
            return new RequestResult()
            {
                data = new
                {
                    name = "Welcome",
                    avatar = "https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png",
                    userid = "00000001",
                    access = "admin",
                    unreadCount = 0
                }
            };
        }
        // POST api/<AccountController>
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<AccountController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<AccountController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
