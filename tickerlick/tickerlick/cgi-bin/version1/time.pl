#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple qw! $ua !;
#use Time::HiRes qw! time !;

Main( @ARGV );
exit( 0 );

sub Main {
    print time, "\n";
    $ua->timeout( 10);
    $ua->show_progress(1);
    my $response = $ua->get("http://finance.yahoo.com/q?s=SYLD");
    #print time, "\n";
   if ($response->is_success) {
    print $response->decoded_content;  # or whatever
   }
   else {
    die $response->status_line;
}


}
__END__
1301533357.73438
** GET http://example.com/ ==> 500 Can't connect to example.com:80 (timeout)
1301533357.96767


