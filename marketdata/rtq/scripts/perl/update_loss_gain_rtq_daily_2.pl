#!/usr/bin/perl
my $proc_order_id = $ARGV[0];
my $price_date =$ARGV[1];
use strict;
use warnings;
use DBI;
my ($PASSWORD) = $ENV{DBPASSWORD};
my (@row,@row_day,$seq,@row_diff,$prev_seq,$prev_date,$sth_date,$ticker_id,$rtq,$firstrow,$prev_rtq,$loss,$gain);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD) or die "Connection Error: $DBI::errstr\n";
my $upd_query ="update tickerrtq7 set gain = ?, loss = ? where ticker_id = ? and price_date = ? and seq = ?";
my $sth_upd = $dbh->prepare($upd_query);
#print "Calculating EMA10\n";
my $prev_query =" select max(price_date) from tickerrtq7 where ticker_id = 9 and price_date < '$price_date' ";
 $sth_date = $dbh->prepare($prev_query);
 $sth_date->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
while (@row = $sth_date->fetchrow_array) {
$prev_date = $row[0];
}
my $query ="select a.ticker_id from  tickermaster a, rtq_proc_master1 b where b.proc_ord_id = ? and a.ticker_id = b.ticker_id  and a.tflag2 = 'Y'";
#print "$query\n";
 my $sth = $dbh->prepare($query);
 $sth->execute($proc_order_id) or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) {
$ticker_id = $row[0];
#print "$ticker_id\n";
#update gain and loss 
my $diff_query ="select seq,rtq from tickerrtq7 where ticker_id = $ticker_id and price_date >= '$prev_date' and avg_gain is not null order by seq desc limit  1" ;
#print "$diff_query\n";
my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
while (@row_diff = $sth_diff->fetchrow_array) 
{
   $prev_seq = $row_diff[0];
   $prev_rtq = $row_diff[1];
}
$sth_diff->finish();
if ($prev_seq)
{

my $day_query ="select seq,rtq from tickerrtq7 where ticker_id = $ticker_id and seq > $prev_seq" ;

my $sth_day = $dbh->prepare($day_query);
$sth_day->execute or die "SQL Error: $DBI::errstr\n";
while (@row_day = $sth_day->fetchrow_array)
{
   $seq = $row_day[0];
   $rtq = $row_day[1];
   $gain = 0; $loss = 0;
   if ($rtq > $prev_rtq)
         {
             $gain = $rtq - $prev_rtq;
             $loss = 0;
         }
      else
        {
            $loss = $prev_rtq - $rtq;
            $gain = 0;
        }
        $prev_rtq = $rtq;
        $sth_upd->execute($gain,$loss,$ticker_id,$price_date,$seq) or die "SQL Error: $DBI::errstr\n";
}
 
$sth_day->finish();
}
}
$sth->finish();
$sth_upd->finish();
$dbh->disconnect; 
