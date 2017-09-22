CREATE DATABASE tickmaster; 

use tickmaster;

CREATE TABLE tickmaster.secpricert (
  ticker varchar(8) NOT NULL,
  price_date date NOT NULL,
  seq int(11) NOT NULL AUTO_INCREMENT,
  rtq float NOT NULL,
  high_price_14 float DEFAULT NULL,
  low_price_14 float DEFAULT NULL,
  stc_osci_14 float DEFAULT NULL,
  sma_3_stc_osci_14 float DEFAULT NULL,
  sma_3_3_stc_osci_14 float DEFAULT NULL,
  dma_20 float DEFAULT NULL,
  dma_20_sd float DEFAULT NULL,
  gain float DEFAULT '0',
  loss float DEFAULT '0',
  avg_gain float DEFAULT NULL,
  avg_loss float DEFAULT NULL,
  rsi float DEFAULT NULL,
  rsi_14 float DEFAULT NULL,
  PRIMARY KEY (seq),
  KEY ticker_idx (ticker),
  KEY ticker_date (ticker,price_date,seq)
);

