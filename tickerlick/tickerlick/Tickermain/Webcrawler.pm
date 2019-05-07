package Webcrawler;

use lib '/home/tthaliath/Tickermain';
use LWP::Simple;
use strict;
use vars qw($VERSION);
$VERSION = "1.1";

sub new {
    my $class = shift;
    my $objref = {
               ticker   => shift,
               };
    bless $objref, $class;
    return $objref;
}


sub getLastPrice
{
my $class = shift;    
my ($ticker) = shift;
my ($lastprice) = 0;
my $content = get("http://ca.finance.yahoo.com/q?s=$ticker");
#print "$ticker\n";
#print "$content\n";
if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>/)
 {
   $lastprice = $1;
  #print "last:$lastprice\n";
  }
      return   $lastprice;
}

sub getToday
{
  my $class = shift;      

  my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);

  my $today = ($yr19+1900)."-".++$month. "-".$day;
  return $today;
}
 1;

__END__
