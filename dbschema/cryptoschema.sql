-- MySQL dump 10.13  Distrib 5.5.50, for Linux (x86_64)
--
-- Host: localhost    Database: cryptomaster
-- ------------------------------------------------------
-- Server version	5.5.50

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `secpricert`
--

DROP TABLE IF EXISTS `secpricert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secpricert` (
  `ticker` varchar(8) NOT NULL,
  `price_date` date NOT NULL,
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `rtq` float NOT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL,
  `gain` float DEFAULT '0',
  `loss` float DEFAULT '0',
  `avg_gain` float DEFAULT NULL,
  `avg_loss` float DEFAULT NULL,
  `rsi` float DEFAULT NULL,
  `rsi_14` float DEFAULT NULL,
  `cr_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `ticker_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`seq`),
  KEY `ticker_idx` (`ticker`),
  KEY `ticker_date` (`ticker`,`price_date`,`seq`),
  KEY `ticker_id_ix` (`ticker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29035 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermaster`
--

DROP TABLE IF EXISTS `tickermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermaster` (
  `ticker_id` int(11) NOT NULL AUTO_INCREMENT,
  `curr_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `pop_ord` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ticker_id`),
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_idx` (`ticker`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerrtq`
--

DROP TABLE IF EXISTS `tickerrtq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerrtq` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `rtq` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL,
  `gain` float DEFAULT '0',
  `loss` float DEFAULT '0',
  `avg_gain` float DEFAULT NULL,
  `avg_loss` float DEFAULT NULL,
  `rsi` float DEFAULT NULL,
  `rsi_14` float DEFAULT NULL,
  PRIMARY KEY (`seq`),
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_date` (`ticker_id`,`price_date`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-01 22:29:48
