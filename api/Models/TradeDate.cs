namespace StockAPI.Models
{
    public class TradeDate
    {
        /// <summary>
        /// T交易日
        /// </summary>
        public int T_date { get; set; }
        /// <summary>
        /// T+1交易日
        /// </summary>
        public int T_date_last1 { get; set; }
        public int T_date_last2 { get; set; }
        public int T_date_last3 { get; set; }
        public int T_date_last5 { get; set; }
        public int T_date_last10 { get; set; }
        public int T_date_last20 { get; set; }

        /// <summary>
        /// T-1交易日
        /// </summary>
        public int T_date_back1 { get; set; }
        public int T_date_back2 { get; set; }
        public int T_date_back3 { get; set; }
        public int T_date_back5 { get; set; }
        public int T_date_back10 { get; set; }
        public int T_date_back20 { get; set; }
    }
}
