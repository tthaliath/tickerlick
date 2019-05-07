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
 $sql ="select a.price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = 9 ORDER BY a.price_date DESC LIMIT 0,50";
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
print "$x\n";
print "$macd\n";
print "$signal\n";
@data = (
"[".$x."]",
"[".$macd."]",
"[".$signal."]"
);
exit 1;
#@data = (
#[2012-11-09,2012-11-08,2012-11-07,2012-11-06,2012-11-05,2012-11-02,2012-11-01,2012-10-31,2012-10-26,2012-10-25,2012-10-24,2012-10-23,2012-10-22,2012-10-19,2012-10-18,2012-10-17,2012-10-16,2012-10-15,2012-10-12,2012-10-11,2012-10-10,2012-10-09,2012-10-08,2012-10-05,2012-10-04,2012-10-03,2012-10-02,2012-10-01,2012-09-28,2012-09-27,2012-09-26,2012-09-25,2012-09-24,2012-09-21,2012-09-20,2012-09-19,2012-09-18,2012-09-17,2012-09-14,2012-09-13,2012-09-12,2012-09-11,2012-09-10,2012-09-07,2012-09-06,2012-09-05,2012-09-04,2012-08-31,2012-08-30,2012-08-29],
#-25.8971,-24.5281,-21.4761,-19.3302,-18.8404,-18.121,-16.1427,-15.3929,-14.0878,-13.1002,-12.2129,-11.6454,-10.3979,-10.7587,-8.59991,-8.04059,-8.42944,-9.33051,-8.81366,-7.51166,-5.57715,-4.33167,-2.16321,0.400391,2.19751,3.01251,3.53577,5.18494,7.41077,9.35852,10.2603,12.9043,15.2406,16.2452,16.3432,16.3733,15.827,14.9191,13.7592,12.9454,12.5628,13.2349,14.8368,16.4471,16.4611,16.6636,17.2943,17.3655,18.1954,19.1291],
#-19.8697,-18.3628,-16.8215,-15.6579,-14.7398,-13.7146,-12.613,-11.7306,-10.815,-9.99674,-9.22088,-8.47288,-7.67975,-7.00021,-6.06059,-5.42576,-4.77205,-3.8577,-2.4895,-0.908462,0.742338,2.32221,3.98568,5.5229,6.80353,7.95504,9.19067,10.6044,11.9593,13.0964,14.0309,14.9736,15.4909,15.5535,15.3806,15.1399,14.8315,14.5826,14.4985,14.6833,15.1178,15.7566,16.387,16.7746,16.8565,16.9554,17.0283,16.9618,16.8609,16.5273]
#);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(700,500);

#Set the graph options.
  $graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 25,
      y_tick_number     => 9,
      y_label_skip      => 2,
      x_labels_vertical => 1 
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

