
using Npgsql;
using StockAPI.Service;
using System.Text.Json;
using System.Text.Json.Serialization;

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


            // ע�ᶨʱ����
            builder.Services.AddHostedService<StockAPI.Service.Jobs.PeriodicJobService>();
            // Program.cs �� Startup.cs ���ã������Ҫ��
            builder.Services.Configure<RouteOptions>(options =>
            {
                options.LowercaseUrls = true;
                options.LowercaseQueryStrings = true;
            });
            // ����CORS
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowWebApp", policy =>
                {
                    policy.WithOrigins(
                            "http://localhost:9000",
                            "https://localhost:9000",
                            "http://127.0.0.1:5500",
                            "http://localhost:8080"
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

            var app = builder.Build();

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
