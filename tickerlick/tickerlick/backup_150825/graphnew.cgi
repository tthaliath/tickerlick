#!/usr/bin/perl
use GD::Graph;
use GD::Graph::lines;

use DBI;

my $x = "";
my $macd = "";
my $signal = "";
my ($k) = 0;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = 9 ORDER BY a.price_date DESC LIMIT 0,50";
#print "price_date,close_price,spy_close,dma_10,spydma10,dma_50,spydma50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   $k++;
   $x .= $k.",";
   $macd .= $row[1].",";
   $signal .= $row[2].",";
 #print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8]\n";
} 
 $sth->finish;
 $dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
print "$macd\n";
print "$signal\n"; 
@data = ([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
[-25.8971,-24.5281,-21.4761,-19.3302,-18.8404,-18.121,-16.1427,-15.3929,-14.0878,-13.1002,-12.2129,-11.6454,-10.3979,-10.7587,-8.59991,-8.04059,-8.42944,-9.33051,-8.81366,-7.51166],
[-19.8697,-18.3628,-16.8215,-15.6579,-14.7398,-13.7146,-12.613,-11.7306,-10.815,-9.99674,-9.22088,-8.47288,-7.67975,-7.00021,-6.06059,-5.42576,-4.77205,-3.8577,-2.4895,-0.908462]
);
#print "@data\n";
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(900, 700);

#Set the graph options.
  $graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 2,
      y_min_value       => -27,
      y_tick_number     => 20,
      y_label_skip      => 2 
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

