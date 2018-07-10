#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
use strict;
use warnings;
my $tickid = $ARGV[0];
my $tickidmax =  $tickid;
my $offset = 0; 
my $dmaday = 0;
my ($PASSWORD) = $ENV{DBPASSWORD};
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
while ($tickid <= $tickidmax)
{
 $dmaday = 5;
$offset = 0;
my $dma5 = new DMA($dmaday,$dbh); 
$offset = &getoffset($tickid);
$offset -= 5;
#print "$tickid\t$offset\n";
if ($offset >= 0){$dma5->setEMAStart($tickid,$offset);}
$dmaday = 35;
$offset -= 30;
my $dma35 = new DMA($dmaday,$dbh);
 print "$tickid\t$offset\n";
 if ($offset >= 0){$dma35->setEMAStart($tickid,$offset);}
 $tickid++;
}

sub getoffset 
{
  my ($tickid) = shift;
  my ($offset);
  my ($query,$sth,@row,$ret);
  #calculate $offset
  $query = "select count(*) as cnt from tickerprice where ticker_id = $tickid";
  $sth = ${dbh}->prepare($query);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
  #print "$query\n";
  while (@row = $sth->fetchrow_array)
  {
     $offset = $row[0];

  }
  $sth->finish;
  return $offset;
} 
$dbh->disconnect; 
