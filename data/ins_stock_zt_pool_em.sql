-- FUNCTION: td.ins_stock_zt_pool_em(character varying, json)

-- DROP FUNCTION IF EXISTS td.ins_stock_zt_pool_em(character varying, json);

CREATE OR REPLACE FUNCTION td.ins_stock_zt_pool_em(
	_date character varying,
	_data_json json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
begin

insert into td.stock_zt_pool_em(stock_code,name,change,new_price,t_money,market_val_ch,market_val_sum
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
ON CONFLICT(stock_code,t_date)
DO NOTHING;
                                                
END;
$BODY$;

ALTER FUNCTION td.ins_stock_zt_pool_em(character varying, json)
    OWNER TO postgres;
