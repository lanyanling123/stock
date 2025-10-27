using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace StockAPI.Service.Jobs
{
    public class PeriodicJobService : BackgroundService
    {
        private readonly IServiceProvider _provider;
        private readonly ILogger<PeriodicJobService> _logger;
        // 间隔可以从配置读取，这里示例为每24小时一次
        private readonly TimeSpan _interval;

        public PeriodicJobService(IServiceProvider provider, ILogger<PeriodicJobService> logger)
        {
            _provider = provider;
            _logger = logger;
            _interval = TimeSpan.FromHours(24); // 可改为从 IConfiguration 读取
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("PeriodicJobService 启动，间隔：{Interval}", _interval);

            // 第一次延迟为0，立即执行，或可改为根据配置计算首次触发时间
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    // 检查是否为工作日且时间在15:30之后
                    var now = DateTime.Now;
                    var isWeekday = now.DayOfWeek >= DayOfWeek.Monday && now.DayOfWeek <= DayOfWeek.Friday;
                    var targetTime = new TimeSpan(15, 30, 0);

                    if (!isWeekday || now.TimeOfDay < targetTime)
                    {
                        // 如果不是工作日或时间未到15:30，计算到下一个工作日15:30的延迟时间
                        var nextExecutionTime = CalculateNextExecutionTime(now);
                        var delay = nextExecutionTime - now;
                        _logger.LogInformation("当前时间不符合执行条件，等待到 {NextExecutionTime} 执行", nextExecutionTime);
                        await Task.Delay(delay, stoppingToken);
                        continue;
                    }

                    // 添加随机分钟数（1-30分钟）
                    var random = new Random();
                    var randomMinutes = random.Next(1, 31);
                    _logger.LogInformation("添加随机延迟 {RandomMinutes} 分钟", randomMinutes);
                    await Task.Delay(TimeSpan.FromMinutes(randomMinutes), stoppingToken);

                    using var scope = _provider.CreateScope();
                    // 从 DI 容器解析你需要的服务
                    var jiuyangService = scope.ServiceProvider.GetRequiredService<JiuyangongsheService>();
                    var tradeDateService = scope.ServiceProvider.GetRequiredService<TradeDateService>();

                    // 检查是否为交易日
                    if (tradeDateService.IsTradeDate(int.Parse(DateTime.Now.ToString("yyyyMMdd"))).Result == false)
                    {
                        _logger.LogInformation("今日非交易日，跳过数据抓取");
                        continue;
                    }

                    // 示例：按你现有逻辑批量抓取并保存数据
                    var lastDate = int.Parse(DateTime.Today.ToString("yyyyMMdd"));
                    var dateList = await tradeDateService.GetTradeDates(150, 20250627);

                    foreach (var dt in dateList)
                    {
                        if (stoppingToken.IsCancellationRequested) break;

                        // 产生随机休眠避免被目标频率限制
                        var waitSeconds = random.Next(30, 60);
                        await Task.Delay(TimeSpan.FromSeconds(waitSeconds), stoppingToken);
                        var tdate = DateTime.ParseExact(dt.T_date.ToString(), "yyyyMMdd", null);
                        string result = tdate.ToString("yyyy-MM-dd");
                        _logger.LogInformation("开始获取日期 {Date} 数据", result);

                        var data = await jiuyangService.GetActionFieldDataAsync(result);
                        jiuyangService.SaveDataToDB(data);
                    }
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    // 取消，直接退出
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "PeriodicJobService 执行任务时发生异常");
                }

                try
                {
                    await Task.Delay(_interval, stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    break;
                }
            }

            _logger.LogInformation("PeriodicJobService 停止");
        }

        /// <summary>
        /// 计算下一个执行时间（工作日15:30）
        /// </summary>
        /// <param name="currentTime">当前时间</param>
        /// <returns>下一个执行时间</returns>
        private DateTime CalculateNextExecutionTime(DateTime currentTime)
        {
            var targetTime = new TimeSpan(15, 30, 0);
            var nextExecution = currentTime.Date.Add(targetTime);

            // 如果当前时间已经过了今天的15:30，或者今天不是工作日，则找到下一个工作日
            if (currentTime.TimeOfDay >= targetTime || currentTime.DayOfWeek == DayOfWeek.Saturday || currentTime.DayOfWeek == DayOfWeek.Sunday)
            {
                // 找到下一个工作日
                do
                {
                    nextExecution = nextExecution.AddDays(1);
                } while (nextExecution.DayOfWeek == DayOfWeek.Saturday || nextExecution.DayOfWeek == DayOfWeek.Sunday);
            }

            return nextExecution;
        }
    }
}
