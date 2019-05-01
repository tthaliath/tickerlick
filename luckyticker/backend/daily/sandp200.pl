#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
open (F,"sandp200_102615.csv");
while (<F>)
{
 chomp;
 $ticker = $_;
 $query = "update tickermaster set tflag2 = 'Y' where ticker = '$ticker'";
 print "$query\n";
 $dbh->do($query);
}
     $dbh->disconnect;
close (F);
