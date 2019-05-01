#!/usr/bin/perl
use LWP::Simple;
use DBI;
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
my $today = $ARGV[0];
my $ticker = $ARGV[1];
#2014-05-28
if ($today  =~ /(.*?)\-(.*?)\-(.*)$/)
{
   $year = $1;
   $mon = $2;
   $day = $3;
}

if ($mon =~ /^0(.*)$/ )
{
   $mon = $1;
}
$mon = $mon - 1;
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20151127.csv");
$sql = "select ticker_id,ticker from tickermaster where price_flag = 'Y' and ticker = '$ticker'";
print "$sql\n";
my $sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {	
	$ticker_id = $row[0];
        $ticker = $row[1];
	$filename = "\/home\/tthaliath\/tickerlick\/daily\/usticker\/".$ticker_id."\.csv";
        print "$filename\n";
	if (-e $filename){next;}
	#$str = get ("http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=04&b=01&c=2014&d=04&e=01=2014&g=w");
        #$url = "http://real-chart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv"; 	
	$url = "http://ichart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv";
        print "$url\n";
        #http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=06&b=14&c=2014&d=06&e=14&f=2014&g=d&ignore=.csv
        $str = get($url);
	if (!$str){next;}
        open (OUT,">$filename");
        print OUT "$str";
        close (OUT);
 #last;
 }
$sth->finish;
$dbh->disconnect;




