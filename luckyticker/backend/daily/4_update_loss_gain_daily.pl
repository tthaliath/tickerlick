#!/usr/bin/perl
use DBI;
my ($ticker_id,$close_price,$firstrow,$prev_close_price,$loss,$gain);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $upd_query ="update tickerpricersi set gain = ?, loss = ? where ticker_id = ? and price_date = ?";
my $sth_upd = $dbh->prepare($upd_query);
#print "Calculating EMA10\n";
$query ="select distinct ticker_id from  tickerpricersi";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
while (@row = $sth->fetchrow_array) {
$ticker_id = $row[0];
#print "$ticker_id\n";
#update gain and loss 
my $diff_query ="select price_date,close_price from tickerpricersi where ticker_id = $ticker_id and price_date < '$ARGV[0]' order by price_date desc limit 1" ;

my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
while (@row_diff = $sth_diff->fetchrow_array) 
{
   $price_date = $row_diff[0];
   $prev_close_price = $row_diff[1];
}
$sth_diff->finish();
my $day_query ="select price_date,close_price from tickerpricersi where ticker_id = $ticker_id and price_date = '$ARGV[0]'" ;

my $sth_day = $dbh->prepare($day_query);
$sth_day->execute or die "SQL Error: $DBI::errstr\n";
while (@row_day = $sth_day->fetchrow_array)
{
   $price_date = $row_day[0];
   $close_price = $row_day[1];
   $gain = 0; $loss = 0;
   if ($close_price > $prev_close_price)
         {
             $gain = $close_price - $prev_close_price;
             $loss = 0;
         }
      else
        {
            $loss = $prev_close_price - $close_price;
            $gain = 0;
        }
        $prev_close_price = $close_price;
        $sth_upd->execute($gain,$loss,$ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
}
 
$sth_day->finish();
}
$sth->finish();
$sth_upd->finish();
$dbh->disconnect; 
