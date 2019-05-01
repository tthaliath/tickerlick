#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 11063;
my $tickidmax = 11608;
my ($offset) = 0;
my $dmaday = 12;
my ($norecords) = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $query ="select count(*) from tickerprice where ticker_id = ?;";
 $sth = $dbh->prepare($query);
 #print "$query\n";
 # while (@row = $sth->fetchrow_array) {
 #    $offset = $row[0];
 #
print "Calculating EMA10\n";
my $dma12 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 $sth->execute($tickid) or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) 
   {
     $norecords = $row[0];
   }   
if (!$norecords || $norecords == 0){$tickid++;next;}
$offset = $norecords - $dmaday;
if ($offset < 0){$tickid++;next;}
print "$tickid,$norecords,$offset\n";
$dma12->setEMAStart($tickid,$offset);
$tickid++;
}
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 11063;
my $dma26 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
  $sth->execute($tickid) or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
   {
     $norecords = $row[0];
   }
   if (!$norecords || $norecords == 0){$tickid++;next;}
  $offset = $norecords - $dmaday;
  if ($offset < 0){$tickid++;next;}
  print "$tickid,$norecords,$offset\n";
 $dma26->setEMAStart($tickid,$offset);
 $tickid++;
}

$sth->finish();
$dbh->disconnect; 
