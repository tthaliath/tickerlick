#!/usr/bin/perl
#
use DBI;
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";


my $del_sql = "delete from  report where report_flag in ('OS')";
        $ret = $dbh->do($del_sql);
$dbh->disconnect;
