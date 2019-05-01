#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMASD;
my ($price_date) = $ARGV[0];
my ($tickid);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $dmaday =20;
my $dma20 = new DMASD($dmaday,$dbh);
my ($reccount,$offset);
print "Calculating DMA20 SD\n";
my $offset = 0;
my $query ="select distinct ticker_id from  tickerprice where price_date = '$price_date'";
my $sth = $dbh->prepare($query);
 $sth->execute() or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
  $tickid = $row[0];
 #print "$tickid\t$offset\n";
  $dma20->setDMASDVOL20Daily($tickid,$price_date);
  $dma20->setDMASDVOL20SD($tickid,$offset);
#last;
}
$sth->finish;
$dbh->disconnect; 
