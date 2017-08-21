#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = $ARGV[0];
my $tickidmax =  $tickid;
my $offset = 0; 
my $dmaday = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
while ($tickid <= $tickidmax)
{
 $dmaday = 12;
$offset = 0;
my $dma12 = new DMA($dmaday,$dbh); 
$offset = &getoffset($tickid);
$offset -= 12;
print "$tickid\t$offset\n";
if ($offset >= 0){$dma12->setEMAStart($tickid,$offset);}
$dmaday = 26;
$offset -= 14;
my $dma26 = new DMA($dmaday,$dbh);
 print "$tickid\t$offset\n";
 if ($offset >= 0){$dma26->setEMAStart($tickid,$offset);}
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
