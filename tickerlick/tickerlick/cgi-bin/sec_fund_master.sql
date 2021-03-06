CREATE TABLE sec_fund_master (
  ticker_id int(11) NOT NULL,
  prevclose float DEFAULT NULL,
  dividend  float DEFAULT NULL, 
  yield float DEFAULT NULL,
  yearlow float DEFAULT NULL,
  yearhigh float DEFAULT NULL,
  pe float DEFAULT NULL,
  dma10 float DEFAULT NULL,
  dma200 float DEFAULT NULL,
  dma50 float DEFAULT NULL,
  eps float DEFAULT NULL,
  ytargetest float DEFAULT NULL,
  lasttrade float DEFAULT NULL,
  marketcap float DEFAULT NULL,
  dma50diff float DEFAULT NULL,
  dma10diff float DEFAULT NULL,
  dma200diff float DEFAULT NULL,
  nav float DEFAULT NULL,
  PRIMARY KEY (ticker_id)
);
