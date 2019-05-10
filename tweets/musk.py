#!/usr/bin/env python 
#Import the necessary package to process data in JSON format
try:
    import json
except ImportError:
    import simplejson as json
import sys
# Import the necessary methods from "twitter" library
from twitter import Twitter, OAuth, TwitterHTTPError, TwitterStream
#import twitter;
from unidecode import unidecode
# Variables that contains the user credentials to access Twitter API 
ACCESS_TOKEN = '90261339-r6KpAPPZvv96Z76Nez3yxsLjx2Tboo0Y2XPlqdIGY'
ACCESS_SECRET = 'OZam2iNVSPabrscSevrllHcq4tbV7pmz3DWhuRxfE4cW9'
CONSUMER_KEY = 'zIbDrdGqV7OwceZ63ymksxudh'
CONSUMER_SECRET = 'RYVoVYXClhSUe4aLAn7EA9cbxIy4excn6HLDbyIgIBKrInqXo5'
oauth = OAuth(ACCESS_TOKEN, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET)

# Initiate the connection to Twitter REST API
twitter = Twitter(auth=oauth)

# Initiate the connection to Twitter Streaming API
tweets = twitter.search.tweets(q='@elonmusk')
for result in tweets["statuses"]:
    try:
        tweet = json.dumps(result, sys.stdout)
        # Read in one line of the file, convert it into a json object 
        #tweet = json.loads(line.strip())
        if 'text' in tweet: # only messages contains 'text' field is a tweet
            print tweet['text'] # content of the tweet
            print tweet['user']['id'] # id of the user who posted the tweet
            print tweet['user']['name'] # name of the user, e.g. "Wei Xu"
            print tweet['user']['screen_name'] # name of the user account, e.g. "cocoweixu"
            if (tweet['entities']['hashtags']):
                hashtags = [];
                for hashtag in tweet['entities']['hashtags']:
            	    hashtags.append(hashtag['text']);
                print hashtags;

            

    except:
        print result;
        # read in a line is not in JSON format (sometimes error occured)
        continue
