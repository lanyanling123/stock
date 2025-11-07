
using Hangfire;
using Hangfire.Dashboard.BasicAuthorization;
using Hangfire.PostgreSql;
using Microsoft.AspNetCore.RateLimiting;
using Npgsql;
using StockAPI.Service;
using StockAPI.Service.Jobs;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.RateLimiting;

namespace StockAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.PropertyNamingPolicy = null;
                options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
            }); ;
            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            builder.Services.AddOpenApi();

            builder.Services.AddScoped<NpgsqlConnection>(provider =>
            {
                var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
                return new NpgsqlConnection(connectionString);
            });
            builder.Services.AddScoped<StockListService>();
            builder.Services.AddScoped<AkshareService>();
            builder.Services.AddScoped<JiuyangongsheService>();
            builder.Services.AddScoped<TradeDateService>();
            builder.Services.AddScoped<ReviewSubjectSrc>();

            builder.Services.AddScoped<AkshareData>();

            // Program.cs �� Startup.cs ���ã������Ҫ��
            builder.Services.Configure<RouteOptions>(options =>
            {
                options.LowercaseUrls = true;
                options.LowercaseQueryStrings = true;
            });

            builder.Services.AddHangfire(config => config.UsePostgreSqlStorage(builder.Configuration.GetConnectionString("HangfireConnection")));

            builder.Services.AddHangfireServer(); // 启动后台作业处理器

            // ����CORS
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowWebApp", policy =>
                {
                    policy.WithOrigins(
                            "http://51fupan.cn",
                            "https://51fupan.cn",
                            "http://127.0.0.1:5500",
                            "http://localhost:8000"
                        )
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                        .AllowCredentials();
                });

                // ������������������Դ
                options.AddPolicy("AllowAll", policy =>
                {
                    policy.AllowAnyOrigin()
                          .AllowAnyMethod()
                          .AllowAnyHeader();
                });
            });

            // 注册速率限制服务
            builder.Services.AddRateLimiter(options => {
                // 添加一个名为 "FixedWindow" 的固定窗口限流器
                options.AddFixedWindowLimiter("FixedWindow", policyOptions => {
                    policyOptions.PermitLimit = 20;    // 时间窗口内允许的请求数
                    policyOptions.Window = TimeSpan.FromSeconds(10); // 时间窗口长度（10秒）
                    policyOptions.QueueProcessingOrder = QueueProcessingOrder.OldestFirst;
                    policyOptions.QueueLimit = 2;     // 允许排队的请求数
                });
                // 你还可以在这里添加其他策略，如滑动窗口（AddSlidingWindowLimiter）或令牌桶（AddTokenBucketLimiter）
            });

            var app = builder.Build();
            app.UseRouting();
            app.UseRateLimiter();
            // 将限流策略应用到控制器路由
            app.MapControllers().RequireRateLimiting("FixedWindow");

            // 初始化Hangfire作业
            HangfireJobInitializer.InitializeHangfireJobs(app.Services, builder.Configuration);
            app.UseHangfireDashboard("/hangfire", new DashboardOptions
            {
                Authorization = new[]
                {
                   new BasicAuthAuthorizationFilter(
                            new BasicAuthAuthorizationFilterOptions
                            {
                                SslRedirect = false,
                                RequireSsl = false,
                                LoginCaseSensitive = false,
                                Users = new[]
                                {
                                            new BasicAuthAuthorizationUser
                                            {
                                                Login = builder.Configuration["Hangfire:Login"] ,
                                                PasswordClear= builder.Configuration["Hangfire:PasswordClear"]
                                            }
                                }
                            })
                },
            });
            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.MapOpenApi();
                app.UseCors("AllowAll"); // ��������ʹ�ÿ��ɲ���
            }
            else
            {
                app.UseCors("AllowWebApp"); // ��������ʹ���ϸ����
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
