-- FUNCTION: td.ins_stock_zh_a_hist(character varying, character varying, character varying, json)

-- DROP FUNCTION IF EXISTS td.ins_stock_zh_a_hist(character varying, character varying, character varying, json);

CREATE OR REPLACE FUNCTION td.ins_stock_zh_a_hist(
	_symbol character varying,
	_stock_name character varying,
	_period character varying,
	_data_json json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
BEGIN

insert into td.stock_zh_a_hist(stock_code,t_date,open_price,close_price,high_price
,low_price,volume,turnover,amplitude,price_change_percentage
,price_change,turnover_rate,stock_name,period)
select _symbol,cast(to_char(x.日期, 'YYYYMMDD') as int),x.开盘,x.收盘,x.最高
,x.最低,x.成交量,x.成交额,x.振幅,x.涨跌幅
,x.涨跌额,x.换手率,_stock_name,_period
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
换手率 numeric(32,2)
)
ON CONFLICT(stock_code,t_date,period)
DO NOTHING;

END;
$BODY$;

ALTER FUNCTION td.ins_stock_zh_a_hist(character varying, character varying, character varying, json)
    OWNER TO postgres;
