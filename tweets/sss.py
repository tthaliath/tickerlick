#!/usr/bin/python

#-----------------------------------------------------------------------
# twitter-search
#  - performs a basic keyword search for tweets containing the keywords
#    "lazy" and "dog"
#-----------------------------------------------------------------------

from twitter import *
#Import the necessary package to process data in JSON format
try:
    import json
except ImportError:
    import simplejson as json
import sys

# Variables that contains the user credentials to access Twitter API
ACCESS_TOKEN = '90261339-r6KpAPPZvv96Z76Nez3yxsLjx2Tboo0Y2XPlqdIGY'
ACCESS_SECRET = 'OZam2iNVSPabrscSevrllHcq4tbV7pmz3DWhuRxfE4cW9'
CONSUMER_KEY = 'zIbDrdGqV7OwceZ63ymksxudh'
CONSUMER_SECRET = 'RYVoVYXClhSUe4aLAn7EA9cbxIy4excn6HLDbyIgIBKrInqXo5'

twitter = Twitter(
                   auth = OAuth(ACCESS_TOKEN, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET))

#-----------------------------------------------------------------------
# create twitter API object
#-----------------------------------------------------------------------


#-----------------------------------------------------------------------
# perform a basic search 
# Twitter API docs:
# https://dev.twitter.com/rest/reference/get/search/tweets
#-----------------------------------------------------------------------
query = twitter.search.tweets(q='#angelinajolie')

#-----------------------------------------------------------------------
# How long did this query take?
#-----------------------------------------------------------------------
#print "Search complete (%.3f seconds)" % (query["search_metadata"]["completed_in"])

#-----------------------------------------------------------------------
# Loop through each of the results, and print its content.
#-----------------------------------------------------------------------
for tweet in query["statuses"]:
	result = json.dumps(tweet, sys.stdout)
	#print "(%s) @%s %s" % (result["created_at"], result["user"]["screen_name"], result["text"])
        loaded_j = json.loads(result)
        loaded_json = loaded_j.strip()
        for x in loaded_json:
             print x, loaded_json['text']
