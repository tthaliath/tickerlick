#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

use GD;
use GD::Graph;
use GD::Graph::lines;

use DBI;

my $x = "";
my $macd = "";
my $signal = "";
my ($k) = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from (select a.price_date, a.ema_diff,a.ema_macd_9, (a.ema_diff - a.ema_macd_9) as signalstrength, a.ema_diff_5_35,a.ema_macd_5, (a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id =9 ORDER BY a.price_date DESC LIMIT 0,50) as abc order by price_date ASC";
#print "price_date,close_price,spy_close,dma_10,spydma10,dma_50,spydma50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   $k++;
   $x .= $row[0].",";
   $macd .= $row[1].",";
   $signal .= $row[2].",";
}
 $sth->finish;
 $dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
#print "$x\n";
#print "$macd\n";
#print "$signal\n";
#exit 1;

$str = "(".$x.",".$macd.",".$signal.")";
@data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(700,350);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'MACD/Signal',
      title             => 'MACD (12,26,9) Chart',
      y_max_value       => 30,
      y_tick_number     => 9,
      y_label_skip      => 1,
      x_labels_vertical => 1,
      y_tick_number     => 5,
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
