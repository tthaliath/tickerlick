#Import the necessary package to process data in JSON format
try:
    import json
except ImportError:
    import simplejson as json

# Import the necessary methods from "twitter" library
from twitter import Twitter, OAuth, TwitterHTTPError, TwitterStream
#import twitter;

# Variables that contains the user credentials to access Twitter API 
ACCESS_TOKEN = '90261339-r6KpAPPZvv96Z76Nez3yxsLjx2Tboo0Y2XPlqdIGY'
ACCESS_SECRET = 'OZam2iNVSPabrscSevrllHcq4tbV7pmz3DWhuRxfE4cW9'
CONSUMER_KEY = 'zIbDrdGqV7OwceZ63ymksxudh'
CONSUMER_SECRET = 'RYVoVYXClhSUe4aLAn7EA9cbxIy4excn6HLDbyIgIBKrInqXo5'

oauth = OAuth(ACCESS_TOKEN, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET)

# Initiate the connection to Twitter Streaming API
twitter_stream = TwitterStream(auth=oauth)

# Get a sample of the public data following through Twitter
iterator = twitter_stream.statuses.sample()

# Print each tweet in the stream to the screen 
# Here we set it to stop after getting 1000 tweets. 
# You don't have to set it to stop, but can continue running 
# the Twitter API to collect data for days or even longer. 
tweet_count = 100
fh = open("data.txt","w");
for tweet in iterator:
    tweet_count -= 1
    # Twitter Python Tool wraps the data returned by Twitter 
    # as a TwitterDictResponse object.
    # We convert it back to the JSON format to print/score
    #print json.dumps(tweet)  
    #json.dump(tweet, fh, sort_keys = True, indent = 4)
    json.dump(tweet, fh);
    #fh.write(json.dump(tweet));
    fh.write("\n");
    # The command below will do pretty printing for JSON data, try it out
    #print json.dumps(tweet, indent=4)
       
    if tweet_count <= 0:
        break

fh.close() 

# We use the file saved from last step as example
tweets_filename = 'data.txt'
tweets_file = open(tweets_filename, "r")

for line in tweets_file:
    try:
        # Read in one line of the file, convert it into a json object 
        tweet = json.loads(line.strip())
        if 'text' in tweet: # only messages contains 'text' field is a tweet
            #print tweet['text'] # content of the tweet
            #print tweet['user']['id'] # id of the user who posted the tweet
            #print tweet['user']['name'] # name of the user, e.g. "Wei Xu"
            #print tweet['user']['screen_name'] # name of the user account, e.g. "cocoweixu"
            if (tweet['entities']['hashtags']):
                hashtags = [];
                for hashtag in tweet['entities']['hashtags']:
            	    hashtags.append(hashtag['text']);
                #print hashtags;

            

    except:
        #print line;
        # read in a line is not in JSON format (sometimes error occured)
        continue

# Initiate the connection to Twitter REST API
twitter = Twitter(auth=oauth)

# Search for latest tweets about "#nlproc"
t = twitter.search.tweets(q='@joliestweet')

#print json.dumps(t)
print json.dumps(t, indent = 4)
