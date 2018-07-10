#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
my ($today,$filename,$url,$ticker_id,$ticker,@rest,$str,$year,$mon,$day,$year1,$mon1,$day1);
my $fday = '2011-10-18';
$ticker_id = $ARGV[0];
$ticker = $ARGV[1];
#2014-05-28
if ($today  =~ /(.*?)\-(.*?)\-(.*)$/)
{
   $year = $1;
   $mon = $2;
   $day = $3;
}

if ($mon =~ /^0(.*)$/ )
{
   $mon = $1;
}
$mon = $mon - 1;

if ($fday  =~ /(.*?)\-(.*?)\-(.*)$/)
{
   $year1 = $1;
   $mon1 = $2;
   $day1 = $3;
}

if ($mon1 =~ /^0(.*)$/ )
{
   $mon1 = $1;
}
$mon1 = $mon1 - 1;

	$filename = "\/home\/tthaliath\/tickerlick\/history\/new1\/usticker\/".$ticker_id."\.csv";
        print "$filename\n";
	if (-e $filename){next;}
	#$str = get ("http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=04&b=01&c=2014&d=04&e=01=2014&g=w");
        #$url = "http://real-chart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv"; 	
	#$url = "http://ichart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon1&b=$day1&c=$year1&ignore=.csv";
        #http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=06&b=14&c=2014&d=06&e=14&f=2014&g=d&ignore=.csv
        $url = "https://www.google.com/finance/historical?q=$ticker&output=csv";
        $str = get($url);
	if ($str){
        open (OUT,">$filename");
        print OUT "$str";
        close (OUT);
        }
