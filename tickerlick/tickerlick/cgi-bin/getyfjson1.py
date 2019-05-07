import json
import sys
import urllib2
import re
#url = 'https://query.yahooapis.com/v1/public/yql?q=select%20symbol,EarningsShare,PERatio,YearLow,YearHigh,MarketCapitalization,LastTradePriceOnly,DividendShare,OneyrTargetPrice,DividendYield,FiftydayMovingAverage,TwoHundreddayMovingAverage,ChangeFromTwoHundreddayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,ChangeFromFiftydayMovingAverage,PercentChangeFromFiftydayMovingAverage,PreviousClose%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22QCOM%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
#url = 'https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22QCOM%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
url = 'https://query.yahooapis.com/v1/public/yql?q=select%20YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22QCOM%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
response = urllib2.urlopen(url)
data = response.read()

#load the json to a string
resp = json.loads(data)
dict = {}
#print the resp
#print (resp)
#print resp['query']['results']['quote'][0]['symbol']
str = resp['query']['results']['quote']
#str1 = resp['query']['results']['quote'][1]
#print str
#print str1
#str = re.sub('[%+-]','', str)
ind = 0;
for key,val in str.iteritems():
#	print key,val
       	if (val == None):
		val = 0
	else:
		val = re.sub('[%+]','', val)
	if (key == 'MarketCapitalization' and val != 0):
		st = val
               	cur = st[-1]
               	st = st[:-1]
               	val = st
		if (cur == 'B'):
			val = float(val) * 1000;
		if (cur == 'K'):
                       	val = float(val) * 0.001;
		cur = '';
	print key
