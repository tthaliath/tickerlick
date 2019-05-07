#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
sub getsecfiles
{
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
my $ticker = shift;
my $thirty_days = 60 * 24 * 60 * 60;
my ($old_day, $old_month, $old_year) = (localtime(time - $thirty_days))[3..5];
my $cutoff = sprintf('%04d%02d%02d', 
                     $old_year + 1900, $old_month + 1, $old_day);
#print "$cutoff\n";
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20151127.csv");
$sql = "select ticker_id,ticker from tickermaster where ticker = '$ticker'";
#print "$sql\n";
my $sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {	
	$ticker_id = $row[0];
        $ticker = $row[1];
        $ticker =~ s/\-//g;
        #$ticker = 'BRKB';
        #print "$ticker\n";
	$url = "https://www.sec.gov/cgi-bin/browse-edgar?CIK=$ticker&owner=exclude&action=getcompany&Find=Search";
        $str = get($url);
	if (!$str){next;}
        $str =~ s/\n/ /g;
         while ( $str =~ /<tr.*?>.*?<td.*?nowrap.*?>(.*?)<\/td>.*?<td.*?nowrap.*?><.*?href\=?\"(.*?)\".*?<\/a>.*?<td.*?>(.*?)<\/td>.*?<td>(.*?)<\/td>.*?<\/tr>/g)
          {
             $type = $1;
             $url2 = $2;
             $desc = $3;
             $dt = $4;
             $dt =~ s/\-//g;
             if ($dt < $cutoff){next;}
             $typemain = $type;
             if ($type !~  m/10-Q|10-K|8-K|11-K|13-F|S-8|424B2/i){next;}
             if ($type =~ /(.*?)\//){$type = $1;}
             $url2 = "https://www.sec.gov".$url2;
             #print "$url2\n";
#<td scope="row">10-Q</td>
#            <td scope="row"><a href="/Archives/edgar/data/1018724/000101872416000324/amzn-20160930x10q.htm">amzn-20160930x10q.htm</a></td>
#            <td scope="row">10-Q</td>
             $str2 =get($url2);
             #print "$typemain\n";
             #print "$type,$str2\n";
             if (!$str2){next;}
             $str2 =~ s/\n/ /g;
             #if ($str2 =~ /<tr>.*?<td.*?scope.*?>.*?<td.*?scope.*?>.*?<\/td>.*?<td.*?scope.*?><.*?href\=?\"(.*?\.[htm|html])\".*?<\/a>.*?<td.*?scope.*?>.*?$type.*?<\/td>.*?<\/tr>/)
             if ($str2 =~ /<tr>.*?><.*?href\=?\"(.*?)\".*?<\/a>.*?<td.*?scope.*?>.*?$type.*?<\/td>.*?<\/tr>/i)
                {
                  $url3 =  "https://www.sec.gov".$1;
                  if ($url3 =~ /.*\/(.*?)$/){$fname = $1;}
                  $ins_sql = "replace into sec_filing (ticker_id,ticker,file_type,file_url,file_name,file_date) values ($ticker_id,'$ticker','$typemain','$url3','$fname','$dt')";
                  #print "$ins_sql\n";
                  $ret = $dbh->do($ins_sql);
                  #print "$ticker_id,$ticker,$typemain,$url3,$dt,$fname\n";
              }
          }
        close (OUT);
}
$sth->finish;
$dbh->disconnect;
return 1;
}
1;
