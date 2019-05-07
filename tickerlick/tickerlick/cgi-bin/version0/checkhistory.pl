#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
$| = 1;
use strict;
use warnings;
require "gettickerdetfull.pl";

my ($res) = &getpricehistory(9,100);
print "$res\n";
