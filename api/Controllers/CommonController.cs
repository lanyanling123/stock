using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using StockAPI.Data;
using StockAPI.Service;
using System.Runtime.CompilerServices;
using static System.Runtime.InteropServices.JavaScript.JSType;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace StockAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CommonController : ControllerBase
    {
        private readonly StockListService _stockListService;
        private readonly TradeDateService _tradeDateService;
        public CommonController(StockListService stockListService, TradeDateService tradeDateService)
        {
            _stockListService = stockListService;
            _tradeDateService = tradeDateService;
        }
        /// <summary>
        /// 获取最新交易日期
        /// </summary>
        /// <returns></returns>
        [HttpGet("latestdate")]
        public ActionResult Index() {
            var date = _tradeDateService.GetLatestTradeDate();
            return Ok(new RequestResult()
            {
                success = true,
                data = date
            });
        }
        /// <summary>
        /// 判断当前时间是否交易时间
        /// </summary>
        /// <returns></returns>
        [HttpGet("istradeday")]
        public async Task<IActionResult> IsTradeDay()
        {
            try
            {
                var data = await _tradeDateService.IsTradeDay();
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
        /// <summary>
        /// 通用接口，根据数据表名称返回数据
        /// </summary>
        /// <returns></returns>
        [HttpGet("query/{tableid}")]
        public async Task<IActionResult> GetTableDataCommon(int tableid)
        {
            try
            {
                var data = await _stockListService.GetTableDataByTableName(tableid, HttpContext.Request.Query);
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
        /// <summary>
        /// 通用接口，根据数据表名称更新数据
        /// </summary>
        /// <param name="tableid"></param>
        /// <returns></returns>
        [HttpGet("update/{tableid}")]
        public async Task<IActionResult> UpdateTableDataCommon(int tableid)
        {
            try
            {
                var data = await _stockListService.UpdateDataByTableName(tableid, HttpContext.Request.Query);
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
        [HttpGet("del/self")]
        public async Task<IActionResult> DeleteSelf(int subjectid, int t_date,string code)
        {
            try
            {
                var data = await _stockListService.DeleteSelfStock(subjectid, t_date, code);
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
        /// <summary>
        /// 获取最新日期
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [HttpGet("maxdatadate/{tableid}")]
        public async Task<IActionResult> GetLatestDate(int tableid)
        {
            try
            {
                var data = await _stockListService.MaxDataDate(tableid);
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

        /// <summary>
        /// 导入自选股，在主流题材中，把前1天的自选股导入到今天的自选股
        /// </summary>
        /// <param name="tableid"></param>
        /// <returns></returns>
        [HttpGet("import/self")]
        public async Task<IActionResult> ImportSelf(int subjectid,int date1,int date2)
        {
            try
            {
                var data = await _stockListService.ImportSelfStock(subjectid, date1, date2);
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
        /// <summary>
        /// 从异动题材导入股票到自定义题材
        /// </summary>
        /// <param name="plate_id"></param>
        /// <param name="subject_id"></param>
        /// <param name="t_date"></param>
        /// <returns></returns>
        [HttpGet("import/subject")]
        public async Task<IActionResult> ImportSubject(int plate_id, int subject_id, int t_date)
        {
            try
            {
                var data = await _stockListService.ImportSubjectStock(plate_id, subject_id, t_date);
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
        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="sujectid"></param>
        /// <param name="tdate1"></param>
        /// <param name="tdate2"></param>
        /// <returns></returns>

        [HttpGet("tradedate")]
        public async Task<IActionResult> GetTradeDateList(int days)
        {
            try
            {
                var lastDate = int.Parse(DateTime.Today.ToString("yyyyMMdd"));
                var dateList = await _tradeDateService.GetTradeDates(days, lastDate);
                return Ok(new RequestResult()
                {
                    success = true,
                    data = dateList
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
    }
}
