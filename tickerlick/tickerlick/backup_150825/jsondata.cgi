#!/usr/bin/perl
use CGI;
use DBI;
use JSON;


my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
# query database
my $q = CGI->new();
my $sth = $dbh->prepare('SELECT ticker,comp_name FROM tickermaster WHERE comp_name  like ?');
$sth->execute('%'.$q->param('term').'%');
#$sth->execute('%ppl%');
my $data={};
my (@f);
while ( @f = $sth->fetchrow_array){
   $data->{$f[0]} = $f[1];
}
print "Content-type: application/json; charset=iso-8859-1\n\n";
print JSON::to_json(\@data);
