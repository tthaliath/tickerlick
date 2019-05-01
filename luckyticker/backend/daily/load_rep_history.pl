#!/usr/bin/perl

use DBI;
my ($NOW,$PREVDATE);
$PREVDATE = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select distinct price_date from tickerprice where price_date >= '2015-01-01' order by price_date asc";
#print "50,dma_200,spydma200\n";
#print "$sql\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
    $NOW = $row[0];	
    if (!$PREVDATE)
    {
        $PREVDATE = $NOW;
        next;
    }	
   print "$NOW\t$PREVDATEW\n";
  #system("/home/tthaliath/tickerlick/daily/bullishquery_5355_history.pl $NOW $PREVDATE");
#system("/home/tthaliath/tickerlick/daily/bearishquery_5355_history.pl $NOW $PREVDATE");
#system("/home/tthaliath/tickerlick/daily/macd_bullish_os_history.pl  $NOW $PREVDATE");
#system("/home/tthaliath/tickerlick/daily/macd_bearish_ob_history.pl $NOW $PREVDATE");
#system ("python /home/tthaliath/tickerlick/daily/rsi_rep_hist.py $NOW");
#system ("python /home/tthaliath/tickerlick/daily/stoch_rep.py $NOW");
#system ("python /home/tthaliath/tickerlick/daily/bolli_rep_hist.py $NOW");
system("/home/tthaliath/tickerlick/daily/extreme_os.pl $NOW");
system("/home/tthaliath/tickerlick/daily/extreme_ob.pl $NOW")
}
 $sth->finish;
 $dbh->disconnect; 
