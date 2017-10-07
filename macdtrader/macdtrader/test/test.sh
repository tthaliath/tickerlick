# -t <list of stock symbols separated by comma. if not provided, will take symbols from symbolllist.txt>
# -d date in yyyy-mm-dd format. default:today
# -f symbol list file. default: symbollist.txt

/usr/local/bin/python macdgen.py -t AAPL,SNAP,SRPT,AMD,NVDA,AMZN,GOOGL,TSLA,FB,NFLX,AGN,BABA,AVEO,BLK,FEYE,EFX,ORCL,SAGE

#generate reports every two minutes. if email credentials are setup config.json file, report will be emailed

/usr/local/bin/python reportquery.py

