#!/usr/bin/perl

#use strict; 
#use warnings; 
use CGI; 
# Uncomment the next line only for debugging the script. 
#use CGI::Carp qw/fatalsToBrowser/; 
  
# The next two lines are very important. Do not modify them 
# if you do not understand what they do. 
$CGI::POST_MAX = 1024; 
$CGI::DISABLE_UPLOADS = 1;  

my $q  = CGI->new;
my $file = "macd_535_5_bullish.csv";
my @fileholder;
my $filesloc = "/home/tthaliath/perltest/bull/bull-535-2013-04-25.csv";

open(DLFILE,"<$filesloc");


 print $q->header(-type            => 'application/x-download',
                    -attachment      => $file,
                    'Content-length' => -s "$filesloc",
   );

   binmode $DLFILE;
   print while <$DLFILE>;
   undef ($DLFILE);
