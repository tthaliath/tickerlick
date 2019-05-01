#!/usr/bin/perl

use lib '/home/tthaliath/Tickermain';
use DBI;
use T;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select * from tickermaster where ticker_id = 1;";
#print "price_date,close_price,spy_close,dma_10,spydma10,dma_50,spydma50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2]\n";
} 
 $sth->finish;
 $dbh->disconnect; 


my $dma10 = new T();
$dma10->setdmadays('AAPL');
my $ticker = $dma10->getdmadays();
print "TTT:$ticker\n";
