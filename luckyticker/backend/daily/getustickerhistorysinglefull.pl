#!/usr/bin/perl
use LWP::Simple;
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
my $today = $ARGV[0];
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

open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_test.csv");

while (<F>)
{
	
	chomp;
	my ($ticker_id,$ticker,@rest) = split (/\,/,$_);
	$filename = "\/home\/tthaliath\/tickerlick\/daily\/ustickertest\/".$ticker_id."\.csv";
        print "$filename\n";
	if (-e $filename){next;}
	#$str = get ("http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=04&b=01&c=2014&d=04&e=01=2014&g=w");
        	
	$url = "http://ichart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv";
        print "$url\n";
        $str = get($url);
	if (!$str){next;}
        open (OUT,">$filename");
        print OUT "$str";
        close (OUT);
 }
close (F); 





