#!/usr/bin/perl
use DBI;
my $tickidmin = $ARGV[0];
my $tickidmax = $tickidmin;
use strict;
use warnings;
my ($curr_gain,$curr_loss,$avg_loss,$avg_gain,$sth,@row,$ticker_id,$close_price,$firstrow,$prev_close_price,$loss,$gain,$first_row_flag);
my (@row_date,$prev_avg_loss,$prev_avg_gain,@row_first_avg,$price_date ,$query,$sth_first_avg_query, $rs,$rsi,);
my ($PASSWORD) = $ENV{DBPASSWORD};
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD) or die "Connection Error: $DBI::errstr\n";
my $date_query ="select price_date from tickerpricersi where ticker_id = ? order by price_date asc limit 14,10000" ;
my $first_avg_query = "select gain,loss,avg_gain,avg_loss from tickerpricersi where ticker_id = ? and price_date = ?";
my $upd_avg_query = "update tickerpricersi set avg_gain = ?, avg_loss = ? ,rsi = ?, rsi_14 = ? where ticker_id = ? and price_date = ?";
my $sth_date_query = $dbh->prepare($date_query);
$sth_first_avg_query = $dbh->prepare($first_avg_query);
my $sth_upd_avg_query = $dbh->prepare($upd_avg_query);
#print "Calculating EMA10\n";
$query ="select distinct ticker_id from  tickerpricersi where ticker_id >= ? and ticker_id <= ? ";#
 $sth = $dbh->prepare($query);
 $sth->execute($tickidmin,$tickidmax) or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 #print "price_date,first_row_flag,prev_avg_gain,prev_avg_loss,curr_gain, curr_loss,avg_gain ,avg_loss\n";
while (@row = $sth->fetchrow_array) 
{
$ticker_id = $row[0];
$first_row_flag = 1;
#update gain and loss 
$sth_date_query->execute($ticker_id) or die "SQL Error: $DBI::errstr\n";
while (@row_date = $sth_date_query->fetchrow_array) 
{
   $price_date = $row_date[0];
   $sth_first_avg_query->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
   while (@row_first_avg = $sth_first_avg_query->fetchrow_array)
    {
       if ($first_row_flag)
       {
          $avg_gain = $row_first_avg[2];
          $avg_loss = $row_first_avg[3]; 
          $curr_gain = $row_first_avg[0];
          $curr_loss = $row_first_avg[1];
          if ($avg_gain == 0){$rs = 0;$rsi = 0;}
            elsif ($avg_loss == 0){$rs = 100;$rsi = 100;}
            else
              {
                  $rs = $avg_gain/$avg_loss;
                  $rsi = 100.00 - (100.00/(1.00+$rs));
              }
            $sth_upd_avg_query->execute($avg_gain,$avg_loss,$rs,$rsi,$ticker_id,$price_date);
            $prev_avg_gain = $avg_gain;
            $prev_avg_loss = $avg_loss;
          $first_row_flag = 0;
        }
        else
        {
            $curr_gain = $row_first_avg[0];
            $curr_loss = $row_first_avg[1];
            $avg_gain = (($prev_avg_gain  * 13.00) + $curr_gain) / 14.00;
            $avg_loss = (($prev_avg_loss  * 13.00) + $curr_loss) / 14.00;              
            if ($avg_gain == 0){$rs = 0;$rsi = 0;}
            elsif ($avg_loss == 0){$rs = 100;$rsi = 100;}
            else
              {
                  $rs = $avg_gain/$avg_loss;
                  $rsi = 100.00 - (100.00/(1.00+$rs));
              }
            $sth_upd_avg_query->execute($avg_gain,$avg_loss,$rs,$rsi,$ticker_id,$price_date);
            $prev_avg_gain = $avg_gain;
            $prev_avg_loss = $avg_loss;
       }
       #print "$price_date,$first_row_flag,$prev_avg_gain,$prev_avg_loss,$curr_gain, $curr_loss,$avg_gain ,$avg_loss\n";

   }
$sth_first_avg_query->finish();
}
$sth_date_query->finish(); 
}
$sth->finish();
$dbh->disconnect; 

