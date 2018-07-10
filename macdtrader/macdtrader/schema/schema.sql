CREATE DATABASE tickmaster; 

use tickmaster;

CREATE TABLE securitymaster (
  ticker varchar(8) NOT NULL,
  comp_name varchar(200) DEFAULT NULL,
  sector varchar(50) DEFAULT NULL,
  industry varchar(50) DEFAULT NULL,
  signal_process_flag char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (ticker))

 CREATE TABLE secpricelast (
  ticker varchar(8) NOT NULL,
  price_date date NOT NULL,
  close_price float NOT NULL,
  ema_12 float DEFAULT NULL,
  ema_26 float DEFAULT NULL,
  ema_macd_9 float DEFAULT NULL,
  ema_diff float DEFAULT NULL,
  ema_5 float DEFAULT NULL,
  ema_35 float DEFAULT NULL,
  ema_macd_5 float DEFAULT NULL,
  ema_diff_5_35 float DEFAULT NULL,
  high_price float DEFAULT NULL,
  low_price float DEFAULT NULL,
  PRIMARY KEY (ticker,price_date),
  KEY ticker_idx (ticker))
