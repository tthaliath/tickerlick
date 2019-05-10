#!/usr/bin/env python
#Import the necessary package to process data in JSON format
try:
    import json
except ImportError:
    import simplejson as json
import sys
# Import the necessary methods from "twitter" library
from twitter import Twitter, OAuth, TwitterHTTPError, TwitterStream
# Variables that contains the user credentials to access Twitter API
ACCESS_TOKEN = '90261339-r6KpAPPZvv96Z76Nez3yxsLjx2Tboo0Y2XPlqdIGY'
ACCESS_SECRET = 'OZam2iNVSPabrscSevrllHcq4tbV7pmz3DWhuRxfE4cW9'
CONSUMER_KEY = 'zIbDrdGqV7OwceZ63ymksxudh'
CONSUMER_SECRET = 'RYVoVYXClhSUe4aLAn7EA9cbxIy4excn6HLDbyIgIBKrInqXo5'
oauth = OAuth(ACCESS_TOKEN, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET)

# Initiate the connection to Twitter REST API
t = Twitter(auth=oauth)

# Get your "home" timeline
t.statuses.home_timeline()

# Get a particular friend's timeline
t.statuses.user_timeline(screen_name="@elonmusk")

# to pass in GET/POST parameters, such as `count`
t.statuses.home_timeline(count=5)

#tweets = t.search.tweets(q='#angelinajolie')
# Get a particular friend's timeline
musk = t.statuses.user_timeline(screen_name="@elonmusk")
print json.dumps(musk)
