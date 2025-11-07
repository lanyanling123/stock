-- FUNCTION: td.stat_shape_similary(numeric)

-- DROP FUNCTION IF EXISTS td.stat_shape_similary(numeric);

CREATE OR REPLACE FUNCTION td.stat_shape_similary(
	_val numeric)
    RETURNS TABLE(total integer, day1_cnt integer, day1_per numeric, day1_rate numeric, day3_cnt integer, day3_per numeric, day3_rate numeric, day5_cnt integer, day5_per numeric, day5_rate numeric, day10_cnt integer, day10_per numeric, day10_rate numeric, day20_cnt integer, day20_per numeric, day20_rate numeric, day30_cnt integer, day30_per numeric, day30_rate numeric, day60_cnt integer, day60_per numeric, day60_rate numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare day1_plus numeric :=0;
declare day1_min numeric :=0;
declare day3_plus numeric :=0;
declare day3_min numeric :=0;
declare day5_plus numeric :=0;
declare day5_min numeric :=0;
declare day10_plus numeric :=0;
declare day10_min numeric :=0;
declare day20_plus numeric :=0;
declare day20_min numeric :=0;
declare day30_plus numeric :=0;
declare day30_min numeric :=0;
declare day60_plus numeric :=0;
declare day60_min numeric :=0;
BEGIN

select count(*) INTO total from td.shape_similary where similary > _val;

select count(*)  into day1_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day1 > 0;

select sum(day1)  into day1_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day1 > 0;

select sum(day1)  into day1_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day1 < 0;

select count(*)  into day3_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day3 > 0;

select sum(day3)  into day3_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day3 > 0;

select sum(day3)  into day3_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day3 < 0;

select count(*)  into day5_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day5 > 0;

select sum(day5)  into day5_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day5 > 0;

select sum(day5)  into day5_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day5 < 0;

select count(*)  into day10_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day10 > 0;

select sum(day10)  into day10_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day10 > 0;

select sum(day10)  into day10_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day10 < 0;

select count(*)  into day20_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day20 > 0;

select sum(day20)  into day20_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day20 > 0;

select sum(day20)  into day20_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day20 < 0;

select count(*)  into day30_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day30 > 0;

select sum(day30)  into day30_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day30 > 0;

select sum(day30)  into day30_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day30 < 0;

select count(*)  into day60_cnt from 
(select code,t_date as t_date from td.shape_similary where similary > _val) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day60 > 0;

select sum(day60)  into day60_plus from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day60 > 0;

select sum(day60)  into day60_min from 
(select code,t_date as t_date from td.shape_similary where similary > _val ) a 
join td.stock_change_period b on a.code = b.code and a.t_date = b.t_date 
where day60 < 0;

day1_rate := ROUND(day1_plus/ABS(day1_min),2);
day3_rate := ROUND(day3_plus/ABS(day3_min),2);
day5_rate := ROUND(day5_plus/ABS(day5_min),2);
day10_rate := ROUND(day10_plus/ABS(day10_min),2);
day20_rate := ROUND(day20_plus/ABS(day20_min),2);
day30_rate := ROUND(day30_plus/ABS(day30_min),2);
day60_rate := ROUND(day60_plus/ABS(day60_min),2);

day1_per := ROUND(100 * cast(day1_cnt as numeric)/total,2);
day3_per := ROUND(100 * cast(day3_cnt as numeric)/total,2);
day5_per := ROUND(100 * cast(day5_cnt as numeric)/total,2);
day10_per := ROUND(100 * cast(day10_cnt as numeric)/total,2);
day20_per := ROUND(100 * cast(day20_cnt as numeric)/total,2);
day30_per := ROUND(100 * cast(day30_cnt as numeric)/total,2);
day60_per := ROUND(100 * cast(day60_cnt as numeric)/total,2);

RETURN NEXT;

END;
$BODY$;

ALTER FUNCTION td.stat_shape_similary(numeric)
    OWNER TO postgres;
