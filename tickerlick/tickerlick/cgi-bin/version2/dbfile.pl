   use warnings ;
    use strict ;
    use DB_File ;
    use DBI;
    our (%h, $k, $v,@row) ;
    my $query= "select ticker from tickermaster where etf_flag = 'Y'";
    unlink "etfsecs" ;
    tie %h, "DB_File", "etfsecs", O_RDWR|O_CREAT, 0666, $DB_HASH 
        or die "Cannot open file 'etfsecs': $!\n";
    my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') ||  die "Connection Error: $DBI::errstr\n";

my $sth = $dbh->prepare($query);
$sth->execute();
while (@row = $sth->fetchrow_array) {
        $h{$row[0]} = 1;
 }
$sth->finish;
$dbh->disconnect;

    # print the contents of the file
    while (($k, $v) = each %h)
      { print "$k -> $v\n" }
