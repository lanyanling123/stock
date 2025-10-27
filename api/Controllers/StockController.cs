using Microsoft.AspNetCore.Mvc;
using StockAPI.Data;
using StockAPI.Service;
using System.Runtime.CompilerServices;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace StockAPI.Controllers
{
    [Route("api")]
    [ApiController]
    public class StockController : ControllerBase
    {
        private readonly StockListService _stockListService;
        private readonly AkshareService _akshareService;
        public StockController(StockListService stockListService,AkshareService akshareService)
        {
            _stockListService = stockListService;
            _akshareService = akshareService;
        }

        /// <summary>
        /// 获取历史日线数据
        /// </summary>
        /// <returns>
        /// 返回data格式：[[yclose,open,price,high,low,vol]]
        /// </returns>
        [HttpPost("KLine2")]
        public async Task<IActionResult> RequestHistoryData([FromForm] KLineRequest request)
        {
            try
            {
               var  data = await _akshareService.stock_zh_a_hist(request,DateTime.Today);
                return Ok(data);
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
        [HttpPost("KLine5")]
        public async Task<IActionResult> RequestZoomDayData([FromForm] KLineRequest request)
        {
            try
            {
                if (DateTime.TryParseExact(request.EndDate, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out DateTime dt2))
                {
                    // 使用 dt2
                    var data = await _akshareService.stock_zh_a_hist(request, dt2);
                    return Ok(data);
                }
                else
                {
                    throw new Exception("EndDate format is incorrect. Please use 'yyyyMMdd'.");
                }
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
    }
}
