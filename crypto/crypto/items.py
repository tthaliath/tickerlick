# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class CryptoItem(scrapy.Item):
    # define the fields for your item here like:
     name = scrapy.Field()
     ticker = scrapy.Field()
     ord = scrapy.Field()
     lastprice = scrapy.Field()
