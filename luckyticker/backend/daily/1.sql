select b.ticker_id,b.ticker,b.comp_name,b.sector,b.industry from tickermaster b,tickerrtq7 a where a.price_date = '2018-01-19' and a.ema_diff_5_35 > a.ema_macd_5 and a.seq = 356906328 and a.ticker_id = b.ticker_id and exists (select 1 from tickerrtq7 p where p.ticker_id = a.ticker_id and p.seq = 356906204 and p.ema_diff_5_35 < p.ema_macd_5) order by b.ticker asc;

