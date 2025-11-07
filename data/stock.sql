/*
 Navicat PostgreSQL Data Transfer

 Source Server         : 47.107.75.105
 Source Server Type    : PostgreSQL
 Source Server Version : 140005 (140005)
 Source Host           : 47.107.75.105:54322
 Source Catalog        : akshare
 Source Schema         : stock

 Target Server Type    : PostgreSQL
 Target Server Version : 140005 (140005)
 File Encoding         : 65001

 Date: 01/07/2023 21:01:25
*/


-- ----------------------------
-- Sequence structure for stock_select_shapes_group_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "stock"."stock_select_shapes_group_id_seq";
CREATE SEQUENCE "stock"."stock_select_shapes_group_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tool_trade_date_hist_sina_tid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "stock"."tool_trade_date_hist_sina_tid_seq";
CREATE SEQUENCE "stock"."tool_trade_date_hist_sina_tid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for fund_etf_list
-- ----------------------------
DROP TABLE IF EXISTS "stock"."fund_etf_list";
CREATE TABLE "stock"."fund_etf_list" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."fund_etf_list" IS 'ETF列表';

-- ----------------------------
-- Table structure for fund_etf_spot_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."fund_etf_spot_em";
CREATE TABLE "stock"."fund_etf_spot_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(32,2),
  "close" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "t_amount" numeric(32,2),
  "t_monry" numeric(32,2),
  "change" numeric(32,2),
  "change_price" numeric(32,2),
  "hands" numeric(32,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "market_val" numeric(32,2),
  "name" varchar COLLATE "pg_catalog"."default",
  "last_price" numeric(18,2)
)
;
COMMENT ON COLUMN "stock"."fund_etf_spot_em"."market_val" IS '市值';
COMMENT ON COLUMN "stock"."fund_etf_spot_em"."last_price" IS '昨收';
COMMENT ON TABLE "stock"."fund_etf_spot_em" IS 'ETF 实时行情';

-- ----------------------------
-- Table structure for fund_name_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."fund_name_em";
CREATE TABLE "stock"."fund_name_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON TABLE "stock"."fund_name_em" IS '基金列表';

-- ----------------------------
-- Table structure for fund_portfolio_hold_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."fund_portfolio_hold_em";
CREATE TABLE "stock"."fund_portfolio_hold_em" (
  "fund_code" varchar(255) COLLATE "pg_catalog"."default",
  "stock_code" varchar(255) COLLATE "pg_catalog"."default",
  "netvalue_rate" numeric(18,2),
  "hold_count" numeric(18,2),
  "hold_values" numeric(18,2),
  "year" int4,
  "quarter" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "stock_name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."fund_code" IS '基金代码';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."stock_code" IS '股票代码';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."netvalue_rate" IS '占净值比例';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."hold_count" IS '持股数';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."hold_values" IS '持仓市值';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."year" IS '年';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."quarter" IS '季度';
COMMENT ON COLUMN "stock"."fund_portfolio_hold_em"."stock_name" IS '股票名称';
COMMENT ON TABLE "stock"."fund_portfolio_hold_em" IS '基金持仓';

-- ----------------------------
-- Table structure for index_all_cni
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_all_cni";
CREATE TABLE "stock"."index_all_cni" (
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."index_all_cni" IS '中证全部指数列表';

-- ----------------------------
-- Table structure for index_detail_cni
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_detail_cni";
CREATE TABLE "stock"."index_detail_cni" (
  "index_code" varchar COLLATE "pg_catalog"."default",
  "index_name" varchar COLLATE "pg_catalog"."default",
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default",
  "new_date" varchar COLLATE "pg_catalog"."default",
  "board" varchar COLLATE "pg_catalog"."default",
  "market_value" varchar COLLATE "pg_catalog"."default",
  "rate" varchar COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."index_detail_cni"."index_code" IS '指数代码';
COMMENT ON COLUMN "stock"."index_detail_cni"."index_name" IS '指数名称';
COMMENT ON COLUMN "stock"."index_detail_cni"."code" IS '样本代码';
COMMENT ON COLUMN "stock"."index_detail_cni"."name" IS '样本名称';
COMMENT ON COLUMN "stock"."index_detail_cni"."new_date" IS '样本日期';
COMMENT ON COLUMN "stock"."index_detail_cni"."board" IS '所属行业';
COMMENT ON COLUMN "stock"."index_detail_cni"."market_value" IS '市值';
COMMENT ON COLUMN "stock"."index_detail_cni"."rate" IS '权重';
COMMENT ON TABLE "stock"."index_detail_cni" IS '指数成分股';

-- ----------------------------
-- Table structure for index_value_hist_funddb
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_value_hist_funddb";
CREATE TABLE "stock"."index_value_hist_funddb" (
  "t_date" int4,
  "new_pe" numeric(12,2),
  "rate_pe" numeric(12,2),
  "new_pb" numeric(12,2),
  "rate_pb" numeric(12,2),
  "dividend" numeric(12,2),
  "rate_dividend" numeric(12,2),
  "risk" numeric(12,2),
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."index_value_hist_funddb" IS '指数历史估值';

-- ----------------------------
-- Table structure for index_value_hist_funddb_fxyj
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_value_hist_funddb_fxyj";
CREATE TABLE "stock"."index_value_hist_funddb_fxyj" (
  "t_date" int4,
  "new_pe" numeric(12,2),
  "rate_pe" numeric(12,2),
  "new_pb" numeric(12,2),
  "rate_pb" numeric(12,2),
  "dividend" numeric(12,2),
  "rate_dividend" numeric(12,2),
  "risk" numeric(12,2),
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."index_value_hist_funddb_fxyj"."risk" IS '风险溢价';
COMMENT ON TABLE "stock"."index_value_hist_funddb_fxyj" IS '指数历史风险溢价';

-- ----------------------------
-- Table structure for index_value_hist_funddb_gxl
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_value_hist_funddb_gxl";
CREATE TABLE "stock"."index_value_hist_funddb_gxl" (
  "t_date" int4,
  "new_pe" numeric(12,2),
  "rate_pe" numeric(12,2),
  "new_pb" numeric(12,2),
  "rate_pb" numeric(12,2),
  "dividend" numeric(12,2),
  "rate_dividend" numeric(12,2),
  "risk" numeric(12,2),
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."index_value_hist_funddb_gxl" IS '指数历史股息率';

-- ----------------------------
-- Table structure for index_value_hist_funddb_sjl
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_value_hist_funddb_sjl";
CREATE TABLE "stock"."index_value_hist_funddb_sjl" (
  "t_date" int4,
  "new_pe" numeric(12,2),
  "rate_pe" numeric(12,2),
  "new_pb" numeric(12,2),
  "rate_pb" numeric(12,2),
  "dividend" numeric(12,2),
  "rate_dividend" numeric(12,2),
  "risk" numeric(12,2),
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."index_value_hist_funddb_sjl" IS '指数历史市净率';

-- ----------------------------
-- Table structure for index_value_name_funddb
-- ----------------------------
DROP TABLE IF EXISTS "stock"."index_value_name_funddb";
CREATE TABLE "stock"."index_value_name_funddb" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "new_pe" numeric(18,2),
  "rate_pe" numeric(18,2),
  "new_pb" numeric(18,2),
  "rate_pb" numeric(18,2),
  "dividend" numeric(18,2),
  "rate_dividend" numeric(18,2),
  "start_date" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4
)
;
COMMENT ON COLUMN "stock"."index_value_name_funddb"."code" IS '指数代码';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."name" IS '指数名称';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."new_pe" IS '最新PE';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."rate_pe" IS 'PE分位';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."new_pb" IS '最新PB';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."rate_pb" IS 'PB分位';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."dividend" IS '股息率';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."rate_dividend" IS '股息率分位';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."start_date" IS '指数开始时间';
COMMENT ON COLUMN "stock"."index_value_name_funddb"."t_date" IS '更新时间';
COMMENT ON TABLE "stock"."index_value_name_funddb" IS '指数估值';

-- ----------------------------
-- Table structure for stock_a_lg_indicator
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_a_lg_indicator";
CREATE TABLE "stock"."stock_a_lg_indicator" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "pe" numeric(18,2),
  "pe_ttm" numeric(18,2),
  "pb" numeric(18,2),
  "ps" numeric(18,2),
  "ps_ttm" numeric(18,2),
  "dv_ratio" numeric(18,2),
  "dv_ttm" numeric(18,2),
  "total_mv" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "pe_ttm_fw" int4
)
;
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."pe" IS '市盈率';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."pe_ttm" IS '市盈率TTM';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."pb" IS '市净率';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."ps" IS '	市销率';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."ps_ttm" IS '市销率TTM';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."dv_ratio" IS '股息率';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."dv_ttm" IS '股息率TTM';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."total_mv" IS '总市值';
COMMENT ON COLUMN "stock"."stock_a_lg_indicator"."pe_ttm_fw" IS '市盈率TTM分位数';
COMMENT ON TABLE "stock"."stock_a_lg_indicator" IS '股个股指标: 市盈率, 市净率, 股息率';

-- ----------------------------
-- Table structure for stock_board_concept_cons_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_concept_cons_ths";
CREATE TABLE "stock"."stock_board_concept_cons_ths" (
  "t_date" int4,
  "name" varchar COLLATE "pg_catalog"."default",
  "stock_count" int4,
  "code" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "board_name" varchar COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "stock"."stock_board_concept_cons_ths"."t_date" IS '添加时间';
COMMENT ON COLUMN "stock"."stock_board_concept_cons_ths"."name" IS '成分股概念名称';
COMMENT ON COLUMN "stock"."stock_board_concept_cons_ths"."stock_count" IS '成分股数量';
COMMENT ON COLUMN "stock"."stock_board_concept_cons_ths"."code" IS '成分股代码';
COMMENT ON COLUMN "stock"."stock_board_concept_cons_ths"."board_name" IS '概念名称';
COMMENT ON TABLE "stock"."stock_board_concept_cons_ths" IS '同花顺-板块-概念板块-概念';

-- ----------------------------
-- Table structure for stock_board_industry_hist_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_hist_em";
CREATE TABLE "stock"."stock_board_industry_hist_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(18,2),
  "close" numeric(18,2),
  "high" numeric(18,2),
  "low" numeric(18,2),
  "t_amount" numeric(18,2),
  "t_monry" numeric(18,2),
  "swing" numeric(18,2),
  "change" numeric(18,2),
  "change_price" numeric(18,2),
  "hands" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "last4" numeric(18,2),
  "r_flag" int2,
  "r9" int2,
  "flat" int2,
  "t_time" timestamp(6)
)
;
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."open" IS '开盘';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."close" IS '收盘';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."high" IS '最高';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."low" IS '最低';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."t_monry" IS '成交额';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."swing" IS '振幅';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_board_industry_hist_em"."hands" IS '换手率';

-- ----------------------------
-- Table structure for stock_board_industry_hist_min_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_hist_min_em";
CREATE TABLE "stock"."stock_board_industry_hist_min_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(18,2),
  "close" numeric(18,2),
  "high" numeric(18,2),
  "low" numeric(18,2),
  "t_amount" numeric(18,2),
  "t_monry" numeric(18,2),
  "swing" numeric(18,2),
  "change" numeric(18,2),
  "change_price" numeric(18,2),
  "hands" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "last4" numeric(18,2),
  "r_flag" int2,
  "r9" int2,
  "flat" int2,
  "t_time" timestamp(6) NOT NULL,
  "period" int8 NOT NULL
)
;
COMMENT ON COLUMN "stock"."stock_board_industry_hist_min_em"."period" IS '分钟标识，120表示120分钟';

-- ----------------------------
-- Table structure for stock_board_industry_index_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_index_ths";
CREATE TABLE "stock"."stock_board_industry_index_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(32,2),
  "close" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "t_amount" int8,
  "t_monry" numeric(32,2),
  "time_flag" int4 NOT NULL,
  "last4" numeric(18,2),
  "r_flag" int2,
  "r9" int2,
  "flat" int2,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_board_industry_index_ths"."time_flag" IS '时间标识1:日线 120:分钟线';
COMMENT ON TABLE "stock"."stock_board_industry_index_ths" IS '同花顺-板块-行业板块-指数日频率数据';

-- ----------------------------
-- Table structure for stock_board_industry_info_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_info_ths";
CREATE TABLE "stock"."stock_board_industry_info_ths" (
  "industry_code" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "stock_code" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "stock_name" varchar COLLATE "pg_catalog"."default",
  "industry_name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_board_industry_info_ths"."industry_code" IS '行业代码';
COMMENT ON COLUMN "stock"."stock_board_industry_info_ths"."stock_code" IS '股票代码';
COMMENT ON COLUMN "stock"."stock_board_industry_info_ths"."stock_name" IS '股票名称';
COMMENT ON COLUMN "stock"."stock_board_industry_info_ths"."industry_name" IS '行业名称';
COMMENT ON TABLE "stock"."stock_board_industry_info_ths" IS '同花顺行业股票';

-- ----------------------------
-- Table structure for stock_board_industry_name_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_name_em";
CREATE TABLE "stock"."stock_board_industry_name_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."stock_board_industry_name_em" IS '东财行业列表';

-- ----------------------------
-- Table structure for stock_board_industry_name_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_name_ths";
CREATE TABLE "stock"."stock_board_industry_name_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."stock_board_industry_name_ths" IS '同花顺行业列表';

-- ----------------------------
-- Table structure for stock_board_industry_summary_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_board_industry_summary_ths";
CREATE TABLE "stock"."stock_board_industry_summary_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "change" numeric(18,2),
  "t_amount" numeric(18,2),
  "t_monry" numeric(18,2),
  "net_flow_in" numeric(18,2),
  "up_count" int4,
  "down_count" int4,
  "head_stock" varchar(255) COLLATE "pg_catalog"."default",
  "head_stock_change" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "last4" numeric(18,2),
  "r_flag" int2,
  "r9" int2,
  "flat" int2,
  "time_flag" int4 NOT NULL
)
;
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."code" IS '板块';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."t_monry" IS '成交额';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."net_flow_in" IS '净流入';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."up_count" IS '上涨家数';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."down_count" IS '下跌家数';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."head_stock" IS '领涨股';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."head_stock_change" IS '领涨股涨跌幅';
COMMENT ON COLUMN "stock"."stock_board_industry_summary_ths"."time_flag" IS '时间标识';
COMMENT ON TABLE "stock"."stock_board_industry_summary_ths" IS '当前时刻同花顺行业一览表';

-- ----------------------------
-- Table structure for stock_change_period
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_change_period";
CREATE TABLE "stock"."stock_change_period" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "change" numeric(10,2),
  "day3" numeric(10,2),
  "day5" numeric(10,2),
  "day10" numeric(10,2),
  "day20" numeric(10,2),
  "day30" numeric(10,2),
  "day60" numeric(10,2),
  "day90" numeric(10,2),
  "day120" numeric(10,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "day1" numeric(10,2)
)
;
COMMENT ON COLUMN "stock"."stock_change_period"."change" IS '当日涨幅';
COMMENT ON COLUMN "stock"."stock_change_period"."day3" IS 'T+3日涨幅';
COMMENT ON COLUMN "stock"."stock_change_period"."day5" IS 'T+5日涨幅';
COMMENT ON COLUMN "stock"."stock_change_period"."day1" IS 'T+1日涨幅';
COMMENT ON TABLE "stock"."stock_change_period" IS '股票未来多时间区间涨幅';

-- ----------------------------
-- Table structure for stock_changes_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_changes_em";
CREATE TABLE "stock"."stock_changes_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_time" timestamp(6),
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "info" varchar(255) COLLATE "pg_catalog"."default",
  "t_type" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_date" int4
)
;
COMMENT ON TABLE "stock"."stock_changes_em" IS '行情中心-盘口异动数据';

-- ----------------------------
-- Table structure for stock_fhps_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_fhps_em";
CREATE TABLE "stock"."stock_fhps_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "profit_rate" numeric(18,4),
  "dividend_rate" numeric(18,4),
  "pre_share" numeric(18,4),
  "net_value" numeric(18,4),
  "notice_date" date,
  "exdividend_date" date,
  "check_date" date,
  "progress" varchar(255) COLLATE "pg_catalog"."default",
  "new_notice_date" date,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "transfer_total_rate" numeric(18,4),
  "transfer_rate" numeric(18,4),
  "transfer_share_rate" numeric(18,4)
)
;
COMMENT ON COLUMN "stock"."stock_fhps_em"."profit_rate" IS '现金分红-现金分红比例';
COMMENT ON COLUMN "stock"."stock_fhps_em"."dividend_rate" IS '现金分红-股息率';
COMMENT ON COLUMN "stock"."stock_fhps_em"."pre_share" IS '每股收益';
COMMENT ON COLUMN "stock"."stock_fhps_em"."net_value" IS '每股净资产';
COMMENT ON COLUMN "stock"."stock_fhps_em"."notice_date" IS '预案公告日';
COMMENT ON COLUMN "stock"."stock_fhps_em"."exdividend_date" IS '除权除息日';
COMMENT ON COLUMN "stock"."stock_fhps_em"."check_date" IS '股权登记日';
COMMENT ON COLUMN "stock"."stock_fhps_em"."progress" IS '方案进度';
COMMENT ON COLUMN "stock"."stock_fhps_em"."new_notice_date" IS '最新公告日期';
COMMENT ON COLUMN "stock"."stock_fhps_em"."transfer_total_rate" IS '送转股份-送转总比例';
COMMENT ON COLUMN "stock"."stock_fhps_em"."transfer_rate" IS '送转股份-送转比例';
COMMENT ON COLUMN "stock"."stock_fhps_em"."transfer_share_rate" IS '送转股份-转股比例';
COMMENT ON TABLE "stock"."stock_fhps_em" IS '分红配送';

-- ----------------------------
-- Table structure for stock_fund_flow_big_deal
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_fund_flow_big_deal";
CREATE TABLE "stock"."stock_fund_flow_big_deal" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_time" timestamp(6),
  "price" numeric(18,2),
  "t_amount" numeric(18,2),
  "bill_type" varchar(255) COLLATE "pg_catalog"."default",
  "change" numeric(18,2),
  "change_price" numeric(18,2),
  "t_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_money" numeric(18,2)
)
;
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."t_time" IS '成交时间';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."price" IS '成交价格';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."bill_type" IS '大单性质';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."t_date" IS '交易日期';
COMMENT ON COLUMN "stock"."stock_fund_flow_big_deal"."t_money" IS '成交额';
COMMENT ON TABLE "stock"."stock_fund_flow_big_deal" IS '大单资金流';

-- ----------------------------
-- Table structure for stock_fund_flow_individual
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_fund_flow_individual";
CREATE TABLE "stock"."stock_fund_flow_individual" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "new_price" numeric(18,2),
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "in_money" numeric(18,2),
  "out_money" numeric(18,2),
  "net_money" numeric(18,2),
  "t_amount" numeric(18,2),
  "big_bill_in" varchar(18) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_type" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."code" IS '股票代码';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."name" IS '股票简称';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."in_money" IS '流入资金';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."out_money" IS '流出资金';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."net_money" IS '净额';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."t_amount" IS '成交额';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."big_bill_in" IS '大单流入';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."t_date" IS '交易日期';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual"."t_type" IS '数据类型';
COMMENT ON TABLE "stock"."stock_fund_flow_individual" IS '个股自资金流';

-- ----------------------------
-- Table structure for stock_fund_flow_individual_day
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_fund_flow_individual_day";
CREATE TABLE "stock"."stock_fund_flow_individual_day" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "new_price" numeric(18,2),
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "net_in_money" numeric(18,2),
  "t_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_type" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."code" IS '股票代码';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."name" IS '股票简称';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."change" IS '阶段涨跌幅';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."hands" IS '连续换手率';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."net_in_money" IS '资金流入净额';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."t_date" IS '交易日期';
COMMENT ON COLUMN "stock"."stock_fund_flow_individual_day"."t_type" IS '数据类型';

-- ----------------------------
-- Table structure for stock_fund_flow_industry
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_fund_flow_industry";
CREATE TABLE "stock"."stock_fund_flow_industry" (
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "ind_index" numeric(18,2),
  "change" numeric(18,2),
  "in_money" numeric(18,2),
  "out_money" numeric(18,2),
  "net_money" numeric(18,2),
  "t_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_type" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."name" IS '行业';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."ind_index" IS '行业指数';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."in_money" IS '流入资金';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."out_money" IS '流出资金';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."net_money" IS '净额';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."t_date" IS '交易日期';
COMMENT ON COLUMN "stock"."stock_fund_flow_industry"."t_type" IS '数据类型';
COMMENT ON TABLE "stock"."stock_fund_flow_industry" IS '行业资金流';

-- ----------------------------
-- Table structure for stock_hsgt_hold_stock_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_hsgt_hold_stock_em";
CREATE TABLE "stock"."stock_hsgt_hold_stock_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "close" numeric(32,2),
  "change" numeric(32,2),
  "stock_number" numeric(32,2),
  "stock_value" numeric(32,2),
  "flow_market_rate" numeric(32,2),
  "buy_stock_number" numeric(32,2),
  "buy_stock_value" numeric(32,2),
  "buy_rate" numeric(32,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "board" varchar COLLATE "pg_catalog"."default",
  "buy_flow_market_rate" numeric(32,2)
)
;
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."change" IS '当日涨跌幅';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."stock_number" IS '持股数量';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."stock_value" IS '持股市值';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."flow_market_rate" IS '今日持股-占流通股比';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."buy_stock_number" IS '增持估计-股数';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."buy_stock_value" IS '增持估计-市值';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."buy_rate" IS '增持估计-市值增幅';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."board" IS '所属板块';
COMMENT ON COLUMN "stock"."stock_hsgt_hold_stock_em"."buy_flow_market_rate" IS '增持估计-占流通股比';
COMMENT ON TABLE "stock"."stock_hsgt_hold_stock_em" IS '北向资金持股统计';

-- ----------------------------
-- Table structure for stock_hsgt_north_net_flow_in_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_hsgt_north_net_flow_in_em";
CREATE TABLE "stock"."stock_hsgt_north_net_flow_in_em" (
  "t_date" int4,
  "in_money" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_type" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_hsgt_north_net_flow_in_em"."c_time" IS '资金流入单位: 万元';
COMMENT ON COLUMN "stock"."stock_hsgt_north_net_flow_in_em"."t_type" IS '类型';
COMMENT ON TABLE "stock"."stock_hsgt_north_net_flow_in_em" IS '北向资金流';

-- ----------------------------
-- Table structure for stock_industry_tdx
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_industry_tdx";
CREATE TABLE "stock"."stock_industry_tdx" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."stock_industry_tdx" IS '通达信行业分类';

-- ----------------------------
-- Table structure for stock_industry_tdx_daily
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_industry_tdx_daily";
CREATE TABLE "stock"."stock_industry_tdx_daily" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "open" numeric(10,2),
  "close" numeric(10,2),
  "high" numeric(10,2),
  "low" numeric(10,2),
  "volume" numeric(10,2),
  "t_date" int4,
  "up_count" int4,
  "down_count" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "ema5" numeric(18,12),
  "ema10" numeric(18,12),
  "ema20" numeric(18,12),
  "ema30" numeric(18,12),
  "dif" numeric(18,12),
  "dea" numeric(18,12),
  "macd" numeric(18,12)
)
;
COMMENT ON COLUMN "stock"."stock_industry_tdx_daily"."up_count" IS '上涨个数';
COMMENT ON COLUMN "stock"."stock_industry_tdx_daily"."down_count" IS '下跌个数';
COMMENT ON COLUMN "stock"."stock_industry_tdx_daily"."ema5" IS '5日均线';
COMMENT ON TABLE "stock"."stock_industry_tdx_daily" IS '通达信行业数据';

-- ----------------------------
-- Table structure for stock_info_a_code_name
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_info_a_code_name";
CREATE TABLE "stock"."stock_info_a_code_name" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."stock_info_a_code_name" IS '股票信息列表';

-- ----------------------------
-- Table structure for stock_info_a_code_name_del
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_info_a_code_name_del";
CREATE TABLE "stock"."stock_info_a_code_name_del" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for stock_price_live_code_list
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_price_live_code_list";
CREATE TABLE "stock"."stock_price_live_code_list" (
  "code" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON TABLE "stock"."stock_price_live_code_list" IS 'stock_price_live_tencent用到的股票列表';

-- ----------------------------
-- Table structure for stock_price_live_tencent
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_price_live_tencent";
CREATE TABLE "stock"."stock_price_live_tencent" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "new_price" numeric(18,2),
  "last_close" numeric(18,2),
  "open" numeric(18,2),
  "t_amount" numeric(32,2),
  "amount_out" numeric(18,2),
  "amount_in" numeric(18,2),
  "buy1_amount" numeric(18,2),
  "buy1_price" numeric(18,2),
  "buy2_amount" numeric(18,2),
  "buy2_price" numeric(18,2),
  "buy3_amount" numeric(18,2),
  "buy3_price" numeric(18,2),
  "buy4_amount" numeric(18,2),
  "buy4_price" numeric(18,2),
  "buy5_amount" numeric(18,2),
  "buy5_price" numeric(18,2),
  "sale1_amount" numeric(18,2),
  "sale1_price" numeric(18,2),
  "sale2_amount" numeric(18,2),
  "sale2_price" numeric(18,2),
  "sale3_amount" numeric(18,2),
  "sale3_price" numeric(18,2),
  "sale4_amount" numeric(18,2),
  "sale4_price" numeric(18,2),
  "sale5_amount" numeric(18,2),
  "sale5_price" numeric(18,2),
  "time_flag" int4,
  "change" numeric(32,2),
  "change_price" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "hands" numeric(32,2),
  "value_rate" numeric(18,2),
  "swing" numeric(32,2),
  "amount_rate" numeric(32,2),
  "weicha" numeric(32,2),
  "weibi" numeric(32,2),
  "flow_market_value" numeric(32,2),
  "market_value" numeric(32,2)
)
;
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."new_price" IS '当前价格';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."last_close" IS '昨收';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."open" IS '今开';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."amount_out" IS '外盘';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."amount_in" IS '内盘';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."buy1_amount" IS '买一量';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."buy1_price" IS '买一价';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."sale1_amount" IS '卖一量';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."sale1_price" IS '卖一价';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."time_flag" IS '时间标识';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."high" IS '最高';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."low" IS '最低';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."value_rate" IS '市盈率-动态';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."swing" IS '振幅';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."amount_rate" IS '量比';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."weicha" IS '委差';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."weibi" IS '委比';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."flow_market_value" IS '流通市值';
COMMENT ON COLUMN "stock"."stock_price_live_tencent"."market_value" IS '总市值';
COMMENT ON TABLE "stock"."stock_price_live_tencent" IS '腾迅股票数据接口，获取最新行情';

-- ----------------------------
-- Table structure for stock_rank_cxfl_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_cxfl_ths";
CREATE TABLE "stock"."stock_rank_cxfl_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "change" numeric(18,2),
  "days" int4,
  "change_sum" numeric(18,2),
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "new_price" numeric(18,2),
  "t_amount" varchar(18) COLLATE "pg_catalog"."default",
  "t_amount_base" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."days" IS '放量天数/缩量天数';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."change_sum" IS '阶段涨跌幅';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."industry" IS '所属行业';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."type" IS '持续放量/持续缩量';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_rank_cxfl_ths"."t_amount_base" IS '基准日成交量';

-- ----------------------------
-- Table structure for stock_rank_cxg_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_cxg_ths";
CREATE TABLE "stock"."stock_rank_cxg_ths" (
  "symbol" varchar(255) COLLATE "pg_catalog"."default",
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "new_price" numeric(18,2),
  "last_price" numeric(18,2),
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "last_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."symbol" IS '类型';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."last_price" IS '前期高点/前期低点';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."type" IS '创新高/创新低';
COMMENT ON COLUMN "stock"."stock_rank_cxg_ths"."last_date" IS '前期日期';

-- ----------------------------
-- Table structure for stock_rank_ljqs_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_ljqs_ths";
CREATE TABLE "stock"."stock_rank_ljqs_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "new_price" numeric(18,2),
  "days" int4,
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."days" IS '量价齐升天数';
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."change" IS '阶段涨幅';
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."hands" IS '累计换手率';
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."industry" IS '所属行业';
COMMENT ON COLUMN "stock"."stock_rank_ljqs_ths"."type" IS '量价齐升/量价齐跌';

-- ----------------------------
-- Table structure for stock_rank_lxsz_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_lxsz_ths";
CREATE TABLE "stock"."stock_rank_lxsz_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "close" numeric(18,2),
  "high" numeric(18,2),
  "low" numeric(18,2),
  "days" int4,
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."close" IS '收盘价';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."high" IS '最高价';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."low" IS '最低价';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."days" IS '连续上涨天数';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."change" IS '连续上涨幅度';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."hands" IS '累计换手率';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."industry" IS '所属行业';
COMMENT ON COLUMN "stock"."stock_rank_lxsz_ths"."type" IS '连续上涨/连续下跌';

-- ----------------------------
-- Table structure for stock_rank_xstp_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_xstp_ths";
CREATE TABLE "stock"."stock_rank_xstp_ths" (
  "symbol" varchar(255) COLLATE "pg_catalog"."default",
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "change" numeric(18,2),
  "hands" numeric(18,2),
  "new_price" numeric(18,2),
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "t_amount" varchar(32) COLLATE "pg_catalog"."default",
  "t_volume" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."symbol" IS '类型';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."type" IS '创新高/创新低';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."t_amount" IS '成交额';
COMMENT ON COLUMN "stock"."stock_rank_xstp_ths"."t_volume" IS '成交量';

-- ----------------------------
-- Table structure for stock_rank_xzjp_ths
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_rank_xzjp_ths";
CREATE TABLE "stock"."stock_rank_xzjp_ths" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "now_price" numeric(18,2),
  "change" numeric(18,2),
  "hold" varchar(255) COLLATE "pg_catalog"."default",
  "add_volume" varchar(255) COLLATE "pg_catalog"."default",
  "t_price" numeric(18,2),
  "add_rate" numeric(18,2),
  "sum_volumn" varchar(255) COLLATE "pg_catalog"."default",
  "sum_rete" numeric(18,2),
  "notice_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."code" IS '股票代码';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."name" IS '股票简称';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."now_price" IS '现价';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."hold" IS '举牌方';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."add_volume" IS '增持数量';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."t_price" IS '交易均价';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."add_rate" IS '增持数量占总股本比例';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."sum_volumn" IS '变动后持股总数';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."sum_rete" IS '变动后持股比例';
COMMENT ON COLUMN "stock"."stock_rank_xzjp_ths"."notice_date" IS '公告日';

-- ----------------------------
-- Table structure for stock_report_fund_hold
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_report_fund_hold";
CREATE TABLE "stock"."stock_report_fund_hold" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "fund_count" int4,
  "hold_amount" int8,
  "hold_vlues" numeric(18,2),
  "change" varchar(255) COLLATE "pg_catalog"."default",
  "hold_change" int8,
  "hold_change_rate" numeric(18,2) NOT NULL DEFAULT 100,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_type" varchar(255) COLLATE "pg_catalog"."default",
  "notice_date" int4
)
;
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."name" IS '股票简称';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."fund_count" IS '持有基金家数';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."hold_amount" IS '持股总数';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."hold_vlues" IS '持股市值';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."change" IS '持股变化';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."hold_change" IS '持股变
动数值';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."hold_change_rate" IS '持股变动比例';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."t_type" IS '机构类型';
COMMENT ON COLUMN "stock"."stock_report_fund_hold"."notice_date" IS '发布日期';
COMMENT ON TABLE "stock"."stock_report_fund_hold" IS '基金持仓报告';

-- ----------------------------
-- Table structure for stock_select_shapes
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes";
CREATE TABLE "stock"."stock_select_shapes" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "flag" int2,
  "shapes" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_select_shapes"."flag" IS '标识';
COMMENT ON COLUMN "stock"."stock_select_shapes"."shapes" IS '组合形态';
COMMENT ON TABLE "stock"."stock_select_shapes" IS '日线形态';

-- ----------------------------
-- Table structure for stock_select_shapes120
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes120";
CREATE TABLE "stock"."stock_select_shapes120" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4 NOT NULL,
  "flag" int2,
  "shapes" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_time" timestamp(6) NOT NULL,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for stock_select_shapes_group
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_group";
CREATE TABLE "stock"."stock_select_shapes_group" (
  "code" int4 NOT NULL,
  "shapes" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "gid" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
)
)
;
COMMENT ON COLUMN "stock"."stock_select_shapes_group"."code" IS '分组代码2,3';
COMMENT ON COLUMN "stock"."stock_select_shapes_group"."shapes" IS '形态组合';
COMMENT ON COLUMN "stock"."stock_select_shapes_group"."gid" IS 'ID';
COMMENT ON TABLE "stock"."stock_select_shapes_group" IS '形态组合';

-- ----------------------------
-- Table structure for stock_select_shapes_index
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_index";
CREATE TABLE "stock"."stock_select_shapes_index" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "flag" int2,
  "shapes" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for stock_select_shapes_stat
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_stat";
CREATE TABLE "stock"."stock_select_shapes_stat" (
  "shapes" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "up_times" int4 NOT NULL DEFAULT 0,
  "down_times" int4 NOT NULL DEFAULT 0,
  "up_rate" numeric(18,2) NOT NULL DEFAULT 0,
  "up_change" numeric(18,2) NOT NULL DEFAULT 0,
  "days" int4 NOT NULL,
  "time_flag" int4 NOT NULL
)
;
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."shapes" IS '形态组合';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."up_times" IS '上涨次数';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."down_times" IS '下跌次数';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."up_rate" IS '上涨概率';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."up_change" IS '平均上涨幅度';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."days" IS '天数';
COMMENT ON COLUMN "stock"."stock_select_shapes_stat"."time_flag" IS '时间标识';

-- ----------------------------
-- Table structure for stock_select_shapes_stat_bak
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_stat_bak";
CREATE TABLE "stock"."stock_select_shapes_stat_bak" (
  "shapes" varchar(50) COLLATE "pg_catalog"."default",
  "up_times" int4,
  "down_times" int4,
  "up_rate" numeric(18,2),
  "up_change" numeric(18,2),
  "days" int4,
  "time_flag" int4
)
;

-- ----------------------------
-- Table structure for stock_select_shapes_stock
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_stock";
CREATE TABLE "stock"."stock_select_shapes_stock" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "gid" int4,
  "shapes" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_select_shapes_stock"."gid" IS '组合形态分组ID';
COMMENT ON COLUMN "stock"."stock_select_shapes_stock"."shapes" IS '组合形态';

-- ----------------------------
-- Table structure for stock_select_shapes_stock120
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_select_shapes_stock120";
CREATE TABLE "stock"."stock_select_shapes_stock120" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4 NOT NULL,
  "t_time" timestamp(6) NOT NULL,
  "gid" int4,
  "shapes" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for stock_selected_list
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_selected_list";
CREATE TABLE "stock"."stock_selected_list" (
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default",
  "t_date" int4,
  "policy" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "stock"."stock_selected_list"."policy" IS '策略';
COMMENT ON TABLE "stock"."stock_selected_list" IS '选股列表';

-- ----------------------------
-- Table structure for stock_selected_list_email
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_selected_list_email";
CREATE TABLE "stock"."stock_selected_list_email" (
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default",
  "t_date" int4
)
;
COMMENT ON TABLE "stock"."stock_selected_list_email" IS '邮件通知发送的数据';

-- ----------------------------
-- Table structure for stock_stat_tdx_index
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_stat_tdx_index";
CREATE TABLE "stock"."stock_stat_tdx_index" (
  "t_date" int4,
  "code" varchar COLLATE "pg_catalog"."default",
  "name" varchar COLLATE "pg_catalog"."default",
  "open" numeric(18,2),
  "high" numeric(18,2),
  "low" numeric(18,2),
  "close" numeric(18,2),
  "turnover" numeric(18,2),
  "channel_short_up" numeric(18,2),
  "channel_short_down" numeric(18,2),
  "channel_long_up" numeric(18,2),
  "channel_long_down" numeric(18,2),
  "r9_low_9" int4,
  "r9_high_9" int4,
  "jlhb_b" numeric(18,2),
  "jlhb_var2" numeric(18,2),
  "jlhb" int4,
  "zljk_guiji" numeric(18,2),
  "zljk_mazl" numeric(18,2),
  "zljk_jinchang" numeric(18,2),
  "zljk_xipan" numeric(18,2),
  "zljk_lagao" numeric(18,2),
  "zljk_chuhuo" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "cycx1" numeric(18,2),
  "cycx2" numeric(18,2),
  "cycx3" numeric(18,2),
  "cycx4" numeric(18,2),
  "change" numeric(18,2)
)
;
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."turnover" IS '成交量';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."channel_short_up" IS '短趋势通道上';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."channel_short_down" IS '短趋势通道下';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."channel_long_up" IS '长趋势通道上';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."channel_long_down" IS '长趋势通道下';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."r9_low_9" IS '九转低9';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."r9_high_9" IS '九转高9';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."jlhb_b" IS '绝路航标B';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."jlhb_var2" IS '绝路航标VAR2';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."jlhb" IS '绝路航标';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_guiji" IS '主力监控-轨迹';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_mazl" IS '主力监控-MAZL';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_jinchang" IS '主力监控-进场';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_xipan" IS '主力监控-洗盘';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_lagao" IS '主力监控-拉高';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."zljk_chuhuo" IS '主力监控-出货';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."cycx1" IS '成本均线1';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."cycx2" IS '成本均线2';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."cycx3" IS '成本均线3';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."cycx4" IS '成本均线4';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index"."change" IS '涨跌幅';
COMMENT ON TABLE "stock"."stock_stat_tdx_index" IS '通达信指标';

-- ----------------------------
-- Table structure for stock_stat_tdx_index_any
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_stat_tdx_index_any";
CREATE TABLE "stock"."stock_stat_tdx_index_any" (
  "code" varchar COLLATE "pg_catalog"."default",
  "t_date" int4,
  "jlhb_r9" int4,
  "jlhb_jg" int4
)
;
COMMENT ON COLUMN "stock"."stock_stat_tdx_index_any"."jlhb_r9" IS '绝路航标加九转';
COMMENT ON COLUMN "stock"."stock_stat_tdx_index_any"."jlhb_jg" IS '绝路航标加结构';
COMMENT ON TABLE "stock"."stock_stat_tdx_index_any" IS '通达信指标分析';

-- ----------------------------
-- Table structure for stock_stat_var
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_stat_var";
CREATE TABLE "stock"."stock_stat_var" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "var_amount10" numeric(18,2),
  "var_amount20" numeric(18,2),
  "var_amount30" numeric(18,2),
  "var_amount60" numeric(18,2),
  "var_amount90" numeric(18,2),
  "var_amount120" numeric(18,2),
  "var_amount150" numeric(18,2),
  "var_change10" numeric(18,2),
  "var_change20" numeric(18,2),
  "var_change30" numeric(18,2),
  "var_change60" numeric(18,2),
  "var_change90" numeric(18,2),
  "var_change120" numeric(18,2),
  "var_change150" numeric(18,2),
  "var_close10" numeric(18,2),
  "var_close20" numeric(18,2),
  "var_close30" numeric(18,2),
  "var_close60" numeric(18,2),
  "var_close90" numeric(18,2),
  "var_close120" numeric(18,2),
  "var_close150" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "var_atr10" numeric(18,2),
  "var_atr20" numeric(18,2),
  "var_atr30" numeric(18,2),
  "var_atr60" numeric(18,2),
  "var_atr90" numeric(18,2),
  "var_atr120" numeric(18,2),
  "var_atr150" numeric(18,2)
)
;

-- ----------------------------
-- Table structure for stock_var_pop
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_var_pop";
CREATE TABLE "stock"."stock_var_pop" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "change" numeric(10,2),
  "day30" numeric(10,2),
  "day60" numeric(10,2),
  "day90" numeric(10,2),
  "day120" numeric(10,2),
  "day150" numeric(10,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "day30change" numeric(10,2),
  "day60change" numeric(10,2),
  "day90change" numeric(10,2),
  "day120change" numeric(10,2),
  "day150change" numeric(10,2)
)
;
COMMENT ON COLUMN "stock"."stock_var_pop"."change" IS '当日涨幅';
COMMENT ON TABLE "stock"."stock_var_pop" IS '时间段价格方差';

-- ----------------------------
-- Table structure for stock_var_pop_volume
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_var_pop_volume";
CREATE TABLE "stock"."stock_var_pop_volume" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "volume" numeric(18,2),
  "day30" numeric(18,2),
  "day60" numeric(18,2),
  "day90" numeric(18,2),
  "day120" numeric(18,2),
  "day150" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "day30change" numeric(10,2),
  "day60change" numeric(10,2),
  "day90change" numeric(10,2),
  "day120change" numeric(10,2),
  "day150change" numeric(10,2)
)
;
COMMENT ON TABLE "stock"."stock_var_pop_volume" IS '时间段成交量方差';

-- ----------------------------
-- Table structure for stock_yjbb_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_yjbb_em";
CREATE TABLE "stock"."stock_yjbb_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "income" numeric(18,2),
  "taking" numeric(18,2),
  "taking_year_rate" numeric(18,2),
  "taking_quarter_rate" numeric(18,2),
  "profit" numeric(18,2),
  "profit_year_rate" numeric(18,2),
  "profit_quarter_rate" numeric(18,2),
  "netvalue_per" numeric(18,2),
  "roe" numeric(18,2),
  "cash_per" numeric(18,2),
  "gross" numeric(18,2),
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "notice_date" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_yjbb_em"."income" IS '每股收益';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."taking" IS '营业收入-营业收入';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."taking_year_rate" IS '营业收入-同比增长';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."taking_quarter_rate" IS '营业收入-季度环比增长';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."profit" IS '净利润-净利润';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."profit_year_rate" IS '净利润-同比增长';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."profit_quarter_rate" IS '净利润-季度环比增长';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."netvalue_per" IS '每股净资产';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."roe" IS '净资产收益率';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."cash_per" IS '每股经营现金流量';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."gross" IS '销售毛利率';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."industry" IS '所处行业';
COMMENT ON COLUMN "stock"."stock_yjbb_em"."notice_date" IS '最新公告日期';
COMMENT ON TABLE "stock"."stock_yjbb_em" IS '业绩报表';

-- ----------------------------
-- Table structure for stock_zh_a_gdhs
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_gdhs";
CREATE TABLE "stock"."stock_zh_a_gdhs" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "end_date" date,
  "change" numeric(18,2),
  "holder_count" int4,
  "holder_count_last" int4,
  "holder_count_net" int4,
  "holder_count_net_rate" numeric(18,2),
  "market_value" numeric(18,2),
  "notice_date" date,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."code" IS '代码';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."name" IS '名称';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."end_date" IS '股东户数统计截止日';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."change" IS '区间涨跌幅';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."holder_count" IS '股东户数-本次';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."holder_count_last" IS '股东户数-上次';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."holder_count_net" IS '股东户数-增减';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."holder_count_net_rate" IS '股东户数-增减比例';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."market_value" IS '总市值';
COMMENT ON COLUMN "stock"."stock_zh_a_gdhs"."notice_date" IS '公告日期';
COMMENT ON TABLE "stock"."stock_zh_a_gdhs" IS '股东户数';

-- ----------------------------
-- Table structure for stock_zh_a_hist
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_hist";
CREATE TABLE "stock"."stock_zh_a_hist" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(32,2),
  "close" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "t_amount" int8,
  "t_monry" numeric(32,2),
  "swing" numeric(32,2),
  "change" numeric(32,2),
  "change_price" numeric(32,2),
  "hands" numeric(32,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "ema5" numeric(18,12),
  "ema10" numeric(18,12),
  "ema20" numeric(18,12),
  "ema30" numeric(18,12),
  "dif" numeric(18,12),
  "dea" numeric(18,12),
  "macd" numeric(18,12),
  "last4" numeric(18,2),
  "r_flag" int2,
  "r9" int2,
  "flat" int2
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."open" IS '开盘';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."close" IS '收盘';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."high" IS '最高';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."low" IS '最低';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."t_monry" IS '成交额';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."swing" IS '振幅';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."ema5" IS '5日均线';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."last4" IS '4日前的收盘价';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."r_flag" IS '当日收盘价比4日前收盘价比较';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."r9" IS '九转';
COMMENT ON COLUMN "stock"."stock_zh_a_hist"."flat" IS '结构形成';
COMMENT ON TABLE "stock"."stock_zh_a_hist" IS '股票日线行情数据';

-- ----------------------------
-- Table structure for stock_zh_a_hist_min_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_hist_min_em";
CREATE TABLE "stock"."stock_zh_a_hist_min_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "t_time" timestamp(6) NOT NULL,
  "open" numeric(32,2),
  "close" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "t_amount" int8,
  "t_monry" numeric(32,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "new_price" numeric(32,2),
  "period" int8 NOT NULL,
  "last4" numeric(32,2),
  "r_flag" int8,
  "r9" int8,
  "swing" numeric(32,2),
  "hands" numeric(32,2),
  "flat" int2
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_hist_min_em"."period" IS '分钟标识，120表示120分钟';
COMMENT ON COLUMN "stock"."stock_zh_a_hist_min_em"."swing" IS '振幅';
COMMENT ON COLUMN "stock"."stock_zh_a_hist_min_em"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_zh_a_hist_min_em"."flat" IS '结构形成';
COMMENT ON TABLE "stock"."stock_zh_a_hist_min_em" IS '单次返回指定股票、频率、复权调整和时间区间的分时数据, 其中 1 分钟数据只返回近 5 个交易日数据且不复权';

-- ----------------------------
-- Table structure for stock_zh_a_price_rate
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_price_rate";
CREATE TABLE "stock"."stock_zh_a_price_rate" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4,
  "price" numeric(18,2),
  "t_amount" int8,
  "rate" numeric(18,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_price_rate"."t_date" IS '交易日期';
COMMENT ON COLUMN "stock"."stock_zh_a_price_rate"."price" IS '成交价(元)';
COMMENT ON COLUMN "stock"."stock_zh_a_price_rate"."t_amount" IS '成交量(股)';
COMMENT ON COLUMN "stock"."stock_zh_a_price_rate"."rate" IS '成交价格占比';

-- ----------------------------
-- Table structure for stock_zh_a_spot_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_spot_em";
CREATE TABLE "stock"."stock_zh_a_spot_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "t_date" int4 NOT NULL,
  "open" numeric(32,2),
  "high" numeric(32,2),
  "low" numeric(32,2),
  "t_amount" numeric(32,2),
  "t_monry" numeric(32,2),
  "swing" numeric(32,2),
  "change" numeric(32,2),
  "change_price" numeric(32,2),
  "hands" numeric(32,2),
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "new_price" numeric(18,2),
  "last_close" numeric(18,2),
  "amount_rate" numeric(18,2),
  "time_flag" int4,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "rise_speed" numeric(18,2),
  "change_5m" numeric(18,2),
  "flow_value" numeric(32,2),
  "change_60d" numeric(18,2),
  "value_rate" numeric(18,2)
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."open" IS '开盘';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."high" IS '最高';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."low" IS '最低';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."t_monry" IS '成交额';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."swing" IS '振幅';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."new_price" IS '最新价';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."last_close" IS '昨收';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."amount_rate" IS '量比';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."time_flag" IS '时间标识';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."rise_speed" IS '涨速';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."change_5m" IS '5分钟涨跌';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."flow_value" IS '流通市值';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."change_60d" IS '60日涨幅';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_em"."value_rate" IS '市盈率-动态';
COMMENT ON TABLE "stock"."stock_zh_a_spot_em" IS '东财所有沪深京 A 股上市公司的实时行情数据';

-- ----------------------------
-- Table structure for stock_zh_a_spot_tx
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_spot_tx";
CREATE TABLE "stock"."stock_zh_a_spot_tx" (
  "code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "name" varchar COLLATE "pg_catalog"."default",
  "new_price" numeric(18,2),
  "last_close" numeric(18,2),
  "open" numeric(32,2),
  "t_amount" numeric(32,2),
  "out_amount" numeric(32,2),
  "in_amount" numeric(32,2),
  "buy1" numeric(32,2),
  "buy2" numeric(32,2),
  "buy3" numeric(32,2),
  "buy4" numeric(32,2),
  "buy5" numeric(32,2),
  "sale1" numeric(32,2),
  "sale2" numeric(32,2),
  "sale3" numeric(32,2),
  "sale4" numeric(32,2),
  "sale5" numeric(32,2),
  "buy1_price" numeric(32,2),
  "sale1_price" numeric(32,2),
  "t_time" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "change" numeric(32,2),
  "change_price" numeric(32,2),
  "t_date" int4,
  "time_flag" int4
)
;
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."new_price" IS '当前价格';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."last_close" IS '昨收';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."open" IS '今开';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."t_amount" IS '成交量';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."out_amount" IS '外盘';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."in_amount" IS '内盘';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy1" IS '买1';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy2" IS '买2';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy3" IS '买3';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy4" IS '买4';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy5" IS '买5';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale1" IS '卖1';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale2" IS '卖2';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale3" IS '卖3';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale4" IS '卖4';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale5" IS '卖5';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."buy1_price" IS '买1价格';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."sale1_price" IS '卖1价格';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."t_time" IS '时间';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."change" IS '涨跌幅';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."change_price" IS '涨跌额';
COMMENT ON COLUMN "stock"."stock_zh_a_spot_tx"."time_flag" IS '时间标识';
COMMENT ON TABLE "stock"."stock_zh_a_spot_tx" IS '腾迅股票数据接口';

-- ----------------------------
-- Table structure for stock_zh_a_tick_tx
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zh_a_tick_tx";
CREATE TABLE "stock"."stock_zh_a_tick_tx" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "t_time" timestamp(6),
  "t_price" numeric(18,2),
  "change" numeric(18,2),
  "t_amount" numeric(18,2),
  "t_money" numeric(18,2),
  "t_type" varchar(255) COLLATE "pg_catalog"."default",
  "t_date" int4
)
;

-- ----------------------------
-- Table structure for stock_zt_pool_em
-- ----------------------------
DROP TABLE IF EXISTS "stock"."stock_zt_pool_em";
CREATE TABLE "stock"."stock_zt_pool_em" (
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "change" numeric(18,2),
  "new_price" numeric(18,2),
  "t_money" numeric(18,2),
  "market_val_ch" numeric(18,2),
  "market_val_sum" numeric(18,2),
  "hands" numeric(18,2),
  "close_money" numeric(18,2),
  "first_close_time" timestamp(6),
  "end_close_time" timestamp(6),
  "open_times" int4,
  "change_static" varchar(255) COLLATE "pg_catalog"."default",
  "series_days" int4,
  "industry" varchar(255) COLLATE "pg_catalog"."default",
  "c_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "t_date" int4
)
;
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."t_money" IS '成交额';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."market_val_ch" IS '流动市值';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."market_val_sum" IS '总市值';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."hands" IS '换手率';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."close_money" IS '封板资金';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."first_close_time" IS '首次封板时间';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."end_close_time" IS '最后封板时间';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."open_times" IS '炸板次数';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."change_static" IS '涨停统计';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."series_days" IS '连板数';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."industry" IS '所属行业';
COMMENT ON COLUMN "stock"."stock_zt_pool_em"."t_date" IS '交易日';
COMMENT ON TABLE "stock"."stock_zt_pool_em" IS '涨停池';

-- ----------------------------
-- Table structure for tool_trade_date_hist_sina
-- ----------------------------
DROP TABLE IF EXISTS "stock"."tool_trade_date_hist_sina";
CREATE TABLE "stock"."tool_trade_date_hist_sina" (
  "tid" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "t_date" int4,
  "is_used" bool NOT NULL DEFAULT true,
  "t_date_last" int4,
  "t_date1" int4
)
;
COMMENT ON COLUMN "stock"."tool_trade_date_hist_sina"."t_date_last" IS 'T-1';
COMMENT ON COLUMN "stock"."tool_trade_date_hist_sina"."t_date1" IS 'T+1';
COMMENT ON TABLE "stock"."tool_trade_date_hist_sina" IS '新浪财经的股票交易日历数据';

-- ----------------------------
-- Function structure for get_shape_stock_list
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."get_shape_stock_list"("_t_date" int4);
CREATE OR REPLACE FUNCTION "stock"."get_shape_stock_list"("_t_date" int4)
  RETURNS TABLE("code" varchar, "name" varchar, "t_date" int4, "shapes" varchar, "period" int4, "up_times" int4, "up_rate" numeric, "up_change" numeric, "up_days" int4) AS $BODY$
#variable_conflict use_column
begin
	RETURN QUERY
select
	distinct
	code,
	name,
	t_date,
	a.shapes,
	time_flag as period,
	up_times,
	up_rate,
	up_change,
	days as up_days
from
	stock_select_shapes_stock a
join stock_select_shapes_stat b on
	a.shapes = b.shapes
where
	t_date = _t_date
	and up_times >=20    -- 次数
	and up_rate > 0.70
	and days >= 1
	and days <= 30
	and time_flag = 1
	and code not like '688%';
--	union all
--
--select
--	distinct
--	code,
--	name,
--	t_date,
--	a.shapes,
--	time_flag as period,
--	up_times,
--	up_rate,
--	up_change,
--	days as up_days
--from
--	stock_select_shapes_stock120 a
--join stock_select_shapes_stat b on
--	a.shapes = b.shapes
--where
--	t_date = _t_date
--	and up_times >=10    -- 次数
--	and up_rate > 0.8
--	and days >= 1
--	and days <= 30
--	and time_flag = 120
--	and "name" not like '%ST%'
--	and code not like '688%';
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

-- ----------------------------
-- Function structure for get_stock_list
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."get_stock_list"("_t_date" int4);
CREATE OR REPLACE FUNCTION "stock"."get_stock_list"("_t_date" int4)
  RETURNS TABLE("stock_code" varchar, "stock_name" varchar) AS $BODY$
DECLARE 
    var_r record;
begin
 -- 选股策略
 FOR var_r IN(SELECT  a.code,b."name" 
            FROM stock_price_live_tencent a join stock.stock_info_a_code_name b on a.code = b.code
            where flow_market_value > 20 and  flow_market_value < 200  -- 市值大于20亿 小于 200亿								     
            and "change" >=3 and "change" <6						   -- 开盘涨幅
            and amount_rate > 3									       -- 量比
            and weibi > 0
            and t_date = _t_date and time_flag = 930)  
 LOOP
    stock_code := var_r.code; 
    stock_name := var_r.name;
    
    RETURN NEXT;
 END LOOP;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

-- ----------------------------
-- Function structure for ins_fund_etf_list
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_fund_etf_list"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_fund_etf_list"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.fund_etf_list(code,name,type)
select x.基金代码,x.基金简称,x.类型 from json_to_recordset($1) x 
(
	基金代码 varchar,
	基金简称 varchar,
	类型 varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_fund_etf_spot_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_fund_etf_spot_em"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_fund_etf_spot_em"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.fund_etf_spot_em(code,name,t_date,open,close,high,low,t_amount,t_monry,change,change_price,last_price,hands,market_val)
select x.代码,x.名称,cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int),x.开盘价,x.最新价,x.最高价,x.最低价,x.成交量,x.成交额,x.涨跌幅,x.涨跌额,x.昨收,x.换手率,x.流通市值
 from json_to_recordset(_data_json) x 
(
代码 varchar,
名称 varchar,
开盘价 numeric(32,2),
最新价 numeric(32,2),
最高价 numeric(32,2),
最低价 numeric(32,2),
成交量 numeric(32,2),
成交额 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
昨收 numeric(32,2),
换手率 numeric(32,2),
流通市值 numeric(32,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_fund_etf_spot_em_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_fund_etf_spot_em_his"("_code" varchar, "_name" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_fund_etf_spot_em_his"("_code" varchar, "_name" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.fund_etf_spot_em(code,name,t_date,open,close
,high,low,t_amount,t_monry,change
,change_price,hands)
select _code,_name,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘
,x.最高,x.最低,x.成交量,x.成交额,x.涨跌幅
,x.涨跌额,x.换手率
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘 numeric(32,2),
收盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
成交量 int8,
成交额 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
换手率 numeric(32,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_fund_name_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_fund_name_em"("_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_fund_name_em"("_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.fund_name_em(code,name,type)
select x.基金代码,x.基金简称,x.基金类型  from json_to_recordset(_json) x 
(
	基金代码 varchar,
	基金简称 varchar,
	基金类型 varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_fund_portfolio_hold_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_fund_portfolio_hold_em"("_fundcode" text, "_year" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_fund_portfolio_hold_em"("_fundcode" text, "_year" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.fund_portfolio_hold_em(fund_code,stock_code,stock_name,netvalue_rate,hold_count,hold_values,year,quarter)
select _fundcode,x.股票代码,x.股票名称,x.占净值比例,x.持股数,x.持仓市值,_year,cast(substring(x.季度,6,1) as int)  from json_to_recordset(_json) x 
(
	股票代码 varchar,
	股票名称 varchar,
	占净值比例 numeric(18,2),
	持股数 numeric(18,2),
	持仓市值 numeric(18,2),
	季度 varchar
)
ON CONFLICT(fund_code, stock_code, year, quarter)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_all_cni
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_all_cni"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_all_cni"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.index_all_cni(code,name)
select x.index_code,x.display_name from json_to_recordset($1) x 
(
	index_code varchar,
	display_name varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_detail_cni
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_detail_cni"("_code" varchar, "_name" varchar, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_detail_cni"("_code" varchar, "_name" varchar, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.index_detail_cni(index_code,index_name,code,name,new_date)
select _code,_name,x.品种代码,x.品种名称,x.纳入日期 from json_to_recordset(_json) x 
(
	品种代码 varchar,
	品种名称 varchar,
	纳入日期 varchar
)
ON CONFLICT(index_code,code,new_date)
DO NOTHING;

--insert into stock.index_detail_cni(index_code,index_name,code,name,new_date,board,market_value,rate)
--select _code,_name,x.样本代码,x.样本简称,x.日期,x.所属行业,x.自由流通市值,x.权重 from json_to_recordset(_json) x 
--(
--	样本代码 varchar,
--	样本简称 varchar,
--	日期 varchar,
--	所属行业 varchar,
--	自由流通市值 numeric(18,2),
--	权重 numeric(18,2)
--)
--ON CONFLICT(index_code,code,new_date)
--DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_value_hist_funddb
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_value_hist_funddb"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_value_hist_funddb"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

	if _type = '市盈率' then
		INSERT INTO stock.index_value_hist_funddb
		(code, "name", new_pe,t_date)
		select _code,_name,x.市盈率,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		市盈率 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do 
		UPDATE SET new_pe = EXCLUDED.new_pe;
	elsif _type = '市净率' then
		INSERT INTO stock.index_value_hist_funddb
		(code, "name", new_pb,t_date)
		select _code,_name,x.市净率,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		市净率 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do 
		UPDATE SET new_pb = EXCLUDED.new_pb;
	elsif _type = '股息率' then
		INSERT INTO stock.index_value_hist_funddb
		(code, "name", dividend,t_date)
		select _code,_name,x.股息率,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		股息率 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do 
		UPDATE SET dividend = EXCLUDED.dividend;
	elsif _type = '风险溢价' then
		INSERT INTO stock.index_value_hist_funddb
		(code, "name", risk,t_date)
		select _code,_name,x.风险溢价,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		风险溢价 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do 
		UPDATE SET risk = EXCLUDED.risk;
	END IF;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_value_hist_funddb_fxyj
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_value_hist_funddb_fxyj"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_value_hist_funddb_fxyj"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

		INSERT INTO stock.index_value_hist_funddb_fxyj
		(code, "name", risk,t_date)
		select _code,_name,x.风险溢价,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		风险溢价 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do nothing;
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_value_hist_funddb_gxl
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_value_hist_funddb_gxl"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_value_hist_funddb_gxl"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

		INSERT INTO stock.index_value_hist_funddb_gxl
		(code, "name", dividend,t_date)
		select _code,_name,x.股息率,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		股息率 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do 
		UPDATE SET dividend = EXCLUDED.dividend;
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_value_hist_funddb_sjl
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_value_hist_funddb_sjl"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_value_hist_funddb_sjl"("_code" varchar, "_name" varchar, "_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

		INSERT INTO stock.index_value_hist_funddb_sjl
		(code, "name", new_pb,t_date)
		select _code,_name,x.市净率,cast(replace(substr(x.日期,1,10),'-','') as int)
		 from json_to_recordset(_data_json) x 
		(
		日期 varchar,
		市净率 numeric(18,2)
		)
		ON CONFLICT(code,t_date)
		do UPDATE SET new_pb = EXCLUDED.new_pb;
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_index_value_name_funddb
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_index_value_name_funddb"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_index_value_name_funddb"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

INSERT INTO stock.index_value_name_funddb
(code, "name", new_pe, rate_pe, new_pb, rate_pb, dividend, rate_dividend, start_date, t_date)
select x.指数代码,x.指数名称,x."最新PE",x."PE分位",x."最新PB",x."PB分位",x.股息率,x.股息率分位,x.指数开始时间,cast(replace(substr(x.更新时间,1,10),'-','') as int)
 from json_to_recordset(_data_json) x 
(
指数代码 VARCHAR,
指数名称 VARCHAR,
"最新PE" numeric(18,2),
"PE分位" numeric(18,2),
"最新PB" numeric(18,2),
"PB分位" numeric(18,2),
股息率 numeric(18,2),
股息率分位 numeric(18,2),
指数开始时间 VARCHAR,
更新时间 VARCHAR
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_a_lg_indicator
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_a_lg_indicator"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_a_lg_indicator"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_a_lg_indicator(code,t_date,pe,pe_ttm,pb,ps,ps_ttm,dv_ratio,dv_ttm,total_mv,pe_ttm_fw)
select _symbol,cast(to_char(x.trade_date, 'YYYYMMDD') as int),x.pe,x.pe_ttm,x.pb,x.ps,x.ps_ttm,x.dv_ratio,x.dv_ttm,x.total_mv,x.pe_ttm_fw
 from json_to_recordset(_data_json) x 
(
trade_date timestamp,
pe numeric(18,2),
pe_ttm numeric(18,2),
pb numeric(18,2),
ps numeric(18,2),
ps_ttm numeric(18,2),
dv_ratio numeric(18,2),
dv_ttm numeric(18,2),
total_mv numeric(18,2),
pe_ttm_fw int
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_hist_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_hist_em"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_hist_em"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_hist_em(code,t_date,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands)
select _symbol,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘 numeric(18,2),
收盘 numeric(18,2),
最高 numeric(18,2),
最低 numeric(18,2),
成交量 numeric(18,2),
成交额 numeric(18,2),
振幅 numeric(18,2),
涨跌幅 numeric(18,2),
涨跌额 numeric(18,2),
换手率 numeric(18,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_hist_min_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_hist_min_em"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_hist_min_em"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_hist_min_em(code,t_date,t_time,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands)
select _symbol,cast(to_char(x.日期时间, 'YYYYMMDD') as int),x.日期时间,x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率
 from json_to_recordset(_data_json) x 
(
日期时间 timestamp,
开盘 numeric(18,2),
收盘 numeric(18,2),
最高 numeric(18,2),
最低 numeric(18,2),
成交量 numeric(18,2),
成交额 numeric(18,2),
振幅 numeric(18,2),
涨跌幅 numeric(18,2),
涨跌额 numeric(18,2),
换手率 numeric(18,2)
)
ON CONFLICT(code,t_date,t_time)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_hist_min_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_hist_min_em"("_symbol" varchar, "_period" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_hist_min_em"("_symbol" varchar, "_period" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_hist_min_em(code,t_date,t_time,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands,"period")
select _symbol,cast(to_char(x.日期时间, 'YYYYMMDD') as int),x.日期时间,x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率,_period
 from json_to_recordset(_data_json) x 
(
日期时间 timestamp,
开盘 numeric(18,2),
收盘 numeric(18,2),
最高 numeric(18,2),
最低 numeric(18,2),
成交量 numeric(18,2),
成交额 numeric(18,2),
振幅 numeric(18,2),
涨跌幅 numeric(18,2),
涨跌额 numeric(18,2),
换手率 numeric(18,2)
)
ON CONFLICT(code,t_date,t_time,"period")
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_index_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_index_ths"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_index_ths"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_hist(code,t_date,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands,ema5,ema10,ema20,ema30,dif,dea,macd)
select _symbol,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率,x.ema5,x.ema10,x.ema20,x.ema30,x.dif,x.dea,x.macd * 2 as macd
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘 numeric(32,2),
收盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
成交量 int8,
成交额 numeric(32,2),
振幅 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
换手率 numeric(32,2),
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_index_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_index_ths"("_symbol" varchar, "_time_flag" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_index_ths"("_symbol" varchar, "_time_flag" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_index_ths(code,t_date,open,close,high,low,t_amount,t_monry,time_flag)
select _symbol,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘价,x.收盘价,x.最高价,x.最低价,x.成交量,x.成交额,_time_flag
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘价 numeric(32,2),
收盘价 numeric(32,2),
最高价 numeric(32,2),
最低价 numeric(32,2),
成交量 int8,
成交额 numeric(32,2)
)
ON CONFLICT(code,t_date,time_flag)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_name_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_name_em"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_name_em"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_name_em(code,name)
select x.板块代码,x.板块名称	 from json_to_recordset($1) x 
(
	板块代码 varchar,
	板块名称	 varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_name_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_name_ths"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_name_ths"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_name_ths(code,name)
select x.code,x.name from json_to_recordset($1) x 
(
	code varchar,
	name varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_board_industry_summary_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_board_industry_summary_ths"("_t_date" int4, "_time_flag" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_board_industry_summary_ths"("_t_date" int4, "_time_flag" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_industry_summary_ths(code,t_date,change,t_amount,t_monry,net_flow_in
,up_count,down_count,head_stock,head_stock_change,time_flag)
select x.板块,_t_date,x.涨跌幅,x.总成交量,x.总成交额,x.净流入,x.上涨家数,x.下跌家数,x.领涨股,x."领涨股-涨跌幅",_time_flag
 from json_to_recordset(_data_json) x 
(
板块 varchar,
涨跌幅 numeric(32,2),
总成交量 numeric(32,2),
总成交额 numeric(32,2),
净流入 numeric(32,2),
上涨家数 int8,
下跌家数 int8,
领涨股 varchar,
"领涨股-涨跌幅" numeric(32,2)
)
ON CONFLICT(code,t_date,time_flag)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_changes_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_changes_em"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_changes_em"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_changes_em(code,t_date,t_time,name,industry,info,t_type)
select x.代码,cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int),cast(CURRENT_DATE || ' ' || x.时间 as TIMESTAMP),x.名称,x.板块,x.相关信息,_symbol
 from json_to_recordset(_data_json) x 
(
代码 VARCHAR,
时间 VARCHAR,
名称 VARCHAR,
板块 VARCHAR,
相关信息 VARCHAR
)
ON CONFLICT(code,t_time)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fhps_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fhps_em"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fhps_em"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fhps_em(code,name,transfer_total_rate,transfer_rate,transfer_share_rate,profit_rate,dividend_rate,pre_share,net_value,notice_date,exdividend_date,check_date,progress,new_notice_date)
select x.代码,x.名称,x."送转股份-送转总比例",x."送转股份-送转比例",x."送转股份-转股比例",x."现金分红-现金分红比例",x."现金分红-股息率",x.每股收益,x.每股净资产,x.预案公告日,x.股权登记日,x.除权除息日,x.方案进度,x.最新公告日期
 from json_to_recordset(_data_json) x 
(
代码 VARCHAR,
名称 VARCHAR,
"送转股份-送转总比例" numeric(32,2),
"送转股份-送转比例" numeric(32,2),
"送转股份-转股比例" numeric(32,2),
"现金分红-现金分红比例" numeric(32,2),
"现金分红-股息率" numeric(32,2),
每股收益 numeric(32,2),
每股净资产 numeric(32,2),
预案公告日 date,
股权登记日 date,
除权除息日 date,
方案进度 VARCHAR,
最新公告日期 date
)
ON CONFLICT(code,new_notice_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_big_deal
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_big_deal"("_type" text, "_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_big_deal"("_type" text, "_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_big_deal(name,t_date,ind_index,change,in_money,out_money,net_money,t_type)
select
x.行业
,_date
,x.行业指数
,CASE WHEN stock.isnumeric(replace(x.阶段涨跌幅, '%', '')) THEN CAST(REPLACE(x.阶段涨跌幅, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS change
,x.流入资金
,x.流出资金
,x.净额
,_type  
from json_to_recordset(_json) x 
(
	行业 varchar,
	行业指数 numeric(18,2),
	阶段涨跌幅 varchar,
	流入资金 numeric(18,2),
	流出资金 numeric(18,2),
	净额 numeric(18,2)
)
ON CONFLICT(name,t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_big_deal
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_big_deal"("_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_big_deal"("_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_big_deal(t_date,code,name,t_time,price,t_amount,t_money,bill_type,change,change_price)
select
_date
,x.股票代码
,x.股票简称
,x.成交时间
,x.成交价格
,x.成交量
,x.成交额
,x.大单性质
,CASE WHEN stock.isnumeric(replace(x.涨跌幅, '%', '')) THEN CAST(REPLACE(x.涨跌幅, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS change
,x.涨跌额
from json_to_recordset(_json) x 
(
	股票代码 varchar,
	股票简称 varchar,
	成交时间 TIMESTAMP,
	成交价格 numeric(18,2),
	成交量 numeric(18,2),
	成交额 numeric(18,2),
	大单性质 varchar,
	涨跌幅 varchar,
	涨跌额 numeric(18,2)
)
ON CONFLICT(code,t_time,bill_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_individual
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_individual"("_type" text, "_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_individual"("_type" text, "_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_individual(code,name,t_date,new_price,change,hands,in_money,out_money,net_money,t_amount,big_bill_in,t_type)
select lpad(x.股票代码,6,'0')
,x.股票简称
,_date
,x.最新价
,CASE WHEN stock.isnumeric(replace(x.涨跌幅, '%', '')) THEN CAST(REPLACE(x.涨跌幅, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS change
,CASE WHEN stock.isnumeric(replace(x.换手率, '%', '')) THEN CAST(REPLACE(x.换手率, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS hands
,case when x.流入资金 ~ '万' then cast(replace(x.流入资金,'万','')  as DECIMAL(18,2)) * 10000
		 when x.流入资金 ~ '亿' then cast(replace(x.流入资金,'亿','') as DECIMAL(18,2)) * 100000000
		 else cast(x.流入资金  as DECIMAL(18,2))
		 end as in_money
,case when x.流出资金 ~ '万' then cast(replace(x.流出资金,'万','')  as DECIMAL(18,2)) * 10000
		 when x.流出资金 ~ '亿' then cast(replace(x.流出资金,'亿','') as DECIMAL(18,2)) * 100000000
		 else cast(x.流出资金  as DECIMAL(18,2))
		 end as out_money
,case when x.净额 ~ '万' then cast(replace(x.净额,'万','')  as DECIMAL(18,2)) * 10000
		 when x.净额 ~ '亿' then cast(replace(x.净额,'亿','') as DECIMAL(18,2)) * 100000000
		 else cast(x.净额  as DECIMAL(18,2))
		 end as net_money
,case when x.成交额 ~ '万' then cast(replace(x.成交额,'万','')  as DECIMAL(18,2)) * 10000
		 when x.成交额 ~ '亿' then cast(replace(x.成交额,'亿','') as DECIMAL(18,2)) * 100000000
		 else cast(x.成交额  as DECIMAL(18,2))
		 end as t_amount
,x.大单流入
,_type  
from json_to_recordset(_json) x 
(
	股票代码 varchar,
	股票简称 varchar,
	最新价 numeric(18,2),
	涨跌幅 varchar,
	换手率 varchar,
	流入资金 varchar,
	流出资金 varchar,
	净额 varchar,
	成交额 varchar,
	大单流入 varchar
)
ON CONFLICT(code,t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_individual_day
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_individual_day"("_type" text, "_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_individual_day"("_type" text, "_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_individual_day(code,name,t_date,new_price,change,hands,net_in_money,t_type)
select lpad(x.股票代码,6,'0')
,x.股票简称
,_date
,x.最新价
,CASE WHEN stock.isnumeric(replace(x.阶段涨跌幅, '%', '')) THEN CAST(REPLACE(x.阶段涨跌幅, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS change
,CASE WHEN stock.isnumeric(replace(x.连续换手率, '%', '')) THEN CAST(REPLACE(x.连续换手率, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS hands
,case when x.资金流入净额 ~ '万' then cast(replace(x.资金流入净额,'万','')  as DECIMAL(18,2)) * 10000
		 when x.资金流入净额 ~ '亿' then cast(replace(x.资金流入净额,'亿','') as DECIMAL(18,2)) * 100000000
		 else cast(x.资金流入净额  as DECIMAL(18,2))
		 end as net_in_money
,_type  
from json_to_recordset(_json) x 
(
	股票代码 varchar,
	股票简称 varchar,
	最新价 numeric(18,2),
	阶段涨跌幅 varchar,
	连续换手率 varchar,
	资金流入净额 varchar
)
ON CONFLICT(code,t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_industry
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_industry"("_type" text, "_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_industry"("_type" text, "_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_industry(name,t_date,ind_index,change,in_money,out_money,net_money,t_type)
select
x.行业
,_date
,x.行业指数
,x."行业-涨跌幅"
,x.流入资金
,x.流出资金
,x.净额
,_type  
from json_to_recordset(_json) x 
(
	行业 varchar,
	行业指数 numeric(18,2),
	"行业-涨跌幅" numeric(18,2),
	流入资金 numeric(18,2),
	流出资金 numeric(18,2),
	净额 numeric(18,2)
)
ON CONFLICT(name,t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_fund_flow_industry_day
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_fund_flow_industry_day"("_type" text, "_date" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_fund_flow_industry_day"("_type" text, "_date" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_fund_flow_industry(name,t_date,ind_index,change,in_money,out_money,net_money,t_type)
select
x.行业
,_date
,x.行业指数
,CASE WHEN stock.isnumeric(replace(x.阶段涨跌幅, '%', '')) THEN CAST(REPLACE(x.阶段涨跌幅, '%', '') AS DECIMAL (18,2)) ELSE 0 END AS change
,x.流入资金
,x.流出资金
,x.净额
,_type  
from json_to_recordset(_json) x 
(
	行业 varchar,
	行业指数 numeric(18,2),
	阶段涨跌幅 varchar,
	流入资金 numeric(18,2),
	流出资金 numeric(18,2),
	净额 numeric(18,2)
)
ON CONFLICT(name,t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_hsgt_hold_stock_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_hsgt_hold_stock_em"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_hsgt_hold_stock_em"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_hsgt_hold_stock_em(
board,t_date,code,name,close
,change,stock_number,stock_value,flow_market_rate
,buy_stock_number,buy_stock_value,buy_rate,buy_flow_market_rate)
select x.所属板块,cast(to_char(x.日期, 'YYYYMMDD') as int),x.代码,x.名称,x.今日收盘价
,x.今日涨跌幅,x."今日持股-股数",x."今日持股-市值",x."今日持股-占流通股比"
,x."今日增持估计-股数",x."今日增持估计-市值",x."今日增持估计-市值增幅",x."今日增持估计-占流通股比"
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
代码 varchar,
名称 varchar,
今日收盘价 numeric(32,2),
今日涨跌幅 numeric(32,2),
"今日持股-股数" numeric(32,2),
"今日持股-市值" numeric(32,2),
"今日持股-占流通股比" numeric(32,2),
"今日增持估计-股数" numeric(32,2),
"今日增持估计-市值" numeric(32,2),
"今日增持估计-市值增幅" numeric(32,2),
"今日增持估计-占流通股比" numeric(32,2),
所属板块 varchar
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_hsgt_north_net_flow_in_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_hsgt_north_net_flow_in_em"("_symbol" text, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_hsgt_north_net_flow_in_em"("_symbol" text, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_hsgt_north_net_flow_in_em(t_date,in_money,t_type)
select cast(to_char(x.date, 'YYYYMMDD') as int),x.value,_symbol  from json_to_recordset(_json) x 
(
	date TIMESTAMP,
	value numeric(18,2)
)
ON CONFLICT(t_date,t_type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_industry_tdx
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_industry_tdx"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_industry_tdx"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_industry_tdx(code,name)
select x.code,x.name from json_to_recordset($1) x 
(
	code varchar,
	name varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_industry_tdx_daily
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_industry_tdx_daily"("_code" varchar, "_name" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_industry_tdx_daily"("_code" varchar, "_name" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_industry_tdx_daily(code,name,t_date,open,close,high,low,volume,up_count,down_count)
select _code,_name,cast(to_char(x.datetime, 'YYYYMMDD') as int),x.open,x.close,x.high,x.low,x.volume,x.up_count,x.down_count
 from json_to_recordset(_data_json) x 
(
datetime timestamp,
open numeric(32,2),
close numeric(32,2),
high numeric(32,2),
low numeric(32,2),
volume numeric(32,2),
up_count int,
down_count int
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_info_a_code_name
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_info_a_code_name"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_info_a_code_name"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_info_a_code_name(code,name)
select x.code,x.name from json_to_recordset($1) x 
(
	code varchar,
	name varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_info_a_code_name_del
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_info_a_code_name_del"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_info_a_code_name_del"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_info_a_code_name_del(code,name)
select x.公司代码,x.公司简称 from json_to_recordset($1) x 
(
	公司代码 varchar,
	公司简称 varchar
)
ON CONFLICT(code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_cxd_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_cxd_ths"("_type" varchar, "_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_cxd_ths"("_type" varchar, "_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_cxg_ths(type,symbol,code,name,change,hands,new_price,last_price,last_date)
select _type,_symbol,x.股票代码,x.股票简称,x.涨跌幅,x.换手率,x.最新价,x.前期低点,cast(to_char(x.前期低点日期, 'YYYYMMDD') as int)
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
涨跌幅 numeric(18,2),
换手率 numeric(18,2),
最新价 numeric(18,2),
前期低点 numeric(18,2),
前期低点日期 timestamp
)
ON CONFLICT(symbol,code,new_price)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_cxfl_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_cxfl_ths"("_type" text, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_cxfl_ths"("_type" text, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_cxfl_ths(code,name,change,new_price,t_amount,t_amount_base,days,change_sum,industry,type)
select x.股票代码,x.股票简称,x.涨跌幅,x.最新价,x.成交量,x.基准日成交量,x.放量天数,x.阶段涨跌幅,x.所属行业,_type
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
涨跌幅 numeric(18,2),
最新价 numeric(18,2),
成交量 VARCHAR,
基准日成交量 VARCHAR,
放量天数 int,
阶段涨跌幅 numeric(18,2),
所属行业 VARCHAR
)
ON CONFLICT(code,change_sum)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_cxg_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_cxg_ths"("_type" varchar, "_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_cxg_ths"("_type" varchar, "_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_cxg_ths(type,symbol,code,name,change,hands,new_price,last_price,last_date)
select _type,_symbol,x.股票代码,x.股票简称,x.涨跌幅,x.换手率,x.最新价,x.前期高点,cast(to_char(x.前期高点日期, 'YYYYMMDD') as int)
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
涨跌幅 numeric(18,2),
换手率 numeric(18,2),
最新价 numeric(18,2),
前期高点 numeric(18,2),
前期高点日期 timestamp
)
ON CONFLICT(symbol,code,new_price)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_cxsl_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_cxsl_ths"("_type" text, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_cxsl_ths"("_type" text, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_cxfl_ths(code,name,change,new_price,t_amount,t_amount_base,days,change_sum,industry,type)
select x.股票代码,x.股票简称,x.涨跌幅,x.最新价,x.成交量,x.基准日成交量,x.缩量天数,x.阶段涨跌幅,x.所属行业,_type
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
涨跌幅 numeric(18,2),
最新价 numeric(18,2),
成交量 VARCHAR,
基准日成交量 VARCHAR,
缩量天数 int,
阶段涨跌幅 numeric(18,2),
所属行业 VARCHAR
)
ON CONFLICT(code,change_sum)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_ljqd_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_ljqd_ths"("_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_ljqd_ths"("_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_ljqs_ths(type,code,name,new_price,days,change,hands,industry)
select _type,x.股票代码,x.股票简称,x.最新价,x.量价齐跌天数,x.阶段涨幅,x.累计换手率,x.所属行业
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
最新价 numeric(18,2),
量价齐跌天数 INT,
阶段涨幅 numeric(18,2),
累计换手率 numeric(18,2),
所属行业 VARCHAR
)
ON CONFLICT(code,change,type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_ljqs_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_ljqs_ths"("_type" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_ljqs_ths"("_type" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_ljqs_ths(type,code,name,new_price,days,change,hands,industry)
select _type,x.股票代码,x.股票简称,x.最新价,x.量价齐升天数,x.阶段涨幅,x.累计换手率,x.所属行业
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
最新价 numeric(18,2),
量价齐升天数 INT,
阶段涨幅 numeric(18,2),
累计换手率 numeric(18,2),
所属行业 VARCHAR
)
ON CONFLICT(code,change,type)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_lxsz_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_lxsz_ths"("_type" text, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_lxsz_ths"("_type" text, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_lxsz_ths(code,name,close,high,low,days,change,hands,industry,type)
select x.股票代码,x.股票简称,x.收盘价,x.最高价,x.最低价,x.连涨天数,x.连续涨跌幅,x.累计换手率,x.所属行业,_type
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
收盘价 numeric(18,2),
最高价 numeric(18,2),
最低价 numeric(18,2),
连涨天数 INT,
连续涨跌幅 numeric(18,2),
累计换手率 numeric(18,2),
所属行业 VARCHAR
)
ON CONFLICT(code,change)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_xstp_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_xstp_ths"("_type" varchar, "_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_xstp_ths"("_type" varchar, "_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_xstp_ths(type,symbol,code,name,change,hands,new_price,t_amount,t_volume)
select _type,_symbol,x.股票代码,x.股票简称,x.涨跌幅,x.换手率,x.最新价,x.成交额,x.成交量
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
涨跌幅 numeric(18,2),
换手率 numeric(18,2),
最新价 numeric(18,2),
成交额 VARCHAR,
成交量 VARCHAR
)
ON CONFLICT(code,change,new_price)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_rank_xzjp_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_rank_xzjp_ths"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_rank_xzjp_ths"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_rank_xzjp_ths(notice_date,code,name,now_price,change,hold,add_volume,t_price,add_rate,sum_volumn,sum_rete)
select cast(to_char(x.举牌公告日, 'YYYYMMDD') as int),
x.股票代码,x.股票简称,x.现价,x.涨跌幅,x.举牌方,x.增持数量,x.交易均价,x.增持数量占总股本比例,x.变动后持股总数,x.变动后持股比例
 from json_to_recordset(_data_json) x 
(
举牌公告日 timestamp,
股票代码 VARCHAR,
股票简称 VARCHAR,
现价 numeric(18,2),
涨跌幅 numeric(18,2),
举牌方 VARCHAR,
增持数量 VARCHAR,
交易均价 numeric(18,2),
增持数量占总股本比例 numeric(18,2),
变动后持股总数 VARCHAR,
变动后持股比例 numeric(18,2)
)
ON CONFLICT(notice_date, code, now_price, hold)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_report_fund_hold
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_report_fund_hold"("_type" varchar, "_date" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_report_fund_hold"("_type" varchar, "_date" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_report_fund_hold(code,name,fund_count,hold_amount,hold_vlues,change,hold_change,hold_change_rate,t_type,notice_date)
select x.股票代码,x.股票简称,x.持有基金家数,x.持股总数,x.持股市值,x.持股变化,x.持股变动数值,x.持股变动比例,_type,_date
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
持有基金家数 int,
持股总数 int8,
持股市值 numeric(18,2),
持股变化 VARCHAR,
持股变动数值 int8,
持股变动比例 numeric(18,2)
)
ON CONFLICT(code,t_type,notice_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_select_shapes
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_select_shapes"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_select_shapes"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_select_shapes(code,name,t_date,flag,shapes)
select x.code,x.name,x.t_date,x.flag,x.symbol from json_to_recordset(_data_json) x 
(
	code varchar,
	name varchar,
	t_date int,
	flag int,
	symbol varchar
)
ON CONFLICT(code,t_date,shapes)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_select_shapes120
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_select_shapes120"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_select_shapes120"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_select_shapes120(code,name,t_date,t_time,flag,shapes)
select x.code,x.name,x.t_date,x.t_time,x.flag,x.symbol from json_to_recordset(_data_json) x 
(
	code varchar,
	name varchar,
	t_date int,
	t_time timestamp,
	flag int,
	symbol varchar
)
ON CONFLICT(code,t_date,t_time,shapes)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_select_shapes_index
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_select_shapes_index"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_select_shapes_index"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_select_shapes_index(code,name,t_date,flag,shapes)
select x.code,x.name,x.t_date,x.flag,x.symbol from json_to_recordset(_data_json) x 
(
	code varchar,
	name varchar,
	t_date int,
	flag int,
	symbol varchar
)
ON CONFLICT(code,t_date,shapes)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_stat_tdx_index
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_stat_tdx_index"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_stat_tdx_index"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

INSERT INTO stock.stock_stat_tdx_index
(t_date, code, "name", "open", high
, low, "close", turnover, channel_short_up
, channel_short_down, channel_long_up, channel_long_down, r9_low_9, r9_high_9
, cycx1 ,cycx2 ,cycx3 
, jlhb_b, jlhb_var2, jlhb, zljk_guiji, zljk_mazl
, zljk_jinchang, zljk_xipan, zljk_lagao, zljk_chuhuo)
select cast(to_char(x.时间, 'YYYYMMDD') as int),x.code,x.name,x.开盘,x.最高
,x.最低,x.收盘,x.成交量,x.九转趋势通道短上轨
,x.九转趋势通道短下轨,x.九转趋势通道长上轨,x.九转趋势通道长下轨,x.九转趋势通道7,x.九转趋势通道11
,x.九转趋势通道CYCX1,x.九转趋势通道CYCX2,x.九转趋势通道CYCX3
,x.JLHBB,x.JLHBVAR2,x.JLHB绝路航标,x.主力监控主力轨迹,x.主力监控MAZL
,x.主力监控主力进场,x.主力监控洗盘,x.主力监控主力拉高,x.主力监控出货
 from json_to_recordset(_data_json) x 	
(
code VARCHAR,
name VARCHAR,
时间 timestamp,
开盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
收盘 numeric(32,2),
成交量 numeric(18,2),
九转趋势通道短上轨 numeric(32,2),
九转趋势通道短下轨 numeric(32,2),
九转趋势通道长上轨 numeric(32,2),
九转趋势通道长下轨 numeric(32,2),
九转趋势通道7 numeric(18,2),
九转趋势通道11 numeric(18,2),
九转趋势通道CYCX1 numeric(18,2),
九转趋势通道CYCX2 numeric(18,2),
九转趋势通道CYCX3 numeric(18,2),
JLHBB numeric(18,2),
JLHBVAR2 numeric(18,2),
JLHB绝路航标 numeric(18,2),
主力监控主力轨迹 numeric(18,2),
主力监控MAZL numeric(18,2),
主力监控主力进场 numeric(18,2),
主力监控洗盘 numeric(18,2),
主力监控主力拉高 numeric(18,2),
主力监控出货 numeric(18,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_stat_tdx_index_test
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_stat_tdx_index_test"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_stat_tdx_index_test"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

INSERT INTO stock.stock_stat_tdx_index
(t_date, code, "name", "open", high
, low)
select cast(to_char(x.时间, 'YYYYMMDD') as int),x.code,x.name,x.开盘,x.最高,x.最低
 from json_to_recordset(_data_json) x 	
(
code VARCHAR,
name VARCHAR,
时间 timestamp,
开盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_yjbb_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_yjbb_em"("_date" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_yjbb_em"("_date" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_yjbb_em(code,name,income,taking,taking_year_rate,taking_quarter_rate,profit,profit_year_rate,profit_quarter_rate,netvalue_per,roe,cash_per,gross,industry,notice_date,t_date)
select x.股票代码,x.股票简称,x.每股收益,x."营业收入-营业收入",x."营业收入-同比增长",x."营业收入-季度环比增长",x."净利润-净利润",x."净利润-同比增长",x."净利润-季度环比增长",x.每股净资产,x.净资产收益率,x.每股经营现金流量,x.销售毛利率,x.所处行业,x.最新公告日期,_date
 from json_to_recordset(_data_json) x 
(
股票代码 VARCHAR,
股票简称 VARCHAR,
每股收益 numeric(18,2),
"营业收入-营业收入" numeric(18,2),
"营业收入-同比增长" numeric(18,2),
"营业收入-季度环比增长" numeric(18,2),
"净利润-净利润" numeric(18,2),
"净利润-同比增长" numeric(18,2),
"净利润-季度环比增长" numeric(18,2),
每股净资产 numeric(18,2),
净资产收益率 numeric(18,2),
每股经营现金流量 numeric(18,2),
销售毛利率 numeric(18,2),
所处行业 VARCHAR,
最新公告日期 VARCHAR
)
where x.股票代码 like '6%' or x.股票代码 like '3%' or x.股票代码 like '0%'
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_gdhs
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_gdhs"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_gdhs"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_gdhs(code,name,end_date,change,holder_count,holder_count_last,holder_count_net,holder_count_net_rate,market_value,notice_date)
select x.代码,x.名称,x."股东户数统计截止日-本次",x.区间涨跌幅,x."股东户数-本次",x."股东户数-上次",x."股东户数-增减",x."股东户数-增减比例",x.总市值,x.公告日期
 from json_to_recordset(_data_json) x 
(
代码 VARCHAR,
名称 VARCHAR,
"股东户数统计截止日-本次" date,
区间涨跌幅 numeric(18,2),
"股东户数-本次" int,
"股东户数-上次" int,
"股东户数-增减" int,
"股东户数-增减比例" numeric(18,2),
总市值 numeric(18,2),
公告日期 date
)
ON CONFLICT(code,notice_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_hist
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_hist"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_hist"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_hist(code,t_date,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands,ema5,ema10,ema20,ema30,dif,dea,macd)
select _symbol,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率,x.ema5,x.ema10,x.ema20,x.ema30,x.dif,x.dea,x.macd * 2 as macd
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘 numeric(32,2),
收盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
成交量 int8,
成交额 numeric(32,2),
振幅 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
换手率 numeric(32,2),
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_hist_min_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_hist_min_em"("_tdate" int4, "_symbol" varchar, "_period" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_hist_min_em"("_tdate" int4, "_symbol" varchar, "_period" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_hist_min_em(code,t_date,t_time,open,close,high,low,t_amount,t_monry,new_price,swing,hands,period)
select _symbol,cast(to_char(x.时间, 'YYYYMMDD') as int),x.时间,x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.最新价,x.振幅,x.换手率,_period
 from json_to_recordset(_data_json) x 
(
时间 timestamp,
开盘 numeric(18,2),
收盘 numeric(18,2),
最高 numeric(18,2),
最低 numeric(18,2),
成交量 numeric(18,2),
成交额 numeric(18,2),
最新价 numeric(18,2),
振幅 numeric(18,2),
换手率 numeric(18,2)
)
ON CONFLICT(code,t_date,t_time,period)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_price_rate
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_price_rate"("_code" text, "_date" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_price_rate"("_code" text, "_date" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_price_rate(code,price,t_amount,rate,t_date)
select _code,x."成交价(元)",x."成交量(股)",x.占比,_date
 from json_to_recordset(_data_json) x 
(
"成交价(元)" VARCHAR,
"成交量(股)" VARCHAR,
占比 numeric(18,2)
)
ON CONFLICT(code,t_date,price)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_spot_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_spot_em"("_date" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_spot_em"("_date" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_hist(code,t_date,open,close,high,low,t_amount,t_monry,swing,change,change_price,hands,ema5,ema10,ema20,ema30,dif,dea,macd)
select _date,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率,x.ema5,x.ema10,x.ema20,x.ema30,x.dif,x.dea,x.macd * 2 as macd
 from json_to_recordset(_data_json) x 
(
日期 timestamp,
开盘 numeric(32,2),
收盘 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
成交量 int8,
成交额 numeric(32,2),
振幅 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
换手率 numeric(32,2),
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_spot_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_spot_em"("_date" varchar, "_timeflag" int4, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_spot_em"("_date" varchar, "_timeflag" int4, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_spot_em(t_date,code,name,open,high,low,t_amount,t_monry,swing,change,change_price,hands,new_price,last_close,amount_rate,rise_speed,change_5m,flow_value,change_60d,value_rate,time_flag)
select cast(_date as INT),x.代码,x.名称,x.今开,x.最高,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅,x.涨跌额,x.换手率,x.最新价,x.昨收,x.量比,x.涨速,x."5分钟涨跌",x.流通市值,x."60日涨跌幅",x."市盈率-动态",_timeflag
 from json_to_recordset(_data_json) x 	
(
代码 VARCHAR,
名称 VARCHAR,
今开 numeric(32,2),
最高 numeric(32,2),
最低 numeric(32,2),
成交量 numeric(18,2),
成交额 numeric(32,2),
振幅 numeric(32,2),
涨跌幅 numeric(32,2),
涨跌额 numeric(32,2),
换手率 numeric(32,2),
最新价 numeric(18,2),
昨收 numeric(18,2),
量比 numeric(18,2),
涨速 numeric(18,2),
"5分钟涨跌" numeric(18,2),
流通市值 numeric(18,2),
"60日涨跌幅" numeric(18,2),
"市盈率-动态" numeric(18,2)
)
ON CONFLICT(code,t_date,time_flag)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_tick_tx
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_tick_tx"("_symbol" varchar, "_period" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_tick_tx"("_symbol" varchar, "_period" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_tick_tx(code,t_date,open,close,high,low,t_amount,t_monry,new_price,period)
select _symbol,x.时间,x.开盘,x.收盘,x.最高,x.最低,x.成交量,x.成交额,x.最新价,_period
 from json_to_recordset(_data_json) x 
(
时间 timestamp,
开盘 numeric(18,2),
收盘 numeric(18,2),
最高 numeric(18,2),
最低 numeric(18,2),
成交量 numeric(18,2),
成交额 numeric(18,2),
最新价 numeric(18,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_tick_tx
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_tick_tx"("_date" int4, "_date_str" varchar, "_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_tick_tx"("_date" int4, "_date_str" varchar, "_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_tick_tx(code,t_time,t_price,change,t_amount,t_money,t_type,t_date)
select _symbol,cast(_date_str || ' ' || x.成交时间 as TIMESTAMP),x.成交价格,x.价格变动,x.成交量,x.成交金额,x.性质,_date
 from json_to_recordset(_data_json) x 
(
成交时间 VARCHAR,
成交价格 numeric(18,2),
价格变动 numeric(18,2),
成交量 numeric(18,2),
成交金额 numeric(18,2),
性质 VARCHAR
)
ON CONFLICT(code,t_time)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zh_a_tick_tx
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zh_a_tick_tx"("_symbol" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zh_a_tick_tx"("_symbol" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_zh_a_tick_tx(code,t_time,t_price,change,t_amount,t_money,t_type)
select _symbol,cast(CURRENT_DATE || ' ' || x.成交时间 as TIMESTAMP),x.成交价格,x.价格变动,x.成交量,x.成交金额,x.性质
 from json_to_recordset(_data_json) x 
(
成交时间 VARCHAR,
成交价格 numeric(18,2),
价格变动 numeric(18,2),
成交量 numeric(18,2),
成交金额 numeric(18,2),
性质 VARCHAR
)
ON CONFLICT(code,t_time)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_stock_zt_pool_em
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_stock_zt_pool_em"("_date" varchar, "_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."ins_stock_zt_pool_em"("_date" varchar, "_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
begin
-- 删除当天已经存在的数据
delete from stock.stock_zt_pool_em where t_date = cast(_date as int);

insert into stock.stock_zt_pool_em(code,name,change,new_price,t_money,market_val_ch,market_val_sum
,hands,close_money,first_close_time,end_close_time,open_times,change_static,series_days,industry,t_date)
select x.代码,x.名称,x.涨跌幅,x.最新价,x.成交额,x.流通市值,x.总市值,x.换手率,x.封板资金,cast(CURRENT_DATE || ' ' || x.首次封板时间 as TIMESTAMP),cast(CURRENT_DATE || ' ' || x.最后封板时间 as TIMESTAMP),
    x.炸板次数,x.涨停统计,x.连板数,x.所属行业,cast(_date as int)
 from json_to_recordset(_data_json) x 
(
代码 VARCHAR,
名称 VARCHAR,
涨跌幅 numeric(18,2),
最新价 numeric(18,2),
成交额 numeric(18,2),
流通市值 numeric(18,2),
总市值 numeric(18,2),
换手率 numeric(18,2),
封板资金 numeric(18,2),
首次封板时间 VARCHAR,
最后封板时间 VARCHAR,
炸板次数 int,
涨停统计 VARCHAR,
连板数 int,
所属行业 VARCHAR
)
ON CONFLICT(code,t_date)
DO NOTHING;

insert into stock_select_shapes(code,name,t_date,flag,shapes) 
select x.代码,x.名称,cast(_date as int),100,'涨停'
 from json_to_recordset(_data_json) x 
(
代码 VARCHAR,
名称 VARCHAR
)
ON CONFLICT(code,t_date,shapes) DO nothing;
                                                
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for ins_tool_trade_date_hist_sina
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."ins_tool_trade_date_hist_sina"(json);
CREATE OR REPLACE FUNCTION "stock"."ins_tool_trade_date_hist_sina"(json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.tool_trade_date_hist_sina(t_date)
select cast(to_char(x.trade_date, 'YYYYMMDD') as int) from json_to_recordset($1) x 
(
trade_date timestamp
)
ON CONFLICT(t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for isnumeric
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."isnumeric"("txtstr" varchar);
CREATE OR REPLACE FUNCTION "stock"."isnumeric"("txtstr" varchar)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
	RETURN txtStr ~ '^(\-|\+)?\d+(\.\d+)?$' ;
END ; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_index_change_period
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_index_change_period"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_index_change_period"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 计算T+x日累计涨幅
  with cet_per3 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 4 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 3 preceding) limit 4)
 insert into stock_change_period (code,t_date,change,day3)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);

-- 计算历史数据的方法
--   with cet_per3 as NOT MATERIALIZED(
-- 								select code,t_date,change,case  when count(*) over s > 3 and last_value(close) over s <> 0
-- 								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
-- 								else 1000 end as sumchange
-- 								from stock_stat_tdx_index where code = _code
-- 								window s as (partition by code order by t_date desc rows 3 preceding) limit 400)
--  insert into stock_change_period (code,t_date,change,day3)
--  select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
--  left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
--  ON CONFLICT (code,t_date) 
--  DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);
 
  with cet_per5 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 6 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 5 preceding) limit 6)
 insert into stock_change_period (code,t_date,change,day5)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per5 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day5 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day5,c_time) = (excluded.day5, CURRENT_TIMESTAMP);
 
  with cet_per10 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 11 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 10 preceding) limit 11)
 insert into stock_change_period (code,t_date,change,day10)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per10 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day10 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day10,c_time) = (excluded.day10, CURRENT_TIMESTAMP);
 
  with cet_per20 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 21 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 20 preceding) limit 21)
 insert into stock_change_period (code,t_date,change,day20)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per20 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day20 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day20,c_time) = (excluded.day20, CURRENT_TIMESTAMP);
 
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 31 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 30 preceding) limit 31)
 insert into stock_change_period (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per30 c  
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 61 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 60 preceding) limit 61)
 insert into stock_change_period (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per60 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 91 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 90 preceding) limit 91)
 insert into stock_change_period (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per90 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 121 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 120 preceding) limit 121)
 insert into stock_change_period (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per120 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_index_change_period_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_index_change_period_his"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_index_change_period_his"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 计算T+x日累计涨幅
--  with cet_per3 as NOT MATERIALIZED(
--								select code,t_date,change,case  when count(*) over s = 4 and last_value(close) over s <> 0
--								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
--								else 1000 end as sumchange
--								from stock_stat_tdx_index where code = _code
--								window s as (partition by code order by t_date desc rows 3 preceding) limit 4)
-- insert into stock_change_period (code,t_date,change,day3)
-- select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
-- left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
-- ON CONFLICT (code,t_date) 
-- DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);

-- 计算历史数据的方法
   with cet_per3 as NOT MATERIALIZED(
 								select code,t_date,change,case  when count(*) over s > 3 and last_value(close) over s <> 0
 								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
 								else 1000 end as sumchange
 								from stock_stat_tdx_index where code = _code
 								window s as (partition by code order by t_date desc rows 3 preceding) limit 3000)
  insert into stock_change_period (code,t_date,change,day3)
  select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
  left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
  ON CONFLICT (code,t_date) 
  DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);
 
  with cet_per5 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 5 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 5 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day5)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per5 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day5 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day5,c_time) = (excluded.day5, CURRENT_TIMESTAMP);
 
  with cet_per10 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 10 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 10 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day10)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per10 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day10 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day10,c_time) = (excluded.day10, CURRENT_TIMESTAMP);
 
  with cet_per20 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 20 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 20 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day20)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per20 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day20 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day20,c_time) = (excluded.day20, CURRENT_TIMESTAMP);
 
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 30 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 30 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per30 c  
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 60 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 60 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per60 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 90 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 90 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per90 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 120 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_stat_tdx_index where code = _code
								window s as (partition by code order by t_date desc rows 120 preceding) limit 3000)
 insert into stock_change_period (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per120 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_index_daily_macd
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_index_daily_macd"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."jobs_index_daily_macd"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN

update stock_zh_index_spot tb
set 
ema5 = x.ema5
,ema10 = x.ema10
,ema20 = x.ema20
,ema30 = x.ema30
,dif = x.dif
,dea = x.dea
,macd = x.macd * 2
from json_to_recordset(_data_json) x 
(
code VARCHAR,
t_date int,
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
) 
where tb.code = x.code and tb.t_date = x.t_date;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_board_industry_hist_em_9rb
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_board_industry_hist_em_9rb"("_date" int4);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_board_industry_hist_em_9rb"("_date" int4)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 比较当日收盘价和4日前收盘价,计算九转序列
with cet_rollback as(
										select code
										,t_date
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_board_industry_hist_em 
										where t_date in 
										(select t_date from tool_trade_date_hist_sina where t_date <= _date ORDER BY t_date DESC LIMIT 5)
										window s as (partition by code order by t_date rows 4 PRECEDING) )
 insert into stock_board_industry_hist_em (code,t_date,close,last4,r_flag)
 select c.code,c.t_date,c.close,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback c
 where c.t_date = _date
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

 with cet_rollback2 as(
										select code
										,t_date
										,t_time
										,period
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_board_industry_hist_min_em 
										where t_date in 
										(select t_date from tool_trade_date_hist_sina where t_date <= _date ORDER BY t_date DESC LIMIT 5) 
										window s as (partition by code order by t_date,t_time rows 4 PRECEDING) )
 insert into stock_board_industry_hist_min_em (code,t_date,t_time,period,last4,r_flag)
 select c.code,c.t_date,c.t_time,c.period,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback2 c
 ON CONFLICT (code,t_date,t_time,"period") 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_board_industry_hist_em_9rb
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_board_industry_hist_em_9rb"();
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_board_industry_hist_em_9rb"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare last_date int :=20130101;
BEGIN
-- 计算日线9转序列
with cet_rollback as(
										select code
										,t_date
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_board_industry_hist_em where r_flag is null 
										window s as (partition by code order by t_date rows 4 PRECEDING) )
 insert into stock_board_industry_hist_em (code,t_date,close,last4,r_flag)
 select c.code,c.t_date,c.close,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback c
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

with cet_rollback2 as(
										select code
										,t_date
										,t_time
										,period
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_board_industry_hist_min_em where "period"=120 and r_flag is null 
										window s as (partition by code order by t_date,t_time rows 4 PRECEDING) )
 insert into stock_board_industry_hist_min_em (code,t_date,t_time,period,last4,r_flag)
 select c.code,c.t_date,c.t_time,c.period,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback2 c
 ON CONFLICT (code,t_date,t_time,"period") 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_board_industry_hist_em_macd
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_board_industry_hist_em_macd"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_board_industry_hist_em_macd"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN

update stock_board_industry_hist_em tb
set 
ema5 = x.ema5
,ema10 = x.ema10
,ema20 = x.ema20
,ema30 = x.ema30
,dif = x.dif
,dea = x.dea
,macd = x.macd * 2
from json_to_recordset(_data_json) x 
(
code VARCHAR,
t_date int,
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
) 
where tb.code = x.code and tb.t_date = x.t_date;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_change_period
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_change_period"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_change_period"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 计算T+x日累计涨幅
  with cet_per1 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 2 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 1 preceding) limit 2)
 insert into stock_change_period (code,t_date,change,day1)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per1 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day1 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day1,c_time) = (excluded.day1, CURRENT_TIMESTAMP);

 with cet_per3 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 4 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 3 preceding) limit 4)
 insert into stock_change_period (code,t_date,change,day3)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);

 
  with cet_per5 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 6 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 5 preceding) limit 6)
 insert into stock_change_period (code,t_date,change,day5)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per5 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day5 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day5,c_time) = (excluded.day5, CURRENT_TIMESTAMP);
 
  with cet_per10 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 11 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 10 preceding) limit 11)
 insert into stock_change_period (code,t_date,change,day10)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per10 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day10 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day10,c_time) = (excluded.day10, CURRENT_TIMESTAMP);
 
  with cet_per20 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 21 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 20 preceding) limit 21)
 insert into stock_change_period (code,t_date,change,day20)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per20 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day20 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day20,c_time) = (excluded.day20, CURRENT_TIMESTAMP);
 
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 31 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 30 preceding) limit 31)
 insert into stock_change_period (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per30 c  
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 61 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 60 preceding) limit 61)
 insert into stock_change_period (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per60 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 91 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 90 preceding) limit 91)
 insert into stock_change_period (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per90 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s = 121 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 120 preceding) limit 121)
 insert into stock_change_period (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per120 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_change_period_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_change_period_his"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_change_period_his"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 计算T+x日累计涨幅
--  with cet_per3 as NOT MATERIALIZED(
--								select code,t_date,change,case  when count(*) over s = 4 and last_value(close) over s <> 0
--								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
--								else 1000 end as sumchange
--								from stock_zh_a_hist where code = _code
--								window s as (partition by code order by t_date desc rows 3 preceding) limit 4)
-- insert into stock_change_period (code,t_date,change,day3)
-- select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
-- left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
-- ON CONFLICT (code,t_date) 
-- DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);

-- 计算历史数据的方法
  with cet_per1 as NOT MATERIALIZED(
 								select code,t_date,change,case  when count(*) over s > 1 and last_value(close) over s <> 0
 								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
 								else 1000 end as sumchange
 								from stock_zh_a_hist where code = _code
 								window s as (partition by code order by t_date desc rows 1 preceding) limit 300)
  insert into stock_change_period (code,t_date,change,day1)
  select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per1 c 
  left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day1 is null and c.sumchange < 1000
  ON CONFLICT (code,t_date) 
  DO UPDATE SET (day1,c_time) = (excluded.day1, CURRENT_TIMESTAMP);
 
  with cet_per3 as NOT MATERIALIZED(
 								select code,t_date,change,case  when count(*) over s > 3 and last_value(close) over s <> 0
 								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
 								else 1000 end as sumchange
 								from stock_zh_a_hist where code = _code
 								window s as (partition by code order by t_date desc rows 3 preceding) limit 300)
  insert into stock_change_period (code,t_date,change,day3)
  select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
  left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
  ON CONFLICT (code,t_date) 
  DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);
 
  with cet_per5 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 5 and last_value(close) over s <> 0
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 5 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day5)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per5 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day5 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day5,c_time) = (excluded.day5, CURRENT_TIMESTAMP);
 
  with cet_per10 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 10 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 10 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day10)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per10 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day10 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day10,c_time) = (excluded.day10, CURRENT_TIMESTAMP);
 
  with cet_per20 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 20 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 20 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day20)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per20 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day20 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day20,c_time) = (excluded.day20, CURRENT_TIMESTAMP);
 
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 30 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 30 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per30 c  
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 60 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 60 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per60 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 90 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 90 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per90 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case  when count(*) over s > 120 and last_value(close) over s <> 0 
								then cast(100 * ((first_value(close) over s - last_value(close) over s)/last_value(close) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								window s as (partition by code order by t_date desc rows 120 preceding) limit 300)
 insert into stock_change_period (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per120 c 
 left join stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_daily_macd
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_daily_macd"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_daily_macd"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN

update stock_zh_a_hist tb
set 
ema5 = x.ema5
,ema10 = x.ema10
,ema20 = x.ema20
,ema30 = x.ema30
,dif = x.dif
,dea = x.dea
,macd = x.macd * 2
from json_to_recordset(_data_json) x 
(
code VARCHAR,
t_date int,
ema5 numeric(18,12),
ema10 numeric(18,12),
ema20 numeric(18,12),
ema30 numeric(18,12),
dif numeric(18,12),
dea numeric(18,12),
macd numeric(18,12)
) 
where tb.code = x.code and tb.t_date = x.t_date;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_stat_var
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_stat_var"("_data_json" json);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_stat_var"("_data_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_stat_var(
code
,name
,t_date
,var_amount10
,var_amount20
,var_amount30
,var_amount60
,var_amount90
,var_amount120
,var_amount150
,var_change10
,var_change20
,var_change30
,var_change60
,var_change90
,var_change120
,var_change150
,var_close10
,var_close20
,var_close30
,var_close60
,var_close90
,var_close120
,var_close150
,var_atr10
,var_atr20
,var_atr30
,var_atr60
,var_atr90
,var_atr120
,var_atr150
)
select 
code
,name
,t_date
,var_amount10
,var_amount20
,var_amount30
,var_amount60
,var_amount90
,var_amount120
,var_amount150
,var_change10
,var_change20
,var_change30
,var_change60
,var_change90
,var_change120
,var_change150
,var_close10
,var_close20
,var_close30
,var_close60
,var_close90
,var_close120
,var_close150
,var_atr10
,var_atr20
,var_atr30
,var_atr60
,var_atr90
,var_atr120
,var_atr150
from json_to_recordset(_data_json) x 
(
code varchar
,name varchar
,t_date int 
,var_amount10 numeric(18,2)
,var_amount20 numeric(18,2)
,var_amount30 numeric(18,2)
,var_amount60 numeric(18,2)
,var_amount90 numeric(18,2)
,var_amount120 numeric(18,2)
,var_amount150 numeric(18,2)
,var_change10 numeric(18,2)
,var_change20 numeric(18,2)
,var_change30 numeric(18,2)
,var_change60 numeric(18,2)
,var_change90 numeric(18,2)
,var_change120 numeric(18,2)
,var_change150 numeric(18,2)
,var_close10 numeric(18,2)
,var_close20 numeric(18,2)
,var_close30 numeric(18,2)
,var_close60 numeric(18,2)
,var_close90 numeric(18,2)
,var_close120 numeric(18,2)
,var_close150 numeric(18,2)
,var_atr10 numeric(18,2)
,var_atr20 numeric(18,2)
,var_atr30 numeric(18,2)
,var_atr60 numeric(18,2)
,var_atr90 numeric(18,2)
,var_atr120 numeric(18,2)
,var_atr150 numeric(18,2)
)
ON CONFLICT(code,t_date)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_var_pop
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_var_pop"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_var_pop"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
	declare _last_date int;
	declare _t_date int;
BEGIN
  select cast(to_char(CURRENT_DATE - interval'2d', 'YYYYMMDD') as int) into _last_date;
	select cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int) into _t_date;
-- 计算T-x日方差
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 31 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 30 preceding) limit 31)
 insert into stock_var_pop (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange from cet_per30 c  
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 61 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 60 preceding) limit 61)
 insert into stock_var_pop (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange from cet_per60 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 91 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 90 preceding) limit 91)
 insert into stock_var_pop (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange from cet_per90 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 121 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 120 preceding) limit 121)
 insert into stock_var_pop (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange from cet_per120 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
   with cet_per150 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 151 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 150 preceding) limit 151)
 insert into stock_var_pop (code,t_date,change,day150)
 select c.code,c.t_date,c.change,c.sumchange from cet_per150 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day150 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day150,c_time) = (excluded.day150, CURRENT_TIMESTAMP);
 
 -- 更新当日方差比上一日方差变化比例
 with cet_change30 as NOT MATERIALIZED(
			select code,t_date,first_value(day30) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day30change = (day30 - d.lastvalue) * 100 / d.lastvalue
from cet_change30 d 
where c.code = d.code and c.t_date = d.t_date and c.day30change is null;

 with cet_change60 as NOT MATERIALIZED(
			select code,t_date,first_value(day60) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day60change = (day60 - d.lastvalue) * 100 / d.lastvalue
from cet_change60 d 
where c.code = d.code and c.t_date = d.t_date and c.day60change is null;

 with cet_change90 as NOT MATERIALIZED(
			select code,t_date,first_value(day90) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day90change = (day90 - d.lastvalue) * 100 / d.lastvalue
from cet_change90 d 
where c.code = d.code and c.t_date = d.t_date and c.day90change is null;

 with cet_change120 as NOT MATERIALIZED(
			select code,t_date,first_value(day120) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day120change = (day120 - d.lastvalue) * 100 / d.lastvalue
from cet_change120 d 
where c.code = d.code and c.t_date = d.t_date and c.day120change is null;

 with cet_change150 as NOT MATERIALIZED(
			select code,t_date,first_value(day150) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day150change = (day150 - d.lastvalue) * 100 / d.lastvalue
from cet_change150 d 
where c.code = d.code and c.t_date = d.t_date and c.day150change is null;
							
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_var_pop_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_var_pop_his"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_var_pop_his"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
	declare _last_date int;
	declare _t_date int;
BEGIN
  select cast(to_char(CURRENT_DATE - interval'2d', 'YYYYMMDD') as int) into _last_date;
	select cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int) into _t_date;
-- 计算T-x日方差
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 31 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 30 preceding) limit 3100)
 insert into stock_var_pop (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange from cet_per30 c  
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 61 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 60 preceding) limit 6100)
 insert into stock_var_pop (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange from cet_per60 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 91 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 90 preceding) limit 9100)
 insert into stock_var_pop (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange from cet_per90 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 121 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 120 preceding) limit 12100)
 insert into stock_var_pop (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange from cet_per120 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
   with cet_per150 as NOT MATERIALIZED(
								select code,t_date,change,case count(*) over s when 151 then var_pop(change) over s else 1000 end as sumchange 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 150 preceding) limit 15100)
 insert into stock_var_pop (code,t_date,change,day150)
 select c.code,c.t_date,c.change,c.sumchange from cet_per150 c 
 left join stock_var_pop d on c.code = d.code and c.t_date = d.t_date where d.day150 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day150,c_time) = (excluded.day150, CURRENT_TIMESTAMP);
 
 -- 更新当日方差比上一日方差变化比例
 with cet_change30 as NOT MATERIALIZED(
			select code,t_date,first_value(day30) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day30change = (day30 - d.lastvalue) * 100 / d.lastvalue
from cet_change30 d 
where c.code = d.code and c.t_date = d.t_date and c.day30change is null;

 with cet_change60 as NOT MATERIALIZED(
			select code,t_date,first_value(day60) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day60change = (day60 - d.lastvalue) * 100 / d.lastvalue
from cet_change60 d 
where c.code = d.code and c.t_date = d.t_date and c.day60change is null;

 with cet_change90 as NOT MATERIALIZED(
			select code,t_date,first_value(day90) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day90change = (day90 - d.lastvalue) * 100 / d.lastvalue
from cet_change90 d 
where c.code = d.code and c.t_date = d.t_date and c.day90change is null;

 with cet_change120 as NOT MATERIALIZED(
			select code,t_date,first_value(day120) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day120change = (day120 - d.lastvalue) * 100 / d.lastvalue
from cet_change120 d 
where c.code = d.code and c.t_date = d.t_date and c.day120change is null;

 with cet_change150 as NOT MATERIALIZED(
			select code,t_date,first_value(day150) over s as lastvalue
			from stock_var_pop where code = _code and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop c set day150change = (day150 - d.lastvalue) * 100 / d.lastvalue
from cet_change150 d 
where c.code = d.code and c.t_date = d.t_date and c.day150change is null;
							
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_var_pop_volume
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_var_pop_volume"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_var_pop_volume"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
	declare _last_date int;
	declare _t_date int;
BEGIN
  select cast(to_char(CURRENT_DATE - interval'2d', 'YYYYMMDD') as int) into _last_date;
	select cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int) into _t_date;
-- 计算T-x日方差
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 31 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 30 preceding) limit 31)
 insert into stock_var_pop_volume (code,t_date,volume,day30)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per30 c  
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 61 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 60 preceding) limit 61)
 insert into stock_var_pop_volume (code,t_date,volume,day60)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per60 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 91 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 90 preceding) limit 91)
 insert into stock_var_pop_volume (code,t_date,volume,day90)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per90 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 121 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 120 preceding) limit 121)
 insert into stock_var_pop_volume (code,t_date,volume,day120)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per120 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
   with cet_per150 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 151 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 150 preceding) limit 151)
 insert into stock_var_pop_volume (code,t_date,volume,day150)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per150 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day150 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day150,c_time) = (excluded.day150, CURRENT_TIMESTAMP);
 
 -- 更新当日方差比上一日方差变化比例
 with cet_t_amount30 as NOT MATERIALIZED(
			select code,t_date,first_value(day30) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day30change = (day30 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount30 d 
where c.code = d.code and c.t_date = d.t_date and c.day30change is null;

 with cet_t_amount60 as NOT MATERIALIZED(
			select code,t_date,first_value(day60) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day60change = (day60 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount60 d 
where c.code = d.code and c.t_date = d.t_date and c.day60change is null;

 with cet_t_amount90 as NOT MATERIALIZED(
			select code,t_date,first_value(day90) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day90change = (day90 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount90 d 
where c.code = d.code and c.t_date = d.t_date and c.day90change is null;

 with cet_t_amount120 as NOT MATERIALIZED(
			select code,t_date,first_value(day120) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day120change = (day120 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount120 d 
where c.code = d.code and c.t_date = d.t_date and c.day120change is null;

 with cet_t_amount150 as NOT MATERIALIZED(
			select code,t_date,first_value(day150) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day150change = (day150 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount150 d 
where c.code = d.code and c.t_date = d.t_date and c.day150change is null;
							
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_var_pop_volume_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_var_pop_volume_his"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_var_pop_volume_his"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
	declare _last_date int;
	declare _t_date int;
BEGIN
  select cast(to_char(CURRENT_DATE - interval'2d', 'YYYYMMDD') as int) into _last_date;
	select cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int) into _t_date;
-- 计算T-x日方差
  with cet_per30 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 31 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 30 preceding) limit 3100)
 insert into stock_var_pop_volume (code,t_date,volume,day30)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per30 c  
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 61 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 60 preceding) limit 6100)
 insert into stock_var_pop_volume (code,t_date,volume,day60)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per60 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 91 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 90 preceding) limit 9100)
 insert into stock_var_pop_volume (code,t_date,volume,day90)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per90 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 121 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 120 preceding) limit 12100)
 insert into stock_var_pop_volume (code,t_date,volume,day120)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per120 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
   with cet_per150 as NOT MATERIALIZED(
								select code,t_date,t_amount,case count(*) over s when 151 then var_pop(t_amount) over s else 1000 end as sumt_amount 
								from stock_zh_a_hist where code = _code
								and t_date in (select t_date from tool_trade_date_hist_sina where t_date <= _t_date order by t_date desc limit 200)
								window s as (partition by code order by t_date rows 150 preceding) limit 15100)
 insert into stock_var_pop_volume (code,t_date,volume,day150)
 select c.code,c.t_date,c.t_amount,c.sumt_amount from cet_per150 c 
 left join stock_var_pop_volume d on c.code = d.code and c.t_date = d.t_date where d.day150 is null and c.sumt_amount > 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day150,c_time) = (excluded.day150, CURRENT_TIMESTAMP);
 
 -- 更新当日方差比上一日方差变化比例
 with cet_t_amount30 as NOT MATERIALIZED(
			select code,t_date,first_value(day30) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day30change = (day30 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount30 d 
where c.code = d.code and c.t_date = d.t_date and c.day30change is null;

 with cet_t_amount60 as NOT MATERIALIZED(
			select code,t_date,first_value(day60) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day60change = (day60 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount60 d 
where c.code = d.code and c.t_date = d.t_date and c.day60change is null;

 with cet_t_amount90 as NOT MATERIALIZED(
			select code,t_date,first_value(day90) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day90change = (day90 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount90 d 
where c.code = d.code and c.t_date = d.t_date and c.day90change is null;

 with cet_t_amount120 as NOT MATERIALIZED(
			select code,t_date,first_value(day120) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day120change = (day120 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount120 d 
where c.code = d.code and c.t_date = d.t_date and c.day120change is null;

 with cet_t_amount150 as NOT MATERIALIZED(
			select code,t_date,first_value(day150) over s as lastvalue
			from stock_var_pop_volume where code = _code --and t_date > _last_date
			window s as (partition by code order by t_date rows 1 preceding))							
update stock_var_pop_volume c set day150change = (day150 - d.lastvalue) * 100 / d.lastvalue
from cet_t_amount150 d 
where c.code = d.code and c.t_date = d.t_date and c.day150change is null;
							
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_zh_a_hist_9rb
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_zh_a_hist_9rb"("_date" int4);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_zh_a_hist_9rb"("_date" int4)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 比较当日收盘价和4日前收盘价,计算九转序列
with cet_rollback as(
										select code
										,t_date
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_zh_a_hist 
										where t_date in 
										(select t_date from tool_trade_date_hist_sina 
										where t_date <= _date ORDER BY t_date DESC LIMIT 5)
										window s as (partition by code order by t_date rows 4 PRECEDING) )
 insert into stock_zh_a_hist (code,t_date,close,last4,r_flag)
 select c.code,c.t_date,c.close,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback c
 where c.t_date = _date
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);


with cet_rollback2 as(
										select code
										,t_date
										,t_time
										,period
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_zh_a_hist_min_em 
										where t_date in 
										(select t_date from tool_trade_date_hist_sina 
										where t_date <= _date ORDER BY t_date DESC LIMIT 5)
										window s as (partition by code order by t_date,t_time rows 4 PRECEDING) )
 insert into stock_zh_a_hist_min_em (code,t_date,t_time,period,last4,r_flag)
 select c.code,c.t_date,c.t_time,c.period,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback2 c
 ON CONFLICT (code,t_date,t_time,"period") 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_zh_a_hist_9rb_code
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_zh_a_hist_9rb_code"("_code" varchar);
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_zh_a_hist_9rb_code"("_code" varchar)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
-- 计算日线9转序列
with cet_rollback as(
										select code
										,t_date
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_zh_a_hist where code = _code
										window s as (partition by code order by t_date rows 4 PRECEDING) )
 insert into stock_zh_a_hist (code,t_date,close,last4,r_flag)
 select c.code,c.t_date,c.close,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback c
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for jobs_stock_zh_a_hist_9rb_his
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."jobs_stock_zh_a_hist_9rb_his"();
CREATE OR REPLACE FUNCTION "stock"."jobs_stock_zh_a_hist_9rb_his"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare last_date int :=20130101;
BEGIN
-- 计算日线9转序列
with cet_rollback as(
										select code
										,t_date
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_zh_a_hist where t_date > last_date
										window s as (partition by code order by t_date rows 4 PRECEDING) )
 insert into stock_zh_a_hist (code,t_date,close,last4,r_flag)
 select c.code,c.t_date,c.close,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback c
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);


with cet_rollback2 as(
										select code
										,t_date
										,t_time
										,period
										,close
										,count(*) over s,
										first_value(close) over s	 as last4		-- 4日前收盘价
										from stock_zh_a_hist_min_em where "period"=120 and r_flag is null 
										window s as (partition by code order by t_date,t_time rows 4 PRECEDING) )
 insert into stock_zh_a_hist_min_em (code,t_date,t_time,period,last4,r_flag)
 select c.code,c.t_date,c.t_time,c.period,c.last4
 ,case 
		when close > last4 then -1 
		when close = last4 then 0 
		else 1 
 end as r_flag 
 from cet_rollback2 c
 ON CONFLICT (code,t_date,t_time,"period") 
 DO UPDATE SET (last4, r_flag, c_time) = (excluded.last4, excluded.r_flag, CURRENT_TIMESTAMP);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for stock_board_concept_cons_ths
-- ----------------------------
DROP FUNCTION IF EXISTS "stock"."stock_board_concept_cons_ths"("_name" varchar, "_date" varchar, "_count" int4, "_json" json);
CREATE OR REPLACE FUNCTION "stock"."stock_board_concept_cons_ths"("_name" varchar, "_date" varchar, "_count" int4, "_json" json)
  RETURNS "pg_catalog"."void" AS $BODY$
declare row_cnt int :=0;
BEGIN

insert into stock.stock_board_concept_cons_ths(board_name,code,name,t_date,stock_count)
select _name,x.代码,x.名称,cast(_date as int),_count from json_to_recordset(_json) x 
(
	代码 varchar,
	名称 varchar
)
ON CONFLICT(board_name,code)
DO NOTHING;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "stock"."stock_select_shapes_group_id_seq"
OWNED BY "stock"."stock_select_shapes_group"."gid";
SELECT setval('"stock"."stock_select_shapes_group_id_seq"', 483195, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "stock"."tool_trade_date_hist_sina_tid_seq"
OWNED BY "stock"."tool_trade_date_hist_sina"."tid";
SELECT setval('"stock"."tool_trade_date_hist_sina_tid_seq"', 102248, true);

-- ----------------------------
-- Primary Key structure for table fund_etf_list
-- ----------------------------
ALTER TABLE "stock"."fund_etf_list" ADD CONSTRAINT "fund_etf_list_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Primary Key structure for table fund_etf_spot_em
-- ----------------------------
ALTER TABLE "stock"."fund_etf_spot_em" ADD CONSTRAINT "fund_etf_spot_em_pk" PRIMARY KEY ("code", "t_date");

-- ----------------------------
-- Uniques structure for table fund_name_em
-- ----------------------------
ALTER TABLE "stock"."fund_name_em" ADD CONSTRAINT "fund_name_em_idx_unique" UNIQUE ("code");

-- ----------------------------
-- Uniques structure for table fund_portfolio_hold_em
-- ----------------------------
ALTER TABLE "stock"."fund_portfolio_hold_em" ADD CONSTRAINT "fund_portfolio_hold_em_idx_unique" UNIQUE ("fund_code", "stock_code", "year", "quarter");

-- ----------------------------
-- Indexes structure for table index_all_cni
-- ----------------------------
CREATE INDEX "index_all_cni_code_idx" ON "stock"."index_all_cni" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table index_all_cni
-- ----------------------------
ALTER TABLE "stock"."index_all_cni" ADD CONSTRAINT "index_all_cni_un" UNIQUE ("code");

-- ----------------------------
-- Indexes structure for table index_detail_cni
-- ----------------------------
CREATE INDEX "index_detail_cni_index_code_idx" ON "stock"."index_detail_cni" USING btree (
  "index_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table index_detail_cni
-- ----------------------------
ALTER TABLE "stock"."index_detail_cni" ADD CONSTRAINT "index_detail_cni_un" UNIQUE ("index_code", "code", "new_date");

-- ----------------------------
-- Uniques structure for table index_value_hist_funddb
-- ----------------------------
ALTER TABLE "stock"."index_value_hist_funddb" ADD CONSTRAINT "index_value_hist_funddb_un" UNIQUE ("t_date", "code");

-- ----------------------------
-- Uniques structure for table index_value_hist_funddb_fxyj
-- ----------------------------
ALTER TABLE "stock"."index_value_hist_funddb_fxyj" ADD CONSTRAINT "index_value_hist_funddb_un_fxyj" UNIQUE ("t_date", "code");

-- ----------------------------
-- Uniques structure for table index_value_hist_funddb_gxl
-- ----------------------------
ALTER TABLE "stock"."index_value_hist_funddb_gxl" ADD CONSTRAINT "index_value_hist_funddb_un_gxl" UNIQUE ("t_date", "code");

-- ----------------------------
-- Uniques structure for table index_value_hist_funddb_sjl
-- ----------------------------
ALTER TABLE "stock"."index_value_hist_funddb_sjl" ADD CONSTRAINT "index_value_hist_funddb_un_sjl" UNIQUE ("t_date", "code");

-- ----------------------------
-- Indexes structure for table index_value_name_funddb
-- ----------------------------
CREATE INDEX "index_value_name_funddb_code_idx" ON "stock"."index_value_name_funddb" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table index_value_name_funddb
-- ----------------------------
ALTER TABLE "stock"."index_value_name_funddb" ADD CONSTRAINT "index_value_name_funddb_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_a_lg_indicator
-- ----------------------------
CREATE UNIQUE INDEX "stock_a_lg_indicator_code_t_date_idx" ON "stock"."stock_a_lg_indicator" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_a_lg_indicator
-- ----------------------------
ALTER TABLE "stock"."stock_a_lg_indicator" ADD CONSTRAINT "stock_a_lg_indicator_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Primary Key structure for table stock_board_concept_cons_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_concept_cons_ths" ADD CONSTRAINT "stock_board_concept_cons_ths_pk" PRIMARY KEY ("code", "board_name");

-- ----------------------------
-- Indexes structure for table stock_board_industry_hist_em
-- ----------------------------
CREATE INDEX "stock_zh_a_hist_daily_code_idx_copy2" ON "stock"."stock_board_industry_hist_em" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "stock_zh_a_hist_daily_code_t_date_idx_copy3" ON "stock"."stock_board_industry_hist_em" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_hist_daily_t_date_idx_copy2" ON "stock"."stock_board_industry_hist_em" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_board_industry_hist_em
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_hist_em" ADD CONSTRAINT "stock_board_industry_hist_em_pk" PRIMARY KEY ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_board_industry_hist_min_em
-- ----------------------------
CREATE INDEX "stock_board_industry_hist_em120_code_idx" ON "stock"."stock_board_industry_hist_min_em" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_board_industry_hist_min_em
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_hist_min_em" ADD CONSTRAINT "stock_board_industry_hist_min_em_pk" PRIMARY KEY ("code", "t_date", "t_time", "period");

-- ----------------------------
-- Primary Key structure for table stock_board_industry_index_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_index_ths" ADD CONSTRAINT "stock_board_industry_index_ths_pk" PRIMARY KEY ("code", "t_date", "time_flag");

-- ----------------------------
-- Indexes structure for table stock_board_industry_info_ths
-- ----------------------------
CREATE INDEX "stock_board_industry_info_ths_stock_code_idx" ON "stock"."stock_board_industry_info_ths" USING btree (
  "stock_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_board_industry_info_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_info_ths" ADD CONSTRAINT "stock_board_industry_info_ths_un" UNIQUE ("industry_code", "stock_code");

-- ----------------------------
-- Primary Key structure for table stock_board_industry_info_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_info_ths" ADD CONSTRAINT "stock_board_industry_info_ths_pk" PRIMARY KEY ("industry_code", "stock_code");

-- ----------------------------
-- Primary Key structure for table stock_board_industry_name_em
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_name_em" ADD CONSTRAINT "stock_board_industry_name_ths_copy1_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Primary Key structure for table stock_board_industry_name_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_name_ths" ADD CONSTRAINT "stock_board_industry_name_ths_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Primary Key structure for table stock_board_industry_summary_ths
-- ----------------------------
ALTER TABLE "stock"."stock_board_industry_summary_ths" ADD CONSTRAINT "stock_board_industry_summary_ths_pk" PRIMARY KEY ("code", "t_date", "time_flag");

-- ----------------------------
-- Indexes structure for table stock_change_period
-- ----------------------------
CREATE INDEX "stock_change_period_code_idx" ON "stock"."stock_change_period" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_change_period_t_date_idx" ON "stock"."stock_change_period" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_change_period
-- ----------------------------
ALTER TABLE "stock"."stock_change_period" ADD CONSTRAINT "stock_change_period_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Uniques structure for table stock_changes_em
-- ----------------------------
ALTER TABLE "stock"."stock_changes_em" ADD CONSTRAINT "stock_changes_em_idx_unique" UNIQUE ("code", "t_time");

-- ----------------------------
-- Uniques structure for table stock_fhps_em
-- ----------------------------
ALTER TABLE "stock"."stock_fhps_em" ADD CONSTRAINT "c_time	timestamp	6	0	False	False		CURRENT_TIMESTAMP			0				0		0" UNIQUE ("code", "new_notice_date");

-- ----------------------------
-- Indexes structure for table stock_fund_flow_big_deal
-- ----------------------------
CREATE INDEX "stock_fund_flow_big_deal_t_date_idx" ON "stock"."stock_fund_flow_big_deal" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_fund_flow_big_deal
-- ----------------------------
ALTER TABLE "stock"."stock_fund_flow_big_deal" ADD CONSTRAINT "stock_fund_flow_big_deal_idx_unique" UNIQUE ("code", "t_time", "bill_type");

-- ----------------------------
-- Indexes structure for table stock_fund_flow_individual
-- ----------------------------
CREATE INDEX "stock_fund_flow_individual_t_date_idx" ON "stock"."stock_fund_flow_individual" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_fund_flow_individual
-- ----------------------------
ALTER TABLE "stock"."stock_fund_flow_individual" ADD CONSTRAINT "stock_fund_flow_individual_idx_unique" UNIQUE ("code", "t_date", "t_type");

-- ----------------------------
-- Indexes structure for table stock_fund_flow_individual_day
-- ----------------------------
CREATE INDEX "stock_fund_flow_individual_day_t_date_idx" ON "stock"."stock_fund_flow_individual_day" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_fund_flow_individual_day
-- ----------------------------
ALTER TABLE "stock"."stock_fund_flow_individual_day" ADD CONSTRAINT "stock_fund_flow_individual_day_idx_unique" UNIQUE ("code", "t_date", "t_type");

-- ----------------------------
-- Indexes structure for table stock_fund_flow_industry
-- ----------------------------
CREATE INDEX "stock_fund_flow_industry_t_date_idx" ON "stock"."stock_fund_flow_industry" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_fund_flow_industry
-- ----------------------------
ALTER TABLE "stock"."stock_fund_flow_industry" ADD CONSTRAINT "stock_fund_flow_industry_idx_unique" UNIQUE ("name", "t_date", "t_type");

-- ----------------------------
-- Uniques structure for table stock_hsgt_hold_stock_em
-- ----------------------------
ALTER TABLE "stock"."stock_hsgt_hold_stock_em" ADD CONSTRAINT "stock_hsgt_stock_statistics_em_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_hsgt_north_net_flow_in_em
-- ----------------------------
CREATE INDEX "stock_hsgt_north_net_flow_in_em_t_date_idx" ON "stock"."stock_hsgt_north_net_flow_in_em" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_hsgt_north_net_flow_in_em
-- ----------------------------
ALTER TABLE "stock"."stock_hsgt_north_net_flow_in_em" ADD CONSTRAINT "stock_hsgt_north_net_flow_in_em_idx_unique" UNIQUE ("t_date", "t_type");

-- ----------------------------
-- Primary Key structure for table stock_industry_tdx
-- ----------------------------
ALTER TABLE "stock"."stock_industry_tdx" ADD CONSTRAINT "stock_industry_tdx_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Uniques structure for table stock_industry_tdx_daily
-- ----------------------------
ALTER TABLE "stock"."stock_industry_tdx_daily" ADD CONSTRAINT "stock_industry_tdx_daily_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_info_a_code_name
-- ----------------------------
CREATE INDEX "stock_info_a_code_name_code_idx" ON "stock"."stock_info_a_code_name" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_info_a_code_name
-- ----------------------------
ALTER TABLE "stock"."stock_info_a_code_name" ADD CONSTRAINT "stock_info_a_code_name_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Indexes structure for table stock_info_a_code_name_del
-- ----------------------------
CREATE INDEX "stock_info_a_code_name_code_idx_copy1" ON "stock"."stock_info_a_code_name_del" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_info_a_code_name_del
-- ----------------------------
ALTER TABLE "stock"."stock_info_a_code_name_del" ADD CONSTRAINT "stock_info_a_code_name_copy1_pkey" PRIMARY KEY ("code");

-- ----------------------------
-- Indexes structure for table stock_price_live_code_list
-- ----------------------------
CREATE INDEX "stock_price_live_code_list_code_idx" ON "stock"."stock_price_live_code_list" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_price_live_code_list
-- ----------------------------
ALTER TABLE "stock"."stock_price_live_code_list" ADD CONSTRAINT "stock_price_live_code_list_pk" PRIMARY KEY ("code");

-- ----------------------------
-- Indexes structure for table stock_price_live_tencent
-- ----------------------------
CREATE INDEX "stock_price_live_sina_code_idx" ON "stock"."stock_price_live_tencent" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_price_live_tencent
-- ----------------------------
ALTER TABLE "stock"."stock_price_live_tencent" ADD CONSTRAINT "stock_price_live_tencent_un" UNIQUE ("code", "t_date", "time_flag");

-- ----------------------------
-- Uniques structure for table stock_rank_cxfl_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_cxfl_ths" ADD CONSTRAINT "stock_rank_lxsz_ths_copy1_code_change_key" UNIQUE ("code", "change_sum");

-- ----------------------------
-- Uniques structure for table stock_rank_cxg_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_cxg_ths" ADD CONSTRAINT "stock_rank_cxg_ths_unique" UNIQUE ("symbol", "code", "new_price");

-- ----------------------------
-- Uniques structure for table stock_rank_ljqs_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_ljqs_ths" ADD CONSTRAINT "stock_rank_lxsz_ths_copy1_code_change_key1" UNIQUE ("code", "change", "type");

-- ----------------------------
-- Uniques structure for table stock_rank_lxsz_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_lxsz_ths" ADD CONSTRAINT "stock_rank_lxsz_ths_unique" UNIQUE ("code", "change");

-- ----------------------------
-- Uniques structure for table stock_rank_xstp_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_xstp_ths" ADD CONSTRAINT "stock_rank_cxg_ths_copy1_symbol_code_new_price_key" UNIQUE ("code", "new_price", "change");

-- ----------------------------
-- Uniques structure for table stock_rank_xzjp_ths
-- ----------------------------
ALTER TABLE "stock"."stock_rank_xzjp_ths" ADD CONSTRAINT "stock_rank_xzjp_ths_unique" UNIQUE ("code", "now_price", "hold", "notice_date");

-- ----------------------------
-- Indexes structure for table stock_report_fund_hold
-- ----------------------------
CREATE INDEX "stock_report_fund_hold_hold_change_rate_idx" ON "stock"."stock_report_fund_hold" USING btree (
  "hold_change_rate" "pg_catalog"."numeric_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_report_fund_hold
-- ----------------------------
ALTER TABLE "stock"."stock_report_fund_hold" ADD CONSTRAINT "stock_report_fund_hold_idx_unique" UNIQUE ("code", "t_type", "notice_date");

-- ----------------------------
-- Indexes structure for table stock_select_shapes
-- ----------------------------
CREATE INDEX "stock_select_shapes_shapes_idx" ON "stock"."stock_select_shapes" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes_t_date_idx" ON "stock"."stock_select_shapes" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_select_shapes
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes" ADD CONSTRAINT "stock_select_shapes_idx_unique" UNIQUE ("code", "t_date", "shapes");

-- ----------------------------
-- Indexes structure for table stock_select_shapes120
-- ----------------------------
CREATE INDEX "stock_select_shapes120_code_idx" ON "stock"."stock_select_shapes120" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes120_shapes_idx" ON "stock"."stock_select_shapes120" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_select_shapes120
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes120" ADD CONSTRAINT "stock_select_shapes120_pk" PRIMARY KEY ("code", "t_date", "shapes", "t_time");

-- ----------------------------
-- Primary Key structure for table stock_select_shapes_group
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes_group" ADD CONSTRAINT "stock_select_shapes_group_pk" PRIMARY KEY ("shapes");

-- ----------------------------
-- Indexes structure for table stock_select_shapes_index
-- ----------------------------
CREATE INDEX "stock_select_shapes_index_shapes_idx" ON "stock"."stock_select_shapes_index" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes_index_t_date_idx" ON "stock"."stock_select_shapes_index" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_select_shapes_index
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes_index" ADD CONSTRAINT "stock_select_shapes_index_idx_unique" UNIQUE ("code", "t_date", "shapes");

-- ----------------------------
-- Indexes structure for table stock_select_shapes_stat
-- ----------------------------
CREATE INDEX "stock_select_shapes_stat_shapes_idx" ON "stock"."stock_select_shapes_stat" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_select_shapes_stat
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes_stat" ADD CONSTRAINT "stock_select_shapes_stat_pk" PRIMARY KEY ("shapes", "days", "time_flag");

-- ----------------------------
-- Indexes structure for table stock_select_shapes_stock
-- ----------------------------
CREATE INDEX "stock_select_shapes_shapes_idx_copy1" ON "stock"."stock_select_shapes_stock" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes_t_date_idx_copy1" ON "stock"."stock_select_shapes_stock" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes_test_code_idx" ON "stock"."stock_select_shapes_stock" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_select_shapes_stock
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes_stock" ADD CONSTRAINT "stock_select_shapes_copy1_code_t_date_shapes_key" UNIQUE ("code", "t_date", "shapes");

-- ----------------------------
-- Indexes structure for table stock_select_shapes_stock120
-- ----------------------------
CREATE INDEX "stock_select_shapes_stock120_code_idx" ON "stock"."stock_select_shapes_stock120" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_select_shapes_stock120_shapes_idx" ON "stock"."stock_select_shapes_stock120" USING btree (
  "shapes" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_select_shapes_stock120
-- ----------------------------
ALTER TABLE "stock"."stock_select_shapes_stock120" ADD CONSTRAINT "stock_select_shapes_stock120_pk" PRIMARY KEY ("code", "t_date", "t_time", "shapes");

-- ----------------------------
-- Uniques structure for table stock_selected_list
-- ----------------------------
ALTER TABLE "stock"."stock_selected_list" ADD CONSTRAINT "stock_selected_list_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Uniques structure for table stock_selected_list_email
-- ----------------------------
ALTER TABLE "stock"."stock_selected_list_email" ADD CONSTRAINT "stock_selected_list_email_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_stat_tdx_index
-- ----------------------------
CREATE INDEX "stock_stat_tdx_index_code_idx" ON "stock"."stock_stat_tdx_index" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_tdx_index_t_date_idx" ON "stock"."stock_stat_tdx_index" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_stat_tdx_index
-- ----------------------------
ALTER TABLE "stock"."stock_stat_tdx_index" ADD CONSTRAINT "stock_stat_tdx_index_un" UNIQUE ("t_date", "code");

-- ----------------------------
-- Uniques structure for table stock_stat_tdx_index_any
-- ----------------------------
ALTER TABLE "stock"."stock_stat_tdx_index_any" ADD CONSTRAINT "stock_stat_tdx_index_any_un" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_stat_var
-- ----------------------------
CREATE INDEX "stock_stat_var_t_date_idx" ON "stock"."stock_stat_var" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_amount30_idx" ON "stock"."stock_stat_var" USING btree (
  "var_amount30" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_amount60_idx" ON "stock"."stock_stat_var" USING btree (
  "var_amount60" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_change30_idx" ON "stock"."stock_stat_var" USING btree (
  "var_change30" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_change60_idx" ON "stock"."stock_stat_var" USING btree (
  "var_change60" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_close30_idx" ON "stock"."stock_stat_var" USING btree (
  "var_close30" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_stat_var_var_close60_idx" ON "stock"."stock_stat_var" USING btree (
  "var_close60" "pg_catalog"."numeric_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_stat_var
-- ----------------------------
ALTER TABLE "stock"."stock_stat_var" ADD CONSTRAINT "stock_var_stat_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_var_pop
-- ----------------------------
CREATE INDEX "stock_var_pop_day120_idx" ON "stock"."stock_var_pop" USING btree (
  "day120" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day120change_idx" ON "stock"."stock_var_pop" USING btree (
  "day120change" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day150_idx" ON "stock"."stock_var_pop" USING btree (
  "day150" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day150change_idx" ON "stock"."stock_var_pop" USING btree (
  "day150change" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day30_idx" ON "stock"."stock_var_pop" USING btree (
  "day30" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day30change_idx" ON "stock"."stock_var_pop" USING btree (
  "day30change" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day60_idx" ON "stock"."stock_var_pop" USING btree (
  "day60" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day60change_idx" ON "stock"."stock_var_pop" USING btree (
  "day60change" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day90_idx" ON "stock"."stock_var_pop" USING btree (
  "day90" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_day90change_idx" ON "stock"."stock_var_pop" USING btree (
  "day90change" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_var_pop_t_date_idx" ON "stock"."stock_var_pop" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_var_pop
-- ----------------------------
ALTER TABLE "stock"."stock_var_pop" ADD CONSTRAINT "stock_var_pop_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table stock_var_pop_volume
-- ----------------------------
CREATE INDEX "stock_var_pop_volume_t_date_idx" ON "stock"."stock_var_pop_volume" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_var_pop_volume
-- ----------------------------
ALTER TABLE "stock"."stock_var_pop_volume" ADD CONSTRAINT "stock_var_pop_volume_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Uniques structure for table stock_yjbb_em
-- ----------------------------
ALTER TABLE "stock"."stock_yjbb_em" ADD CONSTRAINT "stock_yjbb_em_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Uniques structure for table stock_zh_a_gdhs
-- ----------------------------
ALTER TABLE "stock"."stock_zh_a_gdhs" ADD CONSTRAINT "stock_zh_a_gdhs_idx_unique" UNIQUE ("code", "notice_date");

-- ----------------------------
-- Indexes structure for table stock_zh_a_hist
-- ----------------------------
CREATE UNIQUE INDEX "stock_zh_a_hist_daily_code_t_date_idx" ON "stock"."stock_zh_a_hist" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_hist_t_date_idx" ON "stock"."stock_zh_a_hist" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Indexes structure for table stock_zh_a_hist_min_em
-- ----------------------------
CREATE INDEX "sstock_zh_a_hist_min_em_code_idx" ON "stock"."stock_zh_a_hist_min_em" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "stock_zh_a_hist_min_em_code_t_date_idx" ON "stock"."stock_zh_a_hist_min_em" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "t_time" "pg_catalog"."timestamp_ops" ASC NULLS LAST,
  "period" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_hist_min_em_t_date_idx" ON "stock"."stock_zh_a_hist_min_em" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Indexes structure for table stock_zh_a_price_rate
-- ----------------------------
CREATE INDEX "stock_zh_a_price_rate_t_date_idx" ON "stock"."stock_zh_a_price_rate" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_zh_a_price_rate
-- ----------------------------
ALTER TABLE "stock"."stock_zh_a_price_rate" ADD CONSTRAINT "stock_zh_a_price_rate_idx_unique" UNIQUE ("code", "t_date", "price");

-- ----------------------------
-- Indexes structure for table stock_zh_a_spot_em
-- ----------------------------
CREATE INDEX "stock_zh_a_hist_daily_t_date_idx_copy5" ON "stock"."stock_zh_a_spot_em" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_spot_em_amount_rate_idx" ON "stock"."stock_zh_a_spot_em" USING btree (
  "amount_rate" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_spot_em_hands_idx" ON "stock"."stock_zh_a_spot_em" USING btree (
  "hands" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_spot_em_t_amount_idx" ON "stock"."stock_zh_a_spot_em" USING btree (
  "t_amount" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_spot_em_time_flag_idx" ON "stock"."stock_zh_a_spot_em" USING btree (
  "time_flag" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_zh_a_spot_em
-- ----------------------------
ALTER TABLE "stock"."stock_zh_a_spot_em" ADD CONSTRAINT "stock_zh_a_spot_em_idx_uniq" UNIQUE ("code", "t_date", "time_flag");

-- ----------------------------
-- Indexes structure for table stock_zh_a_spot_tx
-- ----------------------------
CREATE INDEX "stock_zh_a_spot_tx_code_idx" ON "stock"."stock_zh_a_spot_tx" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_spot_tx_code_t_date_idx" ON "stock"."stock_zh_a_spot_tx" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stock_zh_a_spot_tx
-- ----------------------------
ALTER TABLE "stock"."stock_zh_a_spot_tx" ADD CONSTRAINT "stock_zh_a_spot_tx_pk" PRIMARY KEY ("code", "t_time");

-- ----------------------------
-- Indexes structure for table stock_zh_a_tick_tx
-- ----------------------------
CREATE INDEX "stock_zh_a_tick_tx_code_t_date_idx" ON "stock"."stock_zh_a_tick_tx" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "stock_zh_a_tick_tx_code_type_idx" ON "stock"."stock_zh_a_tick_tx" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "t_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_zh_a_tick_tx
-- ----------------------------
ALTER TABLE "stock"."stock_zh_a_tick_tx" ADD CONSTRAINT "stock_zh_a_tick_tx_code_t_time" UNIQUE ("code", "t_time");

-- ----------------------------
-- Indexes structure for table stock_zt_pool_em
-- ----------------------------
CREATE INDEX "stock_zt_pool_em_t_date_idx" ON "stock"."stock_zt_pool_em" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table stock_zt_pool_em
-- ----------------------------
ALTER TABLE "stock"."stock_zt_pool_em" ADD CONSTRAINT "stock_zt_pool_em_idx_unique" UNIQUE ("code", "t_date");

-- ----------------------------
-- Indexes structure for table tool_trade_date_hist_sina
-- ----------------------------
CREATE UNIQUE INDEX "tool_trade_date_hist_sina1_trade_date_idx" ON "stock"."tool_trade_date_hist_sina" USING btree (
  "t_date" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tool_trade_date_hist_sina_t_date_last_idx" ON "stock"."tool_trade_date_hist_sina" USING btree (
  "t_date_last" "pg_catalog"."int4_ops" ASC NULLS LAST
);
