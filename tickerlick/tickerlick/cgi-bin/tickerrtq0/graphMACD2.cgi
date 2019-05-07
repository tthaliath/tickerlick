#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

use GD;
use GD::Graph;
use GD::Graph::lines;
#print "Content-type:text/html\n\n";
use DBI;
use CGI;
use POSIX;
use List::Util qw( min max );
my ($q) = new CGI;
my ($ticker_id) = $q->param("tickid");
my $x = "";
my $macd2 = "";
my $signal2 = "";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2,price_date from (select a.price_date,a.ema_diff_5_35,a.ema_macd_5,(a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id =".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where signalstrength2 is not null order by price_date ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd2 .= $row[1].",";
   $signal2 .= $row[2].",";
}

 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd2 =~ s/(.*)\,$/\1/;
 $signal2 =~ s/(.*)\,$/\1/;
 my @macd = split (/\,/,$macd2);
 my @bigarr = split (/\,/,$signal2);
 push (@bigarr,@macd);
 my $min = floor(min (@bigarr));
 my $max = ceil(max (@bigarr));
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd2 = '['.$macd2.']';
$signal2 = '['.$signal2.']';
my $str2 = "(".$x.",".$signal2.",".$macd2.")";
my @data2 = eval ($str2);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).

my $graph2 = GD::Graph::lines->new(500,300);

#Set the graph options.
  $graph2->set(
      x_label           => 'Date',
      y_label           => 'MACD535/Signal',
      title             => 'MACD (5,35,5) Crossover Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 5,
      y_label_skip      => 1,
      x_labels_vertical => 1,
      x_label_skip      => 3,
      line_width        => 2,
      boxclr            => marine ,
  ) or die $graph->error;

#and plot the graph.
  my $gd2 = $graph2->plot(\@data2) or die $graph2->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  my $format = $graph2->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph2->plot(\@data2)->$format();
