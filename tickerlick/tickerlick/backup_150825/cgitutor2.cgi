#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
my ($mycookie) = "Set-Cookie: tom=engineer; expires=Nov 21, 2012;";
print "$mycookie\n";
print "Content-type:text/html\n\n";
#print "Set-Cookie: ticker=aapl";
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my ($q) = new CGI;
my ($fname) = $q->param("fname");
$cookie = $q->cookie(-name=>'MY_COOKIE',
			 -value=>'BEST_COOKIE=chocolatechip',
			 -expires=>'+4h',
			 -path=>'/');

$cookie2 = $q->cookie(-name=>'MY_COOKIE2',
                         -value=>'BEST_COOKIE2=ginger',
                         -expires=>'+4h',
                         -path=>'/');
#--------------------------------------------------------------#
#  3. Create the HTTP header and print the doctype statement.  #
#--------------------------------------------------------------#

print $q->header(-cookie=>[$cookie,$cookie2]);
print start_html("Environment");
foreach my $key (sort(keys(%ENV))) {
    print  "$key = $ENV{$key}<br>\n";
}
my $retrieve_cookie1 = cookie('MY_COOKIE');

my $retrieve_cookie2 = cookie('MY_COOKIE2');
print "<br>$retrieve_cookie1";
print "<br>$retrieve_cookie2";

my $form = '<form action=cgitutor2.cgi method="GET" >
            <input type="text" name=fname>
            <input type="text" name=lname>
            <input type="submit"><input type="reset">
             </form>';
print "$form\n";


print "<table><tr><td>$fname</td><td>".$q->param('lname')."</td></tr></table>";

print end_html;

