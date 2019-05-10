#!/usr/bin/env python
#Import the necessary package to process data in JSON format
try:
    import json
except ImportError:
    import simplejson as json
import sys
# Import the necessary methods from "twitter" library
#from twitter import Twitter, OAuth, TwitterHTTPError, TwitterStream
import twitter;
# Variables that contains the user credentials to access Twitter API
ACCESS_TOKEN = '90261339-r6KpAPPZvv96Z76Nez3yxsLjx2Tboo0Y2XPlqdIGY'
ACCESS_SECRET = 'OZam2iNVSPabrscSevrllHcq4tbV7pmz3DWhuRxfE4cW9'
CONSUMER_KEY = 'zIbDrdGqV7OwceZ63ymksxudh'
CONSUMER_SECRET = 'RYVoVYXClhSUe4aLAn7EA9cbxIy4excn6HLDbyIgIBKrInqXo5'
#oauth = OAuth(ACCESS_TOKEN, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET)
api = twitter.Api(consumer_key=CONSUMER_KEY,
  consumer_secret=CONSUMER_SECRET,
  access_token_key=ACCESS_TOKEN,
  access_token_secret=CONSUMER_SECRET)
 
# Initiate the connection to Twitter REST API
#twitter = Twitter(auth=oauth)
print(api.VerifyCredentials())
print [s.text for s in api.GetUserTimeline(screen_name='@BarackObama')]

