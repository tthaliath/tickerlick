#!/usr/bin/perl
my $proc_ord_id = $ARGV[0];
my $price_date =$ARGV[1];
use strict;
use warnings;
use DBI;
my ($PASSWORD) = $ENV{DBPASSWORD};
my ($query,@row,$sth,$ticker_id,$close_price,$firstrow,$prev_close_price,$loss,$gain,$first_row_flag,$cur_seq);
my (@row_cur_avg,$curr_gain,$curr_loss,@row_prev_avg,$avg_loss,$avg_gain,$prev_avg_loss,$prev_avg_gain,$rs,$rsi);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD) or die "Connection Error: $DBI::errstr\n";
my $prev_avg_query = "select avg_gain,avg_loss from tickerrtq7 where ticker_id = ? and price_date >= ? order by seq desc limit 1,1";
my $cur_avg_query = "select gain,loss,seq from tickerrtq7 where ticker_id = ? and price_date > ? order by seq desc limit 1";
my $upd_avg_query = "update tickerrtq7 set avg_gain = ?, avg_loss = ? ,rsi = ?, rsi_14 = ? where ticker_id = ? and seq = ?";
my $sth_prev_avg_query = $dbh->prepare($prev_avg_query);
my $sth_cur_avg_query = $dbh->prepare($cur_avg_query);
my $sth_upd_avg_query = $dbh->prepare($upd_avg_query);
#print "Calculating EMA10\n";
$query ="select a.ticker_id from  tickermaster a, rtq_proc_master1 b where b.proc_ord_id = ? and a.ticker_id = b.ticker_id  and a.tflag2 = 'Y'";#
#print "$query\n";
 $sth = $dbh->prepare($query);
 $sth->execute($proc_ord_id) or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 #print "seq,first_row_flag,prev_avg_gain,prev_avg_loss,curr_gain, curr_loss,avg_gain ,avg_loss\n";
while (@row = $sth->fetchrow_array) 
{
$ticker_id = $row[0];
#print "$ticker_id\n";
#update gain and loss 
   $sth_prev_avg_query->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
   while (@row_prev_avg = $sth_prev_avg_query->fetchrow_array)
    {
          $prev_avg_gain = $row_prev_avg[0];
          $prev_avg_loss = $row_prev_avg[1]; 
    }
    $sth_prev_avg_query->finish();
   $sth_cur_avg_query->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
   while (@row_cur_avg = $sth_cur_avg_query->fetchrow_array)
    {
       $curr_gain = $row_cur_avg[0];
       $curr_loss = $row_cur_avg[1];
       $cur_seq = $row_cur_avg[2];
       $avg_gain = (($prev_avg_gain  * 13.00) + $curr_gain) / 14.00;
       $avg_loss = (($prev_avg_loss  * 13.00) + $curr_loss) / 14.00;              
       if ($avg_gain == 0){$rs = 0;$rsi = 0;}
       elsif ($avg_loss == 0){$rs = 100;$rsi = 100;}
       else
        {
          $rs = $avg_gain/$avg_loss;
          $rsi = 100.00 - (100.00/(1.00+$rs));
        }
            $sth_upd_avg_query->execute($avg_gain,$avg_loss,$rs,$rsi,$ticker_id,$cur_seq);
            $prev_avg_gain = $avg_gain;
            $prev_avg_loss = $avg_loss;
      #print "$seq,$first_row_flag,$prev_avg_gain,$prev_avg_loss,$curr_gain, $curr_loss,$avg_gain ,$avg_loss\n";

   }
$sth_cur_avg_query->finish();
}
$sth->finish();
$dbh->disconnect; 

