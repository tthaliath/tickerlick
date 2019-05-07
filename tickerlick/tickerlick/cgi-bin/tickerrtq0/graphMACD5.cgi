#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

use GD;
use GD::Graph;
use GD::Graph::lines;
#print "Content-type:text/html\n\n";
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
 $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2, 0 as centerline from (select a.price_date,a.ema_diff_5_35,a.ema_macd_5,(a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id =".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where signalstrength2 is not null order by price_date ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[3].",";
   $signal .= $row[4].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 my @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 my $min = abs(floor(min (@macd)));
 my $max = ceil(max (@macd));
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
my $str = "(".$x.",".$signal.",".$macd.")";
#print "$str\n";
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'Histogram',
      title             => 'MACD (5,35,5) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => -$max,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 2,
	box_axis => 1, 
	x_label_skip => 3, 
	x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => marine,
      #dclrs       => ['blue', 'green', 'cyan'],

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
