import scrapy
import json
import sys
from crypto.items import *
import requests
import json
reload(sys)
sys.setdefaultencoding('utf8')
class QuotesSpider(scrapy.Spider):
    name = "cryptomaster"

    def start_requests(self):
        urls = [
            'https://www.cryptocompare.com/api/data/coinlist/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        jsonresponse = json.loads(response.body_as_unicode())
	items = []
        symbol = str(jsonresponse['Data'])
        symbols = jsonresponse['Data'].keys() 
        for ticker in symbols:
		#print jsonresponse['Data'][ticker]['Symbol'],jsonresponse['Data'][ticker]['CoinName'],jsonresponse['Data'][ticker]['SortOrder']
	 	item = CryptoItem() 
                item['ticker'] = ticker
                item['name'] = jsonresponse['Data'][ticker]['CoinName']	
                item['ord'] = jsonresponse['Data'][ticker]['SortOrder']
		if ( int(item['ord']) <= 100):
			print item
			r = requests.get("https://min-api.cryptocompare.com/data/price?fsym="+ticker+"&tsyms=USD").text
			data = json.loads(r)
			if 'USD' in data:
				item['lastprice'] = data['USD']
			items.append(item)
			print item
        return items
