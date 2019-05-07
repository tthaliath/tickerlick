#!/usr/bin/perl -w
#use lib qw(/home/tickerlick/cgi-bin);
#use lib qw(/home/tickerlick/Tickermain);
use DBI;
use strict;
use GD;
use GD::Graph;
use GD::Graph::lines;
use DBI;
use CGI;
use List::Util qw( min max );
use POSIX;
my ($q) = new CGI;
my ($ticker_id) = $q->param("tickid");
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my (@row);
my $x = "";
my $macd = "";
my $signal = "";
 my $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, 0 as centerlin,price_date from (select a.price_date, a.ema_diff,a.ema_macd_9, (a.ema_diff - a.ema_macd_9) as signalstrength from tickerprice a where a.ticker_id =".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where signalstrength is not null order by price_date ASC";
 my $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[3].",";
   $signal .= $row[4].",";
}
 $sth->finish;
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
      title             => 'MACD (12,26,9) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => -$max,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 2,
	box_axis => 1, 
	x_label_skip => 3, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => "marine",
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

$x = "";
$macd = "";
$signal = "";
 $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2, 0 as centerline,price_date from (select a.price_date,a.ema_diff_5_35,a.ema_macd_5,(a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id =".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where signalstrength2 is not null order by price_date ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[3].",";
   $signal .= $row[4].",";
}
 $sth->finish;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 $min = abs(floor(min (@macd)));
 $max = ceil(max (@macd));
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$str = "(".$x.",".$signal.",".$macd.")";
#print "$str\n";
@data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
$graph = GD::Graph::lines->new(500,200);

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
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => "marine",
      #dclrs       => ['blue', 'green', 'cyan'],

  ) or die $graph->error;

#and plot the graph.
  $gd = $graph->plot(\@data) or die $graph->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
$x = "";
$macd = "";
$signal = "";
my $signaltop = "";
 $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, rsi_14, 30 as bottomline, 70 as topline from (select a.price_date, rsi_14  from tickerpricersi a where a.ticker_id = ".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where rsi_14 is not null order by price_date ASC;";
  $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[1].",";
   $signal .= $row[2].",";
   $signaltop .= $row[3].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 $signaltop =~ s/(.*)\,$/\1/;
 @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 #my $min = abs(floor(min (@macd)));
 #my $max = ceil(max (@macd));
 $min = 0;
 $max = 100; 
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$signaltop = '['.$signaltop.']';
$str = "(".$x.",".$signal.",".$signaltop.",".$macd.")";
#print "$str\n";
@data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
$graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'Histogram',
      title             => 'RSI (14) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 2,
	box_axis => 1, 
	x_label_skip => 3, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => "marine",
      #dclrs       => ['blue', 'green', 'cyan'],

  ) or die $graph->error;

#and plot the graph.
  $gd = $graph->plot(\@data) or die $graph->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
$x = "";
$macd = "";
$signal = "";
$signaltop = "";
 $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, sma_3_3_stc_osci_14, 30 as bottomline, 70 as topline from (select a.price_date, sma_3_3_stc_osci_14  from tickerprice a where a.ticker_id = ".$ticker_id." ORDER BY a.price_date DESC LIMIT 0,50) as abc where sma_3_3_stc_osci_14 is not null order by price_date ASC;";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[1].",";
   $signal .= $row[2].",";
   $signaltop .= $row[3].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 $signaltop =~ s/(.*)\,$/\1/;
 @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 #my $min = abs(floor(min (@macd)));
 #my $max = ceil(max (@macd));
 $min = 0;
 $max = 100; 
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$signaltop = '['.$signaltop.']';
$str = "(".$x.",".$signal.",".$signaltop.",".$macd.")";
#print "$str\n";
@data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
$graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => 'Date',
      y_label           => 'Histogram',
      title             => 'Stochastic(14,3,3) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 2,
	box_axis => 1, 
	x_label_skip => 3, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => "marine",
      #dclrs       => ['blue', 'green', 'cyan'],

  ) or die $graph->error;

#and plot the graph.
  $gd = $graph->plot(\@data) or die $graph->error;

#or for CGI programs:
  use CGI qw(:standard);
  #...
  $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
