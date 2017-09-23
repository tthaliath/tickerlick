#!/usr/bin/env python
from distutils.core import setup
long_description = 'generate security buy/sell signals using technical indicators like RSI, Stochastic and Bollinger Band'
setup(name = 'tradevantage',
	version = '1.5a',
	description = 'generate security buy/sell signals using technical indicatorslike  RSI, Stochastic and Bollinger Band',
	maintainer = 'Thomas Thaliath',
	maintainer_email = 'tthaliath@gmail.com',
	url = 'https://github.com/tthaliath/tickerlick/tree/master/tradevantage',
	long_description = long_description,
	packages = ['tradevantage'],
      	package_data={'tradevantage/test': ['*.sh'],
		      'tradevantage/cron': ['*.txt'],
		      'tradevantage/schema': ['*.sql'],
		      'tradevantage/conf': ['*.json']
 		     }
		       
	)
