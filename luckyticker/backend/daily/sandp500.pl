#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
open (F,"sandp500.csv");
while (<F>)
{
 chomp;
 ($name,$ticker,@rest) = split (/\,/,$_);
 $query = "update tickermaster set tflag = 'Y' where ticker = '$ticker'";
 print "$ticker\n";
 $dbh->do($query);
}
     $dbh->disconnect;
close (F);
