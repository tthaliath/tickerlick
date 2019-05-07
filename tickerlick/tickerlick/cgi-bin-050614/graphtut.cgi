#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

print "Content-type:text/html\n\n";
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my ($q) = new CGI;
my ($fname) = $q->param("fname");
print start_html("Environment");
# open the pipe to sendmail
open (MAIL, "|/usr/sbin/sendmail -oi -t") or 
   "Can\'t fork for sendmail: $!\n";

# change this to your own e-mail address
my $recipient = 'thaliath@hotmail.com';

# Start printing the mail headers
# You must specify who it's to, or it won't be delivered:

print MAIL "To: $recipient\n";

# From should probably be the webserver.

print MAIL "From: tthaliath\@gmail.com\n";

# print a subject line so you know it's from your form cgi.

print MAIL "Subject: Form Data\n\n";


foreach my $key (sort(keys(%ENV))) {
    print MAIL  "$key = $ENV{$key}<br>\n";
}
close (MAIL);
my $form = '<form action=graphtut.cgi method="GET" >
            <input type="text" name=fname>
            <input type="text" name=lname>
            <input type="submit"><input type="reset">
             </form>';
print "$form\n";


print "<table><tr><td>$fname</td><td>".$q->param('lname')."</td></tr></table>";

print end_html;

