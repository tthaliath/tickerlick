=============
tradevantage
=============

Python modules to download intraday stock quotes and generate BUY/SELL signals based on  technical indicators

Intraday quoues are pulled from http://alphavantage.co via their interface. If this service is down/having credential issues, the system downloads quotes fro  marketwatch.com
To use alphavantage.co, user needs to acquire their free api key. The free key is available at https://www.alphavantage.co/support/#api-key

For more details https://github.com/tthaliath/tickerlick/tradevantage

Install
-------

From PyPI with pip:

.. code:: bash

    $ pip install tradevantage

From development repo (requires git)

.. code:: bash

    $ git clone git://github.com/.git
    $ cd tradevantage 
    $ python setup.py install

Install Database
----------------

After package install, login to mysql and the following command

source schema.sql

This will create database tickmaster and table secpricert

Usage examples
--------------
.. code:: bash
   -t <list of stock symbols separated by comma. if not provided, will take symbols from symbolllist.txt>
   -d date in yyyy-mm-dd format. default:today
   -f symbol list file. default: symbollist.txt

    # download intraday quotes and generate buy/sell signals
    $  /usr/local/bin/python alphartq.py -t AAPL,SNAP,SRPT,AMD,NVDA,AMZN,GOOGL,TSLA,FB,NFLX,AGN,BABA,AVEO,BLK,FEYE,EFX,ORCL,SAGE

    #generate reports every two minutes. if email credentials are setup config.json file, report will be emailed

    $  /usr/local/bin/python reportquery.py

Requirements
------------

	1. mysql database
	2. Python Ver 2.7 or greater

Cronjob
--------

Please check cronjob.txt
