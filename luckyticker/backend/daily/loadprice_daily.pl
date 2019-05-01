#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
my $today = $ARGV[0];
#if ($today !~ /^20/){exit 1;}
my ($price_date);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $delquery = "delete from tickerprice where price_date >="."'$today'";
print "$delquery\n";
$ret = $dbh->do($delquery);
my $delquery = "delete from tickerpricersi where price_date >="."'$today'";
print "$delquery\n";
$ret = $dbh->do($delquery);
$today =~ s/\-//g;
#my $loadquery = "load data infile '\/home\/tthaliath\/tickerdata\/history\/price\/daily\/$today\/pricehist.csv' into table tickerprice   fields terminated by ','  lines terminated by '\\n'  (ticker_id,price_date,high_price,low_price,close_price)";
#my $ins_rsi_query = "insert into tickerpricersi (ticker_id,price_date,close_price) select ticker_id,price_date,close_price from tickerprice where price_date = ?";
#$sth_rsi = $dbh->prepare($ins_rsi_query);
#print "$loadquery\n";
$file = "/home/tthaliath/tickerdata/history/price/daily/$today/pricehist.csv";
open (F, "<$file");
while (<F>)
{
   chomp;
   ($ticker_id,$price_date,$high_price,$low_price,$close_price) = split (/\,/,$_);
    $price_date = "'".$price_date."'";
    $ins_query = "insert into tickerprice (ticker_id,price_date,high_price,low_price,close_price,high_price_14,low_price_14) values ($ticker_id,$price_date,$high_price,$low_price,$close_price,$high_price,$low_price)";
    $sth = $dbh->prepare($ins_query);
    $sth->execute;
    $sth->finish;
    $ins_rsi_query = "insert into tickerpricersi (ticker_id,price_date,close_price) values ($ticker_id,$price_date,$close_price)";
    $sth_rsi = $dbh->prepare($ins_rsi_query);
    $sth_rsi->execute;
    $sth_rsi->finish;
}
close (F);
$dbh->disconnect;

1;


