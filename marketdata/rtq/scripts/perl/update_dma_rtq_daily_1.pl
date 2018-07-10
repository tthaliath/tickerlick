#!/usr/bin/perl
use lib '/home/tthaliath/Tickerdaily';
use DBI;
use DMARTQDAILY;
use strict;
use warnings;
my $proc_ord_id = $ARGV[0];
my $price_date = $ARGV[1];
my $prev_date = $ARGV[2];
my $dmaday = 10;
my ($PASSWORD) = $ENV{DBPASSWORD};
my(@row,$tickid,@initrow);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
#print "Calculating DMA10\n";
my $dma10 = new DMARTQDAILY($dmaday,$dbh,$price_date);
#my $reccount = $dma10->getreccount($tickid);
my $offset = 1 ;
my $query ="select a.ticker_id from  tickermaster a, rtq_proc_master1 b where b.proc_ord_id = ? and a.ticker_id = b.ticker_id  and a.tflag2 = 'Y'";
 
#print "$query\n";
 my $sth = $dbh->prepare($query);
  $sth->execute($proc_ord_id) or die "SQL Error: $DBI::errstr\n";
   #print "$query\n";
   #print "seq,first_row_flag,prev_avg_gain,prev_avg_loss,curr_gain, curr_loss,avg_gain ,avg_loss\n";
while (@initrow =  $sth->fetchrow_array)
{
    push (@row,$initrow[0]);
}

foreach $tickid (@row)
{

#print "$tickid\t$offset\n";
$dma10->setDMA($tickid,$offset);
}
#print "Calculating DMA20\n";
$dmaday = 20;

my $dma20 = new DMARTQDAILY($dmaday,$dbh,$price_date);
foreach $tickid (@row)
{
 #print "$tickid\t$offset\n";
  $dma20->setDMA($tickid,$offset);
}
#print "Calculating bollinger band sd\n";
$dmaday = 20;

$dma20 = new DMARTQDAILY($dmaday,$dbh,$price_date);
foreach $tickid (@row)
{
 #print "$tickid\t$offset\n";
 
   $dma20->setDMASD($tickid,$offset);
}
#print "Calculating DMA50\n";
$dmaday = 50;

my $dma50 = new DMARTQDAILY($dmaday,$dbh,$price_date);
foreach $tickid (@row)
{
 #print "$tickid\t$offset\n";
 $dma50->setDMA($tickid,$offset);
}
#print "Calculating DMA200\n";
$dmaday = 200;

my $dma200 = new DMARTQDAILY($dmaday,$dbh,$prev_date);
foreach $tickid (@row)
{
 #print "$tickid\t$offset\n";
 $dma200->setDMA($tickid,$offset);
}
 $sth->finish;
$dbh->disconnect;

