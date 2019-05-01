#!/usr/bin/perl

use DBI;
my ($ticker_id,$comp_name,$ticker,$sector,$industry,$min_bear_date,$days);
my ($price_date) = $ARGV[0];
my ($price_date_prev) = $ARGV[1];
my ($nodays) = $ARGV[2];
my ($minp,$cur_date,$leastval);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select a.ticker_id,a.ticker from tickermaster a, tickerprice b where (a.sector in ('NULL','Basic Materials','Technology','Financial','Services') or a.ticker = 'GLD') and (a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Shipping' and a.industry NOT REGEXP '^Rental' and a.industry NOT REGEXP '^Agricultural' and a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Air' and a.industry NOT REGEXP '^Education' and a.industry NOT REGEXP '^Savings' and a.industry NOT REGEXP '^Closed-End' and a.industry NOT REGEXP '^Regional' and a.industry NOT REGEXP '^Property' and a.industry NOT REGEXP '^REIT' and a.industry NOT REGEXP '^Auto' and a.industry NOT REGEXP '^Building') and a.ticker_id = b.ticker_id and b.price_date = ?  and (b.ema_diff_5_35 - b.ema_macd_5) < 0 order by a.sector,a.industry";

$query4 = 'select a.ticker_id,a.ticker,a.comp_name,a.sector,a.industry,b.close_price from tickermaster a, tickerprice b where a.ticker_id = b.ticker_id and a.ticker_id = ? and b.price_date = ?';
$sth4 = $dbh->prepare($query4);

#print "$sql\n";
 #my $file = "bull-535-best\.csv";
 #print "$file\n";
 #open(OUT,">bull/$file");
 $sth = $dbh->prepare($sql);
 $sth->execute($price_date) or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) 
{
 $ticker_id = $row[0];
 $ticker = $row[1];

 $query1 = 'select MIN(price_date) as minp from tickerprice a, (select MAX(price_date)as maxp from tickerprice where (ema_diff_5_35 - ema_macd_5) > 0 and ticker_id = ?) b  where (a.ema_diff_5_35 - a.ema_macd_5) < 0 and a.ticker_id = ? and a.price_date > b.maxp';
 $sth1 = $dbh->prepare($query1);
 $sth1->execute($ticker_id,$ticker_id) or die "SQL Error: $DBI::errstr\n";  
  while (@row1 = $sth1->fetchrow_array) 
   {
     $minp = $row1[0];
   }
    $sth1->finish;
  $query2 = 'select count(*) from tickerprice where ticker_id = ? and price_date >= ?'; 
 $sth2 = $dbh->prepare($query2);
 $sth2->execute($ticker_id,$minp) or die "SQL Error: $DBI::errstr\n";
  while (@row2 = $sth2->fetchrow_array)
   {
     $reccnt = $row2[0];
   }
   $sth2->finish;
  if ($reccnt !=  $nodays){next;}
   $query3 = 'select (ema_diff_5_35 - ema_macd_5), price_date from tickerprice where ticker_id = ? and price_date >= ? order by price_date asc';
 $sth3 = $dbh->prepare($query3);
 $sth3->execute($ticker_id,$minp) or die "SQL Error: $DBI::errstr\n";
 $leastval = 0; 
 $days = 0;
 $signal = 0;
  while (@row3 = $sth3->fetchrow_array)
   {
     $days++;
     if ( $days < ($nodays - 1))
     {
      if ($row3[0] <= $leastval)
      {
         $leastval = $row3[0];
         $cur_date = $row3[1];
      }
     }
     else
     {
      if ($row3[0] >= $leastval)
        {
          #$cur_date = $row3[1];
          $signal = 1;
        } 
        else
        {
          $signal = 0;
        }
     }
   }
   $sth3->finish; 
   #print "$cur_date,$price_date,$ticker_id,$ticker\n";

   if ($cur_date ne $price_date_prev){next;}
   if (!$signal){next;}
 $sth4->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
  while (@row4 = $sth4->fetchrow_array)
   {
     if ($row4[5] > 5)
     {
        print "$row4[0],$row4[1],$row4[2],$row4[3],$nodays\n";
     }
   }
   $sth4->finish;

}
 close (OUT); 
 $sth->finish;
 $dbh->disconnect; 
