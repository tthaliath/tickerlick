#!/usr/bin/perl
use LWP::Simple;
$url = "http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quote where symbol = 'YHOO'&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
$content = get ($url);
#$content =~ s/\n//g;
print "$content\n";
open INPUT, "6";
undef $/;
#$content = <INPUT>;
close INPUT;
$/ = "\n";
#if ($content =~ /(>NAV|SPDR|<h3>ETF<\/h3>|Market Vectors|\sETN\s|Direxion|ProShare|EGShares|PowerShares|Global\sX|Sprott|Cambria|PIMCO|QuantShares|DBX\s|\sETF\s\($ticker\)|AlphaDEX|FactorShares|FlexShares)/)
if ($content =~ /yfi_summary_table type_etf/)
{
    print "ffffff\n";
}
#if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range.*?<td.*?>(.*?) - (.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?EPS.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?1Y Target Est.*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td.*?>(.*?)<\/td>/)

#if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range\:.*?<td>(.*?) - (.*?)<\/td>.*?Volume\:.*?><span.*?>(.*?)<\/span>.*?Prev Close\:.*?<td.*?>(.*?)<\/td>.*?P\/E \(ttm\)\:.*?<td>(.*?)<\/td>.*?NAV.*?<td.*?>(.*?)<\/td>.*?Yield \(ttm\).*?<td>(.*?)<\/td>/)
#{
    print "$1,$2,$3,$4,$5,$6,$7,$8,$9\n";
#}
