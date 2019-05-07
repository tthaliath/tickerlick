#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv
import json
#http://www.tweepy.org/
import tweepy

json_data = json.load(open('config.json'))
#Get your Twitter API credentials and enter them here
ACCESS_TOKEN = json_data['TWITTER']['ACCESS_TOKEN']
ACCESS_SECRET= json_data['TWITTER']['ACCESS_SECRET']
CONSUMER_KEY = json_data['TWITTER']['CONSUMER_KEY']
CONSUMER_SECRET = json_data['TWITTER']['CONSUMER_SECRET'] 

#method to get a user's last 100 tweets
def get_tweets(username):

	#http://tweepy.readthedocs.org/en/v3.1.0/getting_started.html#api
	auth = tweepy.OAuthHandler(CONSUMER_KEY,CONSUMER_SECRET)
	auth.set_access_token(ACCESS_TOKEN,ACCESS_SECRET)
	api = tweepy.API(auth)

	#set count to however many tweets you want; twitter only allows 200 at once
	number_of_tweets = 100 

	#get tweets
	tweets = api.user_timeline(screen_name = username,count = number_of_tweets)

	#create array of tweet information: username, tweet id, date/time, text
	tweets_for_csv = [[username,tweet.id_str, tweet.created_at, tweet.text.encode("utf-8")] for tweet in tweets]
        
	#write to a new csv file from the array of tweets
	print "writing to {0}_tweets.csv".format(username)
	with open("{0}_tweets.csv".format(username) , 'w+') as file:
		writer = csv.writer(file, delimiter='|')
		writer.writerows(tweets_for_csv)


#if we're running this as a script
if __name__ == '__main__':

    #get tweets for username passed at command line
    if len(sys.argv) == 2:
        get_tweets(sys.argv[1])
    else:
        print "Error: enter one username"

    #alternative method: loop through multiple users
	# users = ['user1','user2']

	# for user in users:
	# 	get_tweets(user)
