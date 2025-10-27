using Dapper;
using Npgsql;
using StockAPI.Models;

namespace StockAPI.Service
{
    public class ReviewSubjectSrc
    {
        private readonly IConfiguration _configuration;
        public ReviewSubjectSrc(IConfiguration configuration = null)
        {
            _configuration = configuration;
        }
    }
}
