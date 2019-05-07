#!c:\Perl64\bin\perl

use LWP::Simple;
my ($ticker,%tickerhash) ;
print "start\n";
open (R,"lasttickeretf.txt");
while (<R>)
{
   chomp;
   $tickerhash{$_}++;
}
close (R);

open (IN,"<etf.csv");

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





#if ($content =~ m/.*?Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)  {
#print "ddd:$ticker\n";
#if ($content =~ m/52wk Range.*?<span.*?><\/td>/ )
if ($content =~ m/Volume\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/){next;}
if ($content =~ m/52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/)
{

$tickmain = getmain2(\$content);
}
else
{

 $tickmain = getmain1(\$content);
 }


     open (W,">>lasttickeretf.txt");
      print W "$ticker\n";
      close (W);
        $tickerhash{$ticker}++;
      }
   else
 {

     print "undefined summary1:$ticker\n";
 }

 if ($tickmain ne 'NOMARKETCAP')
{
 $tickdata = $ticker."\t".$tickmain;
 $tickdata =~ s/\,//g;

 open (F,">>tickdataetf.txt");
 print F "\n$tickdata";
   close (F);
  
 }
 }

 close (IN);




 sub getmain1
{
  my $contref = shift;
  my $content = $$contref;
  my($tickmain);
  #print "$content\n";
   print "main1\n";
   #open (C,">aa.txt");
   #print C "$content\n";
   #close (C); 
   #exit;
   
    if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
if ($content =~ m/.*?<span id\=\"yfs_l84_iyf\">(.*?)<\/span>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>/)
 {
 #dont process if no market cap
 
 #if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
#if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =  $1."\t".$2."-".$3."\t".$4."\t".$5."\t".$6."\t".$7;
      $tickmain =~ s/<.*?>//g;
       print "1:$tickmain\n";
      }
      return   $tickmain;
}


sub getmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
  print "main2\n";
  if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
if ($content =~ m/.*?<span id\=\"yfs_l84_iyf\">(.*?)<\/span>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>/)
 {

    #if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<td.*?>(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."-".$6."\t".$7."\t".$8."\t".$9."\t".$10;
      $      $tickmain =  $1."\t".$2."-".$2."\t".$3."\t".$4."\t".$5."\t".$6;
      $tickmain =~ s/<.*?>//g;;

      $tickmain =~ s/<.*?>//g;
      
      print "2:$tickmain\n";
      }
      return   $tickmain;
}

 exit 1;