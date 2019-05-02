-- MySQL dump 10.13  Distrib 5.5.50, for Linux (x86_64)
--
-- Host: localhost    Database: tickmaster
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
-- Table structure for table `Persons`
--

DROP TABLE IF EXISTS `Persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Persons` (
  `FirstName` char(30) DEFAULT NULL,
  `LastName` char(30) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aapl`
--

DROP TABLE IF EXISTS `aapl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aapl` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `aapl2018view`
--

DROP TABLE IF EXISTS `aapl2018view`;
/*!50001 DROP VIEW IF EXISTS `aapl2018view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `aapl2018view` (
  `ticker_id` tinyint NOT NULL,
  `price_date` tinyint NOT NULL,
  `close_price` tinyint NOT NULL,
  `dma_10` tinyint NOT NULL,
  `dma_50` tinyint NOT NULL,
  `dma_200` tinyint NOT NULL,
  `ema_12` tinyint NOT NULL,
  `ema_26` tinyint NOT NULL,
  `ema_macd_9` tinyint NOT NULL,
  `ema_diff` tinyint NOT NULL,
  `ema_5` tinyint NOT NULL,
  `ema_35` tinyint NOT NULL,
  `ema_macd_5` tinyint NOT NULL,
  `ema_diff_5_35` tinyint NOT NULL,
  `high_price_14` tinyint NOT NULL,
  `low_price_14` tinyint NOT NULL,
  `stc_osci_14` tinyint NOT NULL,
  `sma_3_stc_osci_14` tinyint NOT NULL,
  `high_price` tinyint NOT NULL,
  `low_price` tinyint NOT NULL,
  `sma_3_3_stc_osci_14` tinyint NOT NULL,
  `dma_20` tinyint NOT NULL,
  `dma_20_sd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permissi_content_type_id_2f476e4b_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_master`
--

DROP TABLE IF EXISTS `client_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_master` (
  `user_id` int(11) NOT NULL,
  `port_id` int(11) NOT NULL,
  `port_investment` float NOT NULL,
  `max_per_holiding` float DEFAULT NULL,
  `current_value` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(30) NOT NULL,
  `first_name` varchar(25) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `expired_date` date NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `dist_tick`
--

DROP TABLE IF EXISTS `dist_tick`;
/*!50001 DROP VIEW IF EXISTS `dist_tick`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dist_tick` (
  `ticker` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dividend_master`
--

DROP TABLE IF EXISTS `dividend_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dividend_master` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `x_date` date NOT NULL,
  `amt` float DEFAULT NULL,
  KEY `ticker_id_x_date_idx` (`ticker_id`,`x_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `earnings_master`
--

DROP TABLE IF EXISTS `earnings_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `earnings_master` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `earnings_date` date NOT NULL,
  PRIMARY KEY (`ticker_id`,`earnings_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `holdings`
--

DROP TABLE IF EXISTS `holdings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `holdings` (
  `user_id` int(11) NOT NULL,
  `port_id` int(11) NOT NULL,
  `ticker_id` int(11) NOT NULL,
  `no_of_shares` int(11) NOT NULL,
  `type` char(1) NOT NULL DEFAULT 'L'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ipomaster`
--

DROP TABLE IF EXISTS `ipomaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipomaster` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `comp_name` varchar(75) NOT NULL,
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`ticker`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l100`
--

DROP TABLE IF EXISTS `l100`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l100` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(75) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l150`
--

DROP TABLE IF EXISTS `l150`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l150` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(75) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `missingema`
--

DROP TABLE IF EXISTS `missingema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `missingema` (
  `ticker_id` int(11) NOT NULL,
  `close_price` float NOT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  KEY `tickid_idx` (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portfolio_master`
--

DROP TABLE IF EXISTS `portfolio_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portfolio_master` (
  `port_id` int(4) NOT NULL AUTO_INCREMENT,
  `port_name` char(200) NOT NULL,
  `port_description` varchar(512) NOT NULL,
  PRIMARY KEY (`port_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `amount` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_details`
--

DROP TABLE IF EXISTS `product_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_details` (
  `id` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned DEFAULT NULL,
  `exist` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rate_temp`
--

DROP TABLE IF EXISTS `rate_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_temp` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rate_temp2`
--

DROP TABLE IF EXISTS `rate_temp2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_temp2` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rate_temp3`
--

DROP TABLE IF EXISTS `rate_temp3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_temp3` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rate_temp4`
--

DROP TABLE IF EXISTS `rate_temp4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_temp4` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL,
  UNIQUE KEY `ticker_id` (`ticker_id`,`brokerage_name`,`updown`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rate_temp_all`
--

DROP TABLE IF EXISTS `rate_temp_all`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rate_temp_all` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rating_master`
--

DROP TABLE IF EXISTS `rating_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_master` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL,
  KEY `ticker_id_idx` (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rating_master1`
--

DROP TABLE IF EXISTS `rating_master1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_master1` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rating_master_hitory`
--

DROP TABLE IF EXISTS `rating_master_hitory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_master_hitory` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `brokerage_name` varchar(50) NOT NULL,
  `rating_date` date NOT NULL,
  `updown` char(1) NOT NULL,
  `rating_from` varchar(25) DEFAULT NULL,
  `rating_to` varchar(25) DEFAULT NULL,
  `price_from` float DEFAULT NULL,
  `price_to` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report` (
  `ticker_id` int(11) NOT NULL,
  `report_flag` varchar(3) DEFAULT NULL,
  `val` float DEFAULT NULL,
  KEY `report_flag_idx` (`report_flag`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reporthistory`
--

DROP TABLE IF EXISTS `reporthistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reporthistory` (
  `ticker_id` int(11) NOT NULL,
  `report_flag` varchar(3) NOT NULL,
  `val` float DEFAULT NULL,
  `report_date` date NOT NULL,
  KEY `report_flag_date_idx` (`report_date`,`report_flag`),
  KEY `ticker_id_report_date_idx` (`ticker_id`,`report_date`),
  KEY `ticker_id_idx` (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reportmaster`
--

DROP TABLE IF EXISTS `reportmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reportmaster` (
  `reportid` int(11) NOT NULL DEFAULT '0',
  `report_name` varchar(255) NOT NULL,
  `report_desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`reportid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rtq_proc_master`
--

DROP TABLE IF EXISTS `rtq_proc_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtq_proc_master` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `proc_ord_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `indx_proc_ord_id` (`proc_ord_id`),
  KEY `indx_tick` (`ticker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=514 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rtq_proc_master1`
--

DROP TABLE IF EXISTS `rtq_proc_master1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtq_proc_master1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `proc_ord_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `indx_proc_ord_id` (`proc_ord_id`),
  KEY `indx_tick` (`ticker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rtq_proc_master_back`
--

DROP TABLE IF EXISTS `rtq_proc_master_back`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtq_proc_master_back` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `proc_ord_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rtq_proc_master_new`
--

DROP TABLE IF EXISTS `rtq_proc_master_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtq_proc_master_new` (
  `ticker_id` int(11) NOT NULL,
  `ticke` varchar(8) NOT NULL,
  `proc_ord_id` int(11) NOT NULL AUTO_INCREMENT,
  KEY `indx_proc_ord_id` (`proc_ord_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sec_filing`
--

DROP TABLE IF EXISTS `sec_filing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sec_filing` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `file_type` varchar(16) NOT NULL,
  `file_url` varchar(200) NOT NULL,
  `file_name` varchar(30) NOT NULL,
  `file_date` date NOT NULL,
  UNIQUE KEY `fname_uni` (`file_name`),
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_idx` (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sec_fund_anal`
--

DROP TABLE IF EXISTS `sec_fund_anal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sec_fund_anal` (
  `ticker_id` int(11) NOT NULL,
  `guru` varchar(25) NOT NULL,
  `attrib` varchar(100) DEFAULT NULL,
  `val` varchar(10) DEFAULT NULL,
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `guru_idx` (`guru`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sec_fund_anal_sp`
--

DROP TABLE IF EXISTS `sec_fund_anal_sp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sec_fund_anal_sp` (
  `ticker_id` int(11) NOT NULL,
  `guru` varchar(25) NOT NULL,
  `attrib` varchar(100) DEFAULT NULL,
  `val` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sec_fund_master`
--

DROP TABLE IF EXISTS `sec_fund_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sec_fund_master` (
  `ticker_id` int(11) NOT NULL,
  `prevclose` float DEFAULT NULL,
  `dividend` float DEFAULT NULL,
  `yield` float DEFAULT NULL,
  `yearlow` float DEFAULT NULL,
  `yearhigh` float DEFAULT NULL,
  `pe` float DEFAULT NULL,
  `dma10` float DEFAULT NULL,
  `dma200` float DEFAULT NULL,
  `dma50` float DEFAULT NULL,
  `eps` float DEFAULT NULL,
  `ytargetest` float DEFAULT NULL,
  `lasttrade` float DEFAULT NULL,
  `marketcap` float DEFAULT NULL,
  `dma50diff` float DEFAULT NULL,
  `dma10diff` float DEFAULT NULL,
  `dma200diff` float DEFAULT NULL,
  `nav` float DEFAULT NULL,
  `UpdateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ticker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sec_holding`
--

DROP TABLE IF EXISTS `sec_holding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sec_holding` (
  `usermail` varchar(100) NOT NULL,
  `ticker_id` int(11) NOT NULL,
  `entry_date` date NOT NULL,
  `exit_date` date DEFAULT NULL,
  `active_flag` char(1) NOT NULL DEFAULT 'Y',
  `description` varchar(100) DEFAULT NULL,
  `option_code` char(4) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `secmaster`
--

DROP TABLE IF EXISTS `secmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secmaster` (
  `ticker_id` int(11) NOT NULL,
  `pegratio` varchar(25) DEFAULT NULL,
  `operatingcashflow` varchar(25) DEFAULT NULL,
  `sharesoutstanding` varchar(25) DEFAULT NULL,
  `divyield` float DEFAULT NULL,
  `wkrange` varchar(25) DEFAULT NULL,
  `mostrecentquarter` varchar(25) DEFAULT NULL,
  `dma10diffper` varchar(25) DEFAULT NULL,
  `qtrlyrevenuegrowth` varchar(25) DEFAULT NULL,
  `marketcap` varchar(25) DEFAULT NULL,
  `weekchange` varchar(25) DEFAULT NULL,
  `prevclose` float DEFAULT NULL,
  `dma50diffper` varchar(25) DEFAULT NULL,
  `difflowstat` varchar(25) DEFAULT NULL,
  `fiscalyearends` varchar(25) DEFAULT NULL,
  `lasttrade` float DEFAULT NULL,
  `payoutratio` varchar(25) DEFAULT NULL,
  `enterprisevalueebitda` varchar(25) DEFAULT NULL,
  `dma50stat` varchar(25) DEFAULT NULL,
  `grossprofit` varchar(25) DEFAULT NULL,
  `perdifflow` varchar(25) DEFAULT NULL,
  `trailingpe` float DEFAULT NULL,
  `enterprisevalue` varchar(25) DEFAULT NULL,
  `dma200` varchar(25) DEFAULT NULL,
  `totalcashpershare` float DEFAULT NULL,
  `operatingmargin` float DEFAULT NULL,
  `pricesales` float DEFAULT NULL,
  `pricestat` float DEFAULT NULL,
  `diffhighstat` varchar(25) DEFAULT NULL,
  `revenuepershare` float DEFAULT NULL,
  `pricediffper` varchar(25) DEFAULT NULL,
  `beta` float DEFAULT NULL,
  `weeklow` float DEFAULT NULL,
  `dma10stat` varchar(25) DEFAULT NULL,
  `netincomeavltocommon` varchar(25) DEFAULT NULL,
  `sharesshort` varchar(25) DEFAULT NULL,
  `pe` float DEFAULT NULL,
  `qtrlyearningsgrowth` varchar(25) DEFAULT NULL,
  `enterprisevaluerevenue` varchar(25) DEFAULT NULL,
  `pricebook` float DEFAULT NULL,
  `sp50052weekchange` varchar(25) DEFAULT NULL,
  `totaldebtequity` varchar(25) DEFAULT NULL,
  `dma200stat` varchar(25) DEFAULT NULL,
  `nav` float DEFAULT NULL,
  `dma50diff` varchar(25) DEFAULT NULL,
  `returnonassets` varchar(25) DEFAULT NULL,
  `dilutedeps` varchar(25) DEFAULT NULL,
  `pricediff` varchar(25) DEFAULT NULL,
  `revenue` varchar(25) DEFAULT NULL,
  `exdividenddate` varchar(25) DEFAULT NULL,
  `returnonequity` varchar(25) DEFAULT NULL,
  `dma10diff` varchar(25) DEFAULT NULL,
  `difflow` varchar(25) DEFAULT NULL,
  `totaldebt` varchar(25) DEFAULT NULL,
  `class` varchar(25) DEFAULT NULL,
  `leveredfreecashflow` varchar(25) DEFAULT NULL,
  `yearlow` float DEFAULT NULL,
  `dma200diffper` varchar(25) DEFAULT NULL,
  `weekhigh` float DEFAULT NULL,
  `dma10` varchar(25) DEFAULT NULL,
  `forwardpe` float DEFAULT NULL,
  `dma50` varchar(25) DEFAULT NULL,
  `dma200diff` varchar(25) DEFAULT NULL,
  `ytargetest` float DEFAULT NULL,
  `ebitda` varchar(25) DEFAULT NULL,
  `yearhigh` float DEFAULT NULL,
  `twohundreddaymovingaverage` varchar(25) DEFAULT NULL,
  `currentratio` float DEFAULT NULL,
  `eps` float DEFAULT NULL,
  `diffhigh` varchar(25) DEFAULT NULL,
  `bookvaluepershare` varchar(25) DEFAULT NULL,
  `perdiffhigh` varchar(25) DEFAULT NULL,
  `fiftydaymovingaverage` varchar(25) DEFAULT NULL,
  `totalcash` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `secpricelast`
--

DROP TABLE IF EXISTS `secpricelast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secpricelast` (
  `ticker` varchar(8) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  PRIMARY KEY (`ticker`,`price_date`),
  KEY `ticker_idx` (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=2098391 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `securitymaster`
--

DROP TABLE IF EXISTS `securitymaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `securitymaster` (
  `ticker` varchar(8) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `signal_process_flag` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `south_migrationhistory`
--

DROP TABLE IF EXISTS `south_migrationhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `splitmaster`
--

DROP TABLE IF EXISTS `splitmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `splitmaster` (
  `ticker_id` int(11) NOT NULL,
  `split_date` date NOT NULL,
  `split_ratio` float NOT NULL,
  `processed` char(1) NOT NULL DEFAULT 'N',
  `ticker` varchar(8) NOT NULL,
  UNIQUE KEY `tickersplit` (`ticker_id`,`split_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ssss`
--

DROP TABLE IF EXISTS `ssss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ssss` (
  `ticker` varchar(8) NOT NULL,
  `d1` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `d2` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stock_volatility_daily`
--

DROP TABLE IF EXISTS `stock_volatility_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stock_volatility_daily` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `squared20` double DEFAULT NULL,
  `sd20` float DEFAULT NULL,
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_date_idx` (`ticker_id`,`price_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test2`
--

DROP TABLE IF EXISTS `test2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test2` (
  `col1` varchar(20) DEFAULT NULL,
  `col2` varchar(40) DEFAULT NULL,
  `col3` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermaster`
--

DROP TABLE IF EXISTS `tickermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermaster` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'N',
  `tflag2` char(1) DEFAULT 'N',
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `etf_flag` char(1) NOT NULL DEFAULT 'N',
  `tflag3` char(1) DEFAULT 'N',
  PRIMARY KEY (`ticker_id`),
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_idx` (`ticker`),
  KEY `tflag_indx` (`tflag`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermasterbak`
--

DROP TABLE IF EXISTS `tickermasterbak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermasterbak` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(75) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermasterdupe`
--

DROP TABLE IF EXISTS `tickermasterdupe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermasterdupe` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'N',
  `tflag2` char(1) DEFAULT 'N',
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `etf_flag` char(1) NOT NULL DEFAULT 'N',
  `tflag3` char(1) DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermasteretf`
--

DROP TABLE IF EXISTS `tickermasteretf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermasteretf` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'N',
  `tflag2` char(1) DEFAULT 'N',
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `etf_flag` char(1) NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickermasterno`
--

DROP TABLE IF EXISTS `tickermasterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickermasterno` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'N',
  `tflag2` char(1) DEFAULT 'N',
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `etf_flag` char(1) NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tickerob`
--

DROP TABLE IF EXISTS `tickerob`;
/*!50001 DROP VIEW IF EXISTS `tickerob`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tickerob` (
  `ticker` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tickeros`
--

DROP TABLE IF EXISTS `tickeros`;
/*!50001 DROP VIEW IF EXISTS `tickeros`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tickeros` (
  `ticker` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tickerprice`
--

DROP TABLE IF EXISTS `tickerprice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL,
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_date` (`ticker_id`,`price_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_11201`
--

DROP TABLE IF EXISTS `tickerprice_11201`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_11201` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `ema_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_2012`
--

DROP TABLE IF EXISTS `tickerprice_2012`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_2012` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `ema_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_2013`
--

DROP TABLE IF EXISTS `tickerprice_2013`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_2013` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `ema_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_20151231`
--

DROP TABLE IF EXISTS `tickerprice_20151231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_20151231` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_2016`
--

DROP TABLE IF EXISTS `tickerprice_2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_2016` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_2017`
--

DROP TABLE IF EXISTS `tickerprice_2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_2017` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerprice_audit`
--

DROP TABLE IF EXISTS `tickerprice_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprice_audit` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` int(11) NOT NULL,
  `ticker` char(8) NOT NULL,
  `cur_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerpricefun`
--

DROP TABLE IF EXISTS `tickerpricefun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerpricefun` (
  `YearLow` float DEFAULT NULL,
  `OneyrTargetPrice` float DEFAULT NULL,
  `DividendShare` float DEFAULT NULL,
  `ChangeFromFiftydayMA` float DEFAULT NULL,
  `DaysLow` float DEFAULT NULL,
  `FiftydayMA` float DEFAULT NULL,
  `EarningsShare` float DEFAULT NULL,
  `LastTradePrice` float DEFAULT NULL,
  `YearHigh` float DEFAULT NULL,
  `LastTradeDate` date DEFAULT NULL,
  `Symbol` varchar(16) NOT NULL,
  `PreviousClose` float DEFAULT NULL,
  `Volume` float DEFAULT NULL,
  `PERatio` float DEFAULT NULL,
  `MarketCap` float DEFAULT NULL,
  `Name` varchar(200) DEFAULT NULL,
  `PercentChangeFromTwoHundreddayMA` float DEFAULT NULL,
  `DividendPayDate` date DEFAULT NULL,
  `ChangeFromYearHigh` float DEFAULT NULL,
  `PercentChangeFromFiftydayMA` float DEFAULT NULL,
  `ChangeFromTwoHundreddayMA` float DEFAULT NULL,
  `DaysHigh` float DEFAULT NULL,
  `PercentChangeFromYearLow` float DEFAULT NULL,
  `PercentChangeFromYearHigh` float DEFAULT NULL,
  `DividendYield` float DEFAULT NULL,
  `ChangeFromYearLow` float DEFAULT NULL,
  `ExDividendDate` date DEFAULT NULL,
  `TwoHundreddayMA` float DEFAULT NULL,
  `Open` float DEFAULT NULL,
  PRIMARY KEY (`Symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerpricersi`
--

DROP TABLE IF EXISTS `tickerpricersi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerpricersi` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `gain` float DEFAULT '0',
  `loss` float DEFAULT '0',
  `avg_gain` float DEFAULT NULL,
  `avg_loss` float DEFAULT NULL,
  `rsi` float DEFAULT NULL,
  `rsi_14` float DEFAULT NULL,
  `rsistoch_14` float DEFAULT NULL,
  PRIMARY KEY (`ticker_id`,`price_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerpricersi_20151231`
--

DROP TABLE IF EXISTS `tickerpricersi_20151231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerpricersi_20151231` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `gain` float DEFAULT '0',
  `loss` float DEFAULT '0',
  `avg_gain` float DEFAULT NULL,
  `avg_loss` float DEFAULT NULL,
  `rsi` float DEFAULT NULL,
  `rsi_14` float DEFAULT NULL,
  `rsistoch_14` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerpricetest`
--

DROP TABLE IF EXISTS `tickerpricetest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerpricetest` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `cur_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger before_price_update 
   before update on tickerpricetest  
     for each row 
       begin 
         insert into tickerprice_audit set ticker_id = OLD.ticker_id, price_date = OLD.price_date, close_price = OLD.close_price, ticker  = OLD.ticker,                cur_date = NOW();
       end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tickerprofile`
--

DROP TABLE IF EXISTS `tickerprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerprofile` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(50) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  PRIMARY KEY (`ticker_id`),
  KEY `ticker_id_idx` (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerrtq6`
--

DROP TABLE IF EXISTS `tickerrtq6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerrtq6` (
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

--
-- Table structure for table `tickerrtq7`
--

DROP TABLE IF EXISTS `tickerrtq7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerrtq7` (
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
) ENGINE=InnoDB AUTO_INCREMENT=356917599 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickerrtqcpp`
--

DROP TABLE IF EXISTS `tickerrtqcpp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickerrtqcpp` (
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickprice`
--

DROP TABLE IF EXISTS `tickprice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickprice` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `ema_3_stc_osci_14` float DEFAULT NULL,
  KEY `ticker_id_idx` (`ticker_id`),
  KEY `ticker_date` (`ticker_id`,`price_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickshort`
--

DROP TABLE IF EXISTS `tickshort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickshort` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(75) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  KEY `ticker_idx` (`ticker`),
  KEY `ticker_id` (`ticker_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trade_master`
--

DROP TABLE IF EXISTS `trade_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_master` (
  `user_id` int(11) NOT NULL,
  `port_id` int(11) NOT NULL,
  `ticker_id` int(11) NOT NULL,
  `no_of_shares` int(11) NOT NULL,
  `type` char(1) NOT NULL,
  `trade_date` date NOT NULL,
  `trade_time` datetime NOT NULL,
  `value` float NOT NULL,
  `pos_status` char(1) NOT NULL,
  `sec_price` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trade_signal_seq`
--

DROP TABLE IF EXISTS `trade_signal_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_signal_seq` (
  `seq` int(11) NOT NULL DEFAULT '0',
  `signal` char(4) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `processed` char(1) DEFAULT 'N',
  `quotetime` datetime NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trade_signal_seq_back`
--

DROP TABLE IF EXISTS `trade_signal_seq_back`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trade_signal_seq_back` (
  `seq` int(11) NOT NULL DEFAULT '0',
  `signal1` char(4) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `processed` char(1) DEFAULT 'N',
  `quotetime` datetime NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttt`
--

DROP TABLE IF EXISTS `ttt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ttt` (
  `a` int(11) NOT NULL AUTO_INCREMENT,
  `b` varchar(8) DEFAULT 'ok',
  `c` varchar(8) NOT NULL,
  PRIMARY KEY (`a`),
  KEY `c` (`c`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tut1`
--

DROP TABLE IF EXISTS `tut1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tut1` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'Y',
  `sector` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ticker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tut2`
--

DROP TABLE IF EXISTS `tut2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tut2` (
  `ticker_id` int(11) NOT NULL,
  `comp_name` varchar(200) DEFAULT NULL,
  `ticker` varchar(8) NOT NULL,
  `sector` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'N',
  `tflag2` char(1) DEFAULT 'N',
  `price_flag` char(1) NOT NULL DEFAULT 'N',
  `etf_flag` char(1) NOT NULL DEFAULT 'N',
  `tflag3` char(1) DEFAULT 'N',
  PRIMARY KEY (`ticker_id`),
  UNIQUE KEY `ticker` (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tut3`
--

DROP TABLE IF EXISTS `tut3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tut3` (
  `ticker_id` int(11) NOT NULL,
  `ticker` varchar(8) NOT NULL,
  `tflag` char(1) NOT NULL DEFAULT 'Y',
  `sector` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ticker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tutprice1`
--

DROP TABLE IF EXISTS `tutprice1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutprice1` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `dma_50` float DEFAULT NULL,
  `dma_200` float DEFAULT NULL,
  `ema_12` float DEFAULT NULL,
  `ema_26` float DEFAULT NULL,
  `ema_macd_9` float DEFAULT NULL,
  `ema_diff` float DEFAULT NULL,
  `ema_5` float DEFAULT NULL,
  `ema_35` float DEFAULT NULL,
  `ema_macd_5` float DEFAULT NULL,
  `ema_diff_5_35` float DEFAULT NULL,
  `high_price_14` float DEFAULT NULL,
  `low_price_14` float DEFAULT NULL,
  `stc_osci_14` float DEFAULT NULL,
  `sma_3_stc_osci_14` float DEFAULT NULL,
  `high_price` float DEFAULT NULL,
  `low_price` float DEFAULT NULL,
  `sma_3_3_stc_osci_14` float DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `dma_20_sd` float DEFAULT NULL,
  PRIMARY KEY (`ticker_id`,`price_date`),
  CONSTRAINT `ticker_id_fk` FOREIGN KEY (`ticker_id`) REFERENCES `tut1` (`ticker_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usermaster`
--

DROP TABLE IF EXISTS `usermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usermaster` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `email` varchar(64) NOT NULL,
  `phone_number` varchar(16) DEFAULT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(32) NOT NULL,
  `confirmcode` varchar(32) NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `username_unique` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usermaster_audit`
--

DROP TABLE IF EXISTS `usermaster_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usermaster_audit` (
  `username` varchar(30) NOT NULL,
  `created_date` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userreport`
--

DROP TABLE IF EXISTS `userreport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userreport` (
  `usermail` varchar(64) NOT NULL,
  `report_code` char(3) NOT NULL,
  `subscription_flag` char(1) DEFAULT 'Y',
  KEY `indx_usermail` (`usermail`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `view_user_report`
--

DROP TABLE IF EXISTS `view_user_report`;
/*!50001 DROP VIEW IF EXISTS `view_user_report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_user_report` (
  `username` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `report_code` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voltemp`
--

DROP TABLE IF EXISTS `voltemp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voltemp` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `squared10` double DEFAULT NULL,
  `squared20` double DEFAULT NULL,
  `sd10` float DEFAULT NULL,
  `sd20` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `voltemp1`
--

DROP TABLE IF EXISTS `voltemp1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voltemp1` (
  `ticker_id` int(11) NOT NULL,
  `price_date` date NOT NULL,
  `close_price` float NOT NULL,
  `dma_10` float DEFAULT NULL,
  `squared10` double DEFAULT NULL,
  `dma_20` float DEFAULT NULL,
  `squared20` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `voltemprtq`
--

DROP TABLE IF EXISTS `voltemprtq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voltemprtq` (
  `ticker_id` int(11) NOT NULL,
  `seq` int(11) NOT NULL DEFAULT '0',
  `rtq` float NOT NULL,
  `dma_20` float DEFAULT NULL,
  `squared20` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `aapl2018view`
--

/*!50001 DROP TABLE IF EXISTS `aapl2018view`*/;
/*!50001 DROP VIEW IF EXISTS `aapl2018view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `aapl2018view` AS select `tickerprice`.`ticker_id` AS `ticker_id`,`tickerprice`.`price_date` AS `price_date`,`tickerprice`.`close_price` AS `close_price`,`tickerprice`.`dma_10` AS `dma_10`,`tickerprice`.`dma_50` AS `dma_50`,`tickerprice`.`dma_200` AS `dma_200`,`tickerprice`.`ema_12` AS `ema_12`,`tickerprice`.`ema_26` AS `ema_26`,`tickerprice`.`ema_macd_9` AS `ema_macd_9`,`tickerprice`.`ema_diff` AS `ema_diff`,`tickerprice`.`ema_5` AS `ema_5`,`tickerprice`.`ema_35` AS `ema_35`,`tickerprice`.`ema_macd_5` AS `ema_macd_5`,`tickerprice`.`ema_diff_5_35` AS `ema_diff_5_35`,`tickerprice`.`high_price_14` AS `high_price_14`,`tickerprice`.`low_price_14` AS `low_price_14`,`tickerprice`.`stc_osci_14` AS `stc_osci_14`,`tickerprice`.`sma_3_stc_osci_14` AS `sma_3_stc_osci_14`,`tickerprice`.`high_price` AS `high_price`,`tickerprice`.`low_price` AS `low_price`,`tickerprice`.`sma_3_3_stc_osci_14` AS `sma_3_3_stc_osci_14`,`tickerprice`.`dma_20` AS `dma_20`,`tickerprice`.`dma_20_sd` AS `dma_20_sd` from `tickerprice` where ((`tickerprice`.`ticker_id` = 9) and (`tickerprice`.`price_date` like '2017%')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dist_tick`
--

/*!50001 DROP TABLE IF EXISTS `dist_tick`*/;
/*!50001 DROP VIEW IF EXISTS `dist_tick`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dist_tick` AS select distinct `rating_master`.`ticker` AS `ticker` from `rating_master` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tickerob`
--

/*!50001 DROP TABLE IF EXISTS `tickerob`*/;
/*!50001 DROP VIEW IF EXISTS `tickerob`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `tickerob` AS select distinct `trade_signal_seq`.`ticker` AS `ticker` from `trade_signal_seq` where (`trade_signal_seq`.`signal` = 'Sell') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tickeros`
--

/*!50001 DROP TABLE IF EXISTS `tickeros`*/;
/*!50001 DROP VIEW IF EXISTS `tickeros`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `tickeros` AS select distinct `trade_signal_seq`.`ticker` AS `ticker` from `trade_signal_seq` where (`trade_signal_seq`.`signal` = 'Buy') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_user_report`
--

/*!50001 DROP TABLE IF EXISTS `view_user_report`*/;
/*!50001 DROP VIEW IF EXISTS `view_user_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_user_report` AS select `a`.`username` AS `username`,`a`.`name` AS `name`,`b`.`report_code` AS `report_code` from (`usermaster` `a` join `userreport` `b`) where (`a`.`username` = `b`.`usermail`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-01 22:26:55
