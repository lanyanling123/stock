-- FUNCTION: td.ins_stock_board_industry_index_ths(character varying, integer, json)

-- DROP FUNCTION IF EXISTS td.ins_stock_board_industry_index_ths(character varying, integer, json);

CREATE OR REPLACE FUNCTION td.ins_stock_board_industry_index_ths(
	_symbol character varying,
	_time_flag integer,
	_data_json json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
BEGIN

insert into td.stock_board_industry_index_ths(code,t_date,open,close,high,low,volume,turnover,time_flag)
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
$BODY$;

ALTER FUNCTION td.ins_stock_board_industry_index_ths(character varying, integer, json)
    OWNER TO postgres;
