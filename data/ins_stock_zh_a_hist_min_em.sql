-- FUNCTION: td.ins_stock_zh_a_hist_min_em(integer, character varying, integer, json)

-- DROP FUNCTION IF EXISTS td.ins_stock_zh_a_hist_min_em(integer, character varying, integer, json);

CREATE OR REPLACE FUNCTION td.ins_stock_zh_a_hist_min_em(
	_tdate integer,
	_symbol character varying,
	_period integer,
	_data_json json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
BEGIN

insert into td.stock_zh_a_hist_min_em(stock_code,t_date,t_time,open,close,high,low,volume,turnover,new_price,swing,hands,period)
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
ON CONFLICT(stock_code,t_date,t_time,period)
DO NOTHING;

END;
$BODY$;

ALTER FUNCTION td.ins_stock_zh_a_hist_min_em(integer, character varying, integer, json)
    OWNER TO postgres;
