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
$sql = "select price_date, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from (select a.price_date, a.ema_diff,a.ema_macd_9, (a.ema_diff - a.ema_macd_9) as signalstrength, a.ema_diff_5_35,a.ema_macd_5, (a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = 9 ORDER BY a.price_date DESC LIMIT 0,50) as abc order by price_date ASC";
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
$x = '"'.$x.'"';
#print "$x\n";
#print "$macd\n";
#print "$signal\n";
#exit 1;
#@data = (
#'['.$x.']',
#'['.$macd.']',
#'['.$signal.']'
#);
@data = (
["2012-08-29","2012-08-30","2012-08-31","2012-09-04","2012-09-05","2012-09-06","2012-09-07","2012-09-10","2012-09-11","2012-09-12","2012-09-13","2012-09-14","2012-09-17","2012-09-18","2012-09-19","2012-09-20","2012-09-21","2012-09-24","2012-09-25","2012-09-26","2012-09-27","2012-09-28","2012-10-01","2012-10-02","2012-10-03","2012-10-04","2012-10-05","2012-10-08","2012-10-09","2012-10-10","2012-10-11","2012-10-12","2012-10-15","2012-10-16","2012-10-17","2012-10-18","2012-10-19","2012-10-22","2012-10-23","2012-10-24","2012-10-25","2012-10-26","2012-10-31","2012-11-01","2012-11-02","2012-11-05","2012-11-06","2012-11-07","2012-11-08","2012-11-09"],
[19.1291,18.1954,17.3655,17.2943,16.6636,16.4611,16.4471,14.8368,13.2349,12.5628,12.9454,13.7592,14.9191,15.827,16.3733,16.3432,16.2452,15.2406,12.9043,10.2603,9.35852,7.41077,5.18494,3.53577,3.01251,2.19751,0.400391,-2.16321,-4.33167,-5.57715,-7.51166,-8.81366,-9.33051,-8.42944,-8.04059,-8.59991,-10.7587,-10.3979,-11.6454,-12.2129,-13.1002,-14.0878,-15.3929,-16.1427,-18.121,-18.8404,-19.3302,-21.4761,-24.5281,-25.8971],
[16.5273,16.8609,16.9618,17.0283,16.9554,16.8565,16.7746,16.387,15.7566,15.1178,14.6833,14.4985,14.5826,14.8315,15.1399,15.3806,15.5535,15.4909,14.9736,14.0309,13.0964,11.9593,10.6044,9.19067,7.95504,6.80353,5.5229,3.98568,2.32221,0.742338,-0.908462,-2.4895,-3.8577,-4.77205,-5.42576,-6.06059,-7.00021,-7.67975,-8.47288,-9.22088,-9.99674,-10.815,-11.7306,-12.613,-13.7146,-14.7398,-15.6579,-16.8215,-18.3628,-19.8697]
);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(700,350);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'MACD',
      title             => 'MACD (12,26,9) Chart',
      y_max_value       => 25,
      y_tick_number     => 9,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      y_tick_number     => 20,
      line_width        => 2,
      boxclr            => marine 
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

