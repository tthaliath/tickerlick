#!/usr/bin/perl
use strict;
use warnings;
my ($d,$m,$y);
my ($day,$date,$open,$high,$low,$close,$volume,@rest);
#Date,Open,High,Low,Close,Volume
my %map = ( 'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04',
            'May' => '05', 'Jun' => '06', 'Jul' => '07', 'Aug' => '08',
            'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12');
open (OUT,">/home/tthaliath/tickerlick/history/new1/pricehist.csv");
my $dirname = "/home/tthaliath/tickerlick/history/new1/usticker";
#date,open,high,low,close,volume,changed,changep,adjclose,tradeval,tradevol
my $ticker_id = $ARGV[0];
     my $filename = $ticker_id.".csv";
     open (IN,"$dirname\/$filename");
     while (<IN>)
     {
	 chomp;
	 ($date,$open,$high,$low,$close,$volume,@rest) = split (/\,/,$_);
	 if ($date =~ /date/){next;}
         if ($date =~ /^(.*?)[\-|\/](.*?)[\-|\/](.*)$/)
         {
             $d = $1;
             $m = $2;
             $y = '20'.$3;
             if ($d < 10 ){$d = '0'.$d;}
             #if ($m < 10 ){$m = '0'.$m;}
             $day = $y.'-'.$map{$m}.'-'.$d; 
	 print OUT "$ticker_id,$day,$high,$low,$close\n";
      }
         
    } 	 

close (OUT);
