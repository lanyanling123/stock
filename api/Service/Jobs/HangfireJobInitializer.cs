using Hangfire;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace StockAPI.Service.Jobs
{
    public static class HangfireJobInitializer
    {
        public static void InitializeHangfireJobs(IServiceProvider serviceProvider, IConfiguration configuration)
        {
            using var scope = serviceProvider.CreateScope();
            var recurringJobManager = scope.ServiceProvider.GetRequiredService<IRecurringJobManager>();

            //使用服务接口（IRecurringJobManager）而不是静态类（RecurringJob）
            //recurringJobManager.AddOrUpdate<AkshareData>(
            //    "stock_zh_a_hist",
            //    j => j.stock_zh_a_hist(),
            //    configuration["HangfireJobs:stock_zh_a_hist"],
            //    new RecurringJobOptions { TimeZone = TimeZoneInfo.Local }
            //);
        }
    }
}