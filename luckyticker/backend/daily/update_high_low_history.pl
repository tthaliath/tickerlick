#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$i = 0;
open (F,"pricehisthl.sql");
while (<F>)
{
  chomp;
  #print "$_\n";
  $dbh->do($_);
  $i++;
  if ($i == 100000){print "$i\n";$i=0;}
}
$dbh->disconnect;
close (F);
1;
