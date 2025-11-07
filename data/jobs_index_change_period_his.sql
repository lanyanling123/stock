-- FUNCTION: td.jobs_index_change_period_his(character varying)

-- DROP FUNCTION IF EXISTS td.jobs_index_change_period_his(character varying);

CREATE OR REPLACE FUNCTION td.jobs_index_change_period_his(
	_code character varying)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
-- 计算T+x日累计涨幅
  with cet_per1 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 1 and last_value(close_price) over s <> 0
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 1 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day1)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per1 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day1 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day1,c_time) = (excluded.day1, CURRENT_TIMESTAMP);

-- 计算历史数据的方法
   with cet_per3 as NOT MATERIALIZED(
 								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 3 and last_value(close_price) over s <> 0
 								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
 								else 1000 end as sumchange
 								from td.stock_zh_a_hist where stock_code = _code
 								window s as (partition by stock_code order by t_date desc rows 3 preceding) limit 3000)
  insert into td.stock_change_period (code,t_date,change,day3)
  select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per3 c 
  left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day3 is null and c.sumchange < 1000
  ON CONFLICT (code,t_date) 
  DO UPDATE SET (day3,c_time) = (excluded.day3, CURRENT_TIMESTAMP);
 
  with cet_per5 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 5 and last_value(close_price) over s <> 0
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 5 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day5)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per5 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day5 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day5,c_time) = (excluded.day5, CURRENT_TIMESTAMP);
 
  with cet_per10 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 10 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 10 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day10)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per10 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day10 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day10,c_time) = (excluded.day10, CURRENT_TIMESTAMP);
 
  with cet_per20 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 20 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 20 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day20)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per20 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day20 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day20,c_time) = (excluded.day20, CURRENT_TIMESTAMP);
 
  with cet_per30 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 30 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 30 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day30)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per30 c  
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day30 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day30,c_time) = (excluded.day30, CURRENT_TIMESTAMP);
 
  with cet_per60 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 60 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 60 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day60)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per60 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day60 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day60,c_time) = (excluded.day60, CURRENT_TIMESTAMP);
 
  with cet_per90 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 90 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 90 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day90)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per90 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day90 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day90,c_time) = (excluded.day90, CURRENT_TIMESTAMP);
 
  with cet_per120 as NOT MATERIALIZED(
								select stock_code as code,t_date,price_change_percentage as change,case  when count(*) over s > 120 and last_value(close_price) over s <> 0 
								then cast(100 * ((first_value(close_price) over s - last_value(close_price) over s)/last_value(close_price) over s) as decimal(18,2)) 
								else 1000 end as sumchange 
								from td.stock_zh_a_hist where stock_code = _code
								window s as (partition by stock_code order by t_date desc rows 120 preceding) limit 3000)
 insert into td.stock_change_period (code,t_date,change,day120)
 select c.code,c.t_date,c.change,c.sumchange as sumchange from cet_per120 c 
 left join td.stock_change_period d on c.code = d.code and c.t_date = d.t_date where d.day120 is null and c.sumchange < 1000
 ON CONFLICT (code,t_date) 
 DO UPDATE SET (day120,c_time) = (excluded.day120, CURRENT_TIMESTAMP);
 
END;
$BODY$;

ALTER FUNCTION td.jobs_index_change_period_his(character varying)
    OWNER TO postgres;
