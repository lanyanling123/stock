-- FUNCTION: td.ins_tool_trade_date_hist_sina(json)

-- DROP FUNCTION IF EXISTS td.ins_tool_trade_date_hist_sina(json);

CREATE OR REPLACE FUNCTION td.ins_tool_trade_date_hist_sina(
	json)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare row_cnt int :=0;
BEGIN

insert into td.tool_trade_date_hist_sina(t_date)
select cast(to_char(x.trade_date, 'YYYYMMDD') as int) from json_to_recordset($1) x 
(
trade_date timestamp
)
ON CONFLICT(t_date)
DO NOTHING;

END;
$BODY$;

ALTER FUNCTION td.ins_tool_trade_date_hist_sina(json)
    OWNER TO postgres;
