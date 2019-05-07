#!/usr/bin/perl

 # import module
 use Finance::Quote;

 # create object
 my $q = Finance::Quote->new();

 # retrieve stock quote
 my %data = $q->fetch('nasdaq','GE');

 # print price
 print "The current price of XYZ on the NYSE is " . $data{'GE', 'price'}."\n";

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
my   $content = `/usr/bin/php /home/tickerlick/www/html/users/test.php`;
print "$content\n";
