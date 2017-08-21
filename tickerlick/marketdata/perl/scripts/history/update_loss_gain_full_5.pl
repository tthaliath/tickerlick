#!/usr/bin/perl
use DBI;
my $tickidmin = $ARGV[0];
my $tickidmax = $tickidmin;

my ($ticker_id,$close_price,$firstrow,$prev_close_price,$loss,$gain);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $upd_query ="update tickerpricersi set gain = ?, loss = ? where ticker_id = ? and price_date = ?";
my $sth_upd = $dbh->prepare($upd_query);
#print "Calculating EMA10\n";
$query ="select distinct ticker_id from  tickerpricersi where ticker_id >= ? and ticker_id <= ? ";
 $sth = $dbh->prepare($query);
 $sth->execute($tickidmin,$tickidmax) or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
while (@row = $sth->fetchrow_array) {
$ticker_id = $row[0];
print "$ticker_id\n";
$firstrow = 1;
#update gain and loss 
my $diff_query ="select price_date,close_price from tickerpricersi where ticker_id = $ticker_id order by price_date asc" ;

my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
while (@row_diff = $sth_diff->fetchrow_array) 
{
   $price_date = $row_diff[0];
   $close_price = $row_diff[1];
   if ($firstrow)
   {
      $prev_close_price = $close_price;
      $firstrow = 0;
   }
   else
    {
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
 
}
$sth_diff->finish();
}
$sth->finish();
$sth_upd->finish();
$dbh->disconnect; 
