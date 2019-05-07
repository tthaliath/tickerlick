#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use LWP::Simple;
my ($ticker,$cname,$content,%hash) ;
print "start\n";

open (F, ">nocontent.txt");
open (IN,"tickermaster.csv");
while (<IN>)
{
  chomp;
  ($ticker_id,$cname,$ticker) = split(/\,/,$_);
   $ticker =~ s/ //g;
   #print "$ticker\n";
   $hash{$ticker}++;
  $content = get("http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=09&b=9&c=2012&d=09&e=9&f=2012&g=d");

#die "Couldn't get it!" unless defined $content;

if ($content)
{


$filename = "\/home\/tthaliath\/tickerdata\/history\/price\/daily\/feed\/".$ticker."\.csv";

open (OUT,">$filename");
print OUT "$content\n";
close (OUT);  
}
else   
{
 
  print F "$ticker\n";
  

}

}
close (IN);
foreach my $key (keys %hash)
{
   if ($hash{$key} > 1)
   {
      print F "DUPE:$key\n";
   }
 }
close (F);
