#!/usr/bin/perl
use LWP::Simple;
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
use DBI;
my ($dbh,@row,$sth2,$sql);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $today = $ARGV[0];
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

my  $sql = "select ticker_id,ticker  from ipomaster where price_flag = 'N'";
my $sth2 = $dbh->prepare($sql);
$sth2->execute();
while (@row = $sth2->fetchrow_array) {
    $ticker_id = $row[0];
    $ticker = $row[1];

	$filename = "\/home\/tthaliath\/tickerlick\/daily\/usticker\/ipo\/".$ticker_id."\.csv";
        #print "$filename\n";
	#if (-e $filename){next;}
	#$str = get ("http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=04&b=01&c=2014&d=04&e=01=2014&g=w");
        #$url = "http://real-chart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv"; 	
	$url = "http://ichart.finance.yahoo.com/table.csv?s=$ticker&d=$mon&e=$day&f=$year&g=d&a=$mon&b=$day&c=$year&ignore=.csv";
        #http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=06&b=14&c=2014&d=06&e=14&f=2014&g=d&ignore=.csv
        $str = get($url);
        print "$url\n$str\n";
	if (!$str){print "no data\n";next;}
        open (OUT,">$filename");
        print OUT "$str";
        close (OUT);
 #last;
 }

$sth2->finish;
$dbh->disconnect;



