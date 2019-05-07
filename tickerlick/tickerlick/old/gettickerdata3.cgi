#!c:\Perl\bin

use LWP::Simple;
my ($ticker,%tickerhash) ;
print "start\n";
open (R,"lastticker.txt");
while (<R>)
{
   chomp;
   $tickerhash{$_}++;
}
close (R);


open (IN,"<usticker.csv");

while (<IN>)
{
  chomp;
  $ticker = $_;
  if ( $tickerhash{$ticker}){next;}
  print "$ticker\n";
   $tickdata = "";
   $tickmain = "";
   $tickdesc = "";
  $content = get("http://finance.yahoo.com/q?s=$ticker");

#die "Couldn't get it!" unless defined $content;

if ($content)
{

$content =~ s/\n//g;
#if ($content =~ m/.*?time_rtq_ticker\"><.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/i)  {
if ($content =~ /\>NAV\&|iShares/)
{
 print "$ticker\n";
open (ETF, ">>etf.csv");
print   ETF "$ticker\n";
close (ETF);
next;
}


#if ($content =~ m/.*?Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)  {
if ($content =~ m/52wk Range.*?td class.*?>N\/A<\/td>/ )
{

$tickmain = getmain1(\$content);
}
else
{

 $tickmain = getmain2(\$content);
 }


     open (W,">>lastticker.txt");
      print W "$ticker\n";
      close (W);
        $tickerhash{$ticker}++;
      }
   else
 {

     print "undefined summary1:$ticker\n";
 }

 $content = get("http://finance.yahoo.com/q/pr?s=$ticker+Profile");

#die "Couldn't get it!" unless defined $content;

my ($tickprofile);
if ($content)
{

$content =~ s/\n//g;
$tickprofile = getprofile(\$content);
}
  $content = get("http://finance.yahoo.com/q/ks?s=$ticker+Key+Statistics");
  if ($content)
  {
  $content =~ s/\n//g;
 if ($content =~ m/Market Cap \(intraday\).*?<span id.*?>(.*?)<\/span>.*?Enterprise Value.*?td class.*?>(.*?)<\/td>.*?Trailing P\/E.*?td class.*?>(.*?)<\/td>.*?Forward P\/E.*?td class.*?>(.*?)<\/td>.*?PEG Ratio.*?td class.*?>(.*?)<\/td>.*?Price\/Sales.*?td class.*?>(.*?)<\/td>.*?Price\/Book.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/Revenue.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/EBITDA.*?td class.*?>(.*?)<\/td>.*?Fiscal Year Ends.*?td class.*?>(.*?)<\/td>.*?Most Recent Quarter.*?td class.*?>(.*?)<\/td>.*?Operating Margin.*?td class.*?>(.*?)<\/td>.*?Return on Assets.*?td class.*?>(.*?)<\/td>.*?Return on Equity.*?td class.*?>(.*?)<\/td>.*?Revenue.*?td class.*?>(.*?)<\/td>.*?Revenue Per Share.*?td class.*?>(.*?)<\/td>.*?Qtrly Revenue Growt.*?td class.*?>(.*?)<\/td>.*?Gross Profit.*?td class.*?>(.*?)<\/td>.*?EBITDA \(ttm\).*?td class.*?>(.*?)<\/td>.*?Net Income Avl to Common.*?td class.*?>(.*?)<\/td>.*?Diluted EPS.*?td class.*?>(.*?)<\/td>.*?Qtrly Earnings Growth.*?td class.*?>(.*?)<\/td>.*?Total Cash.*?td class.*?>(.*?)<\/td>.*?Total Cash Per Share.*?td class.*?>(.*?)<\/td>.*?Total Debt.*?td class.*?>(.*?)<\/td>.*?Total Debt\/Equity.*?td class.*?>(.*?)<\/td>.*?Current Ratio.*?td class.*?>(.*?)<\/td>.*?Book Value Per Share.*?td class.*?>(.*?)<\/td>.*?Operating Cash Flow.*?td class.*?>(.*?)<\/td>.*?Levered Free Cash Flow.*?td class.*?>(.*?)<\/td>.*?Beta\:.*?td class.*?>(.*?)<\/td>.*?52\-Week Change.*?td class.*?>(.*?)<\/td>.*?S.*?P500 52\-Week Change.*?td class.*?>(.*?)<\/td>.*?52\-Week High.*?td class.*?>(.*?)<\/td>.*?52\-Week Low.*?td class.*?>(.*?)<\/td>.*?50\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?200\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?Shares Outstanding.*?td class.*?>(.*?)<\/td>.*?Shares Short.*?\).*?td class.*?>(.*?)<\/td>.*?Payout Ratio.*?td class.*?>(.*?)<\/td>/i){

         $tickdesc = $2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10."\t".$11."\t".$12."\t".$13."\t".$14."\t".$15."\t".$16."\t".$17."\t".$18."\t".$19."\t".$20."\t".$21."\t".$22."\t".$23."\t".$24."\t".$25."\t".$26."\t".$27."\t".$28."\t".$29."\t".$30."\t".$31."\t".$32."\t".$33."\t".$34."\t".$35."\t".$36."\t".$37."\t".$38."\t".$39."\t".$40;
         }
   else
 {
     print "undefined det2:$ticker\n";
 }
 }
 else
 {
     print "undefined det1:$ticker\n";
 }

 $tickdata = $ticker."\t".$tickprofile."\t".$tickmain."\t".$tickdesc;
 $tickdata =~ s/\,//g;

 open (F,">>tickdata.txt");
 print F "\n$tickdata";
   close (F);

 }

 close (IN);




 sub getmain1
{
  my $contref = shift;
  my $content = $$contref;
  my($tickmain);
if ($content =~ m/Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?>(.*?)<\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)
  {

      $tickmain =  $1."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =~ s/<.*?>//g;
      }
      return   $tickmain;
}


sub getmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
if ($content =~ m/Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)
{

      $tickmain =  $1."\t".$3."\t".$4."\t".$5."-".$6."\t".$7."\t".$8."\t".$9."\t".$10;

      $tickmain =~ s/<.*?>//g;
      }
      return   $tickmain;
}

sub getprofile
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickprofile);
if ($content =~ m/<title>.*?\|(.*?)Stock.*?Sector:.*?<a href.*?>(.*?)<\/a>.*?Industry:.*?<a href.*?>(.*?)<\/a>/)
{

      $tickprofile =  $1."\t".$2."\t".$3;
      $tickprofile =~ s/\&amp\;/\&/g;

      }
elsif ($content =~ m/<title>.*?\|(.*?)Stock/)
   {
       $tickprofile =  $1."\tN\/A\tN\/A";
   }
else
 {
    $tickprofile =  "N\/A\tN\/A\tN\/A";
 }
      return   $tickprofile;

}
 exit 1;