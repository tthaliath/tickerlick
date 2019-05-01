#!/usr/bin/perl
use LWP::Simple;
use DBI;
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
my $ticker = $ARGV[0];
my $sixty_days = 5 * 24 * 60 * 60;
my ($old_day, $old_month, $old_year) = (localtime(time - $sixty_days))[3..5];
my $cutoff = sprintf('%04d%02d%02d', 
                     $old_year + 1900, $old_month + 1, $old_day);
#print "$cutoff\n";
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20151127.csv");
$sql = "select ticker_id,ticker from tickermaster where price_flag = 'Y' and tflag = 'Y'";
#print "$sql\n";
my $sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {	
	$ticker_id = $row[0];
        $ticker = $row[1];
	#$filename = "\/home\/tthaliath\/tickerlick\/daily\/sec\/data\/".$ticker_id."\.csv";
        #print "$ticker\n";
	#if (-e $filename){next;}
	$url = "https://www.sec.gov/cgi-bin/browse-edgar?CIK=$ticker&owner=exclude&action=getcompany&Find=Search";
        #print "$url\n";
        $str = get($url);
	if (!$str){next;}
         $str =~ s/\n/ /g;
#<tr class="blueRow">
#<td nowrap="nowrap">10-Q</td>
#<td nowrap="nowrap"><a href="/Archives/edgar/data/1018724/000101872416000324/0001018724-16-000324-index.htm" id="documentsbutton">&nbsp;Documents</a>&nbsp; <a href="/cgi-bin/viewer?action=view&amp;cik=1018724&amp;accession_number=0001018724-16-000324&amp;xbrl_type=v" id="interactiveDataBtn">&nbsp;Interactive Data</a></td>
#<td class="small" >Quarterly report [Sections 13 or 15(d)]<br />Acc-no: 0001018724-16-000324&nbsp;(34 Act)&nbsp; Size: 5 MB            </td>
#            <td>2016-10-28</td>
#            <td nowrap="nowrap"><a href="/cgi-bin/browse-edgar?action=getcompany&amp;filenum=000-22513&amp;owner=exclude&amp;count=40">000-22513</a><br>161956601         </td>
#         </tr>
          #open (OUT,">$filename");
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
}
$sth->finish;
$dbh->disconnect;

