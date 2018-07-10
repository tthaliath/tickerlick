#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
use POSIX qw(strftime);
use strict;
use warnings;
my ($PASSWORD) = $ENV{DBPASSWORD};
my $price_date = $ARGV[0];
my $ord_id = $ARGV[1];
my ($now,$dbh,@row,$sth,$sql,$tickerlist,%tickhash,$tick,$quote,$prev_date,$prev_prev_date);
sleep(10);
$dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
my $prev_query ="select max(price_date) from tickerrtq7 where ticker_id = 9 and price_date < '$price_date' ";
my $sth_date = $dbh->prepare($prev_query);
 $sth_date->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth_date->fetchrow_array) {
 $prev_date = $row[0];
 }
$sth_date->finish();
$prev_query ="select max(price_date) from tickerrtq7 where ticker_id = 9 and price_date < '$prev_date' ";
$sth_date = $dbh->prepare($prev_query);
 $sth_date->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth_date->fetchrow_array) {
  $prev_prev_date = $row[0];
   }
   $sth_date->finish();
my $mktclose = 0;
#print "start:$now\n";
my $ins_query = "insert into tickerrtq7 (ticker_id,price_date,rtq,high_price_14,low_price_14) values (?,?,?,?,?)";
my $in_sth = $dbh->prepare($ins_query);
$sql = "select  a.ticker,a.ticker_id  from rtq_proc_master1 a where a.proc_ord_id = ?";

$sth = $dbh->prepare($sql);
while ($mktclose == 0)
{
$tickerlist ='';
$sth->execute($ord_id) or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array)
{
   $tickerlist .= $row[0].',';
   $tickhash{$row[0]} = $row[1];
}
$tickerlist =~ s/\,$//;

#print "$tickerlist\n";
&getResults("$tickerlist");
#print "$ord_id\n";
#$mktclose = 1;
$now = strftime "%H", localtime;
if ($now == 13){$mktclose = 1;}
system("/home/tthaliath/tickerlick/history/rtq/daily/update_dma_rtq_daily_1.pl $ord_id $prev_date $prev_prev_date");
system("/home/tthaliath/tickerlick/history/rtq/daily/update_loss_gain_rtq_daily_2.pl $ord_id $price_date");
system("/home/tthaliath/tickerlick/history/rtq/daily/update_ema_535_rtq_daily_3.pl $ord_id  $price_date $prev_date");
system("/home/tthaliath/tickerlick/history/rtq/daily/update_avg_loss_gain_daily_5.pl $ord_id $prev_date");
system("/home/tthaliath/tickerlick/history/rtq/daily/stoch_update_dma_daily.pl $ord_id");
sleep(15);
}
$sth->finish;
$now = strftime "%H%M%S", localtime;
#print "finish:$now\n";
sub getResults
{
my ($tickerlist) = uc shift;
my ($quote,$url,$content,$ticker,$high,$low);
foreach $ticker (split /\,/,$tickerlist)
{
$url ="http://www.alphavantage.co/query?apikey=19BF&function=TIME_SERIES_INTRADAY&interval=1min&symbol=".$ticker;

$content = get($url);
if ($content =~ /.*?Time Series.*?high\".*?\"(.*?)\".*?low\".*?\"(.*?)\".*?close\".*?\"(.*?)\"/s)
{
   $high = $1;
   $low = $2;
   $quote = $3;
    #print "$tick,$quote\n";
    $in_sth->execute($tickhash{$ticker},$price_date,$quote,$high,$low);
}
else
{
   $content = get("http://www.marketwatch.com/investing/stock/$ticker");
   $content =~ s/\r\n//g;
   #   <span class="text low">147.3300</span>
   #             <span class="text title">Day Low/High</span>
   #             <span class="text high">149.3300</span>
   #
   if ($content =~ /.*?<span class\=\"volume last\-value\">.*?<\/span>.*?<span class\=\"last\-value\">(.*?)<\/span>.*?text low\"\>(.*?)<\/span>.*?text high\"\>(.*?)<\/span>/s)
   {
      $quote = $1;
      $low = $2;
      $high = $3;
    #print "$tick,$quote\n";
    $in_sth->execute($tickhash{$ticker},$price_date,$quote,$high,$low);
   }
}
}
}
$in_sth->finish;
$dbh->disconnect;
1;
