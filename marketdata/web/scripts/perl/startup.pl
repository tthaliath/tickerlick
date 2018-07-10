#!/usr/bin/perl
#
use strict;
use warnings;
use lib qw ( /home/tickerlick/Tickermain);
use lib qw( /home/tickerlick/cgi-bin);
$ENV{MOD_PERL} or die "not running under mod_perl!";
print "loading perl modules\n";
use ModPerl::Registry ( );
use LWP::Simple ( );
use Apache::DBI ( );
use DBI ( );
use Webcrawler( );
use TickerDB ( );
use DMA ( );
use GetTickerData ( );
use UpdateTickerPriceData ( );
use TickerMain ( );
use DMASR ( );
use Carp ( );
$SIG{__WARN__} = \&Carp::cluck;

use CGI ( );
CGI->compile(':all');
my ($PASSWORD) = $ENV{DBPASSWORD};
Apache::DBI->connect_on_init
  ("'dbi:mysql:tickmaster","root", $PASSWORD,
   {
    PrintError => 1, # warn( ) on errors
    RaiseError => 1, # don't die on error
    AutoCommit => 1, # commit executes immediately
   }
  );
1;
