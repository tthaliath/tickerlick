#!/usr/bin/perl
use LWP::Simple;

$url = 'http:://eoddata.com/data/filedownload.aspx?e=INDEX&sd=20180427&ed=20180427&d=5&k=d4jefs5yau&o=d&ea=1&p=0';
$str = get($url);
        open (OUT,">eodtoday.csv");
        print OUT "$str";
        close (OUT);

t

t
eoddata.com/data/filedownload.aspx?e=USE&sd=20180427&ed=20180427&d=5&k=d4jefs5yau&o=d&ea=1&p=0
