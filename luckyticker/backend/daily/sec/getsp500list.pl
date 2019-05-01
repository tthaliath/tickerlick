#!/usr/bin/perl
use LWP::Simple;
	$url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies";
        $str = get($url);
        $str =~ s/\n/ /g;
        #print "$str\n";
        open (F,">>sp500.txt");
      #<td><a rel="nofollow" class="external text" href="https://www.nyse.com/quote/XNYS:AIV">AIV</a></td>
        while ($str =~ /<a.*?href.*?(nasdaq|nyse).*?>(.*?)<\/a>/g)
         #while ($str =~ /http*?[nasdaq|nyse].*?>(.*?)<\/a>/gi)
        {
           $ticker = $2;
           #if ($ticker == 'reports'){next;}
            open (F,">>sp500.txt");
           print F "$ticker\n";
           close (F);
       }




