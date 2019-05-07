#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:mysql','tickmaster','Tanmaya1')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select * from user";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "@row\n";
 } 
 
