-- FUNCTION: td.ins_stock_changes_em(character varying, json)

-- DROP FUNCTION IF EXISTS td.ins_stock_changes_em(character varying, json);

CREATE OR REPLACE FUNCTION td.ins_stock_changes_em(
	_symbol character varying,
	data_json json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
BEGIN

insert into td.stock_changes_em(stock_code,t_date,t_time,name,industry,info,t_type)
select x.代码,cast(to_char(CURRENT_DATE, 'YYYYMMDD') as int),cast(CURRENT_DATE || ' ' || x.时间 as TIMESTAMP),x.名称,x.板块,x.相关信息,_symbol
 from json_to_recordset(data_json) x 
(
代码 VARCHAR,
时间 VARCHAR,
名称 VARCHAR,
板块 VARCHAR,
相关信息 VARCHAR
)
ON CONFLICT(stock_code,t_time)
DO NOTHING;

END;
$BODY$;

ALTER FUNCTION td.ins_stock_changes_em(character varying, json)
    OWNER TO postgres;
