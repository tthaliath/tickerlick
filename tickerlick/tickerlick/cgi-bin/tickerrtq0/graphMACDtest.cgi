#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

use GD;
use GD::Graph;
use GD::Graph::lines;
print "Content-type:text/html\n\n";
use DBI;
use CGI;
use List::Util qw( min max );
use POSIX;
my ($q) = new CGI;
my ($ticker_id) = $q->param("tickid");
my $x = "";
my $macd = "";
my $signal = "";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength from (select a.price_date, a.ema_diff,a.ema_macd_9, (a.ema_diff - a.ema_macd_9) as signalstrength from tickerprice a where a.ticker_id =9 ORDER BY a.price_date DESC LIMIT 0,50) as abc where signalstrength is not null order by price_date ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[3].",";
}
 $sth->finish;
 $dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 #$signal =~ s/(.*)\,$/\1/;
 my @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 my $min = floor(min (@macd));
 my $max = ceil(max (@macd));
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
#$signal = '['.$signal.']';
my $str = "(".$x.",".$macd.")";
print "$str\n";
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'MACD1226/Signal',
      title             => 'MACD (12,26,9) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => min,
      y_tick_number     => 5,
      y_label_skip      => 1,
      x_labels_vertical => 1,
      line_width        => 2,
      boxclr            => marine ,
  ) or die $graph->error;

#and plot the graph.
  my $gd = $graph->plot(\@data) or die $graph->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  my $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
