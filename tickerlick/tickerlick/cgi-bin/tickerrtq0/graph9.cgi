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
my ($q) = new CGI;
my ($ticker_id) = $q->param("tickid");
my $x = "";
my $macd = "";
my $signal = "";
my $macd2 = "";
my $signal2 = "";
my ($k) = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from (select a.price_date, a.ema_diff,a.ema_macd_9, (a.ema_diff - a.ema_macd_9) as signalstrength, a.ema_diff_5_35,a.ema_macd_5, (a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id =".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc order by price_date ASC";
#print "price_date,close_price,spy_close,dma_10,spydma10,dma_50,spydma50,dma_200,spydma200\n";
# print "$sql\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[1].",";
   $signal .= $row[2].",";
   $macd2 .= $row[3].",";
   $signal2 .= $row[4].",";
}
 $sth->finish;
 $dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 $macd2 =~ s/(.*)\,$/\1/;
 $signal2 =~ s/(.*)\,$/\1/;
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$macd2 = '['.$macd2.']';
$signal2 = '['.$signal2.']';
my $str = "(".$x.",".$signal.",".$macd.")";
my $str2 = "(".$x.",".$signal2.",".$macd2.")";
my @data = eval ($str);
my @data2 = eval ($str2);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(700,350);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'MACD1226/Signal',
      title             => 'MACD (12,26,9) Chart',
      y_max_value       => 30,
      y_tick_number     => 9,
      y_label_skip      => 1,
      x_labels_vertical => 1,
      y_tick_number     => 5,
      line_width        => 2,
      boxclr            => marine ,
  ) or die $graph->error;

my $graph2 = GD::Graph::lines->new(700,350);

#Set the graph options.
  $graph2->set(
      x_label           => 'Date',
      y_label           => 'MACD535/Signal',
      title             => 'MACD (5,35,5) Chart',
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
  my $gd2 = $graph2->plot(\@data2) or die $graph2->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  my $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  #print $graph->plot(\@data)->$format();
  print $graph2->plot(\@data2)->$format();
