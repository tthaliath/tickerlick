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
#my ($ticker_id) = $q->param("tickid");
my ($ticker_id) = 10909;
my $x = "";
my $macd = "";
my $signal = "";
my $signaltop = "";
my $maxticks = 390;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1, rsi_14, 30 as bottomline, 70 as topline from (select a.price_date, rsi_14  from tickerpricersi a where a.ticker_id = ".$ticker_id." and price_date = '2015-09-04' ORDER BY a.price_date DESC LIMIT 0,100) as abc where rsi_14 is not null order by price_date ASC;";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
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
 my @macd = split (/\,/,$macd);
 my $noticks = scalar (@macd);
my $gap = $maxticks - $noticks;
my @gaparr = ('undef')x$gap;
my @gaparr30 = (30)x$gap;
my @gaparr70 = (70)x$gap;
my $gapstr = join (",",@gaparr);
my $gapstrb = join (",",@gaparr30);
my $gapstrt = join (",",@gaparr70);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 #my $min = abs(floor(min (@macd)));
 #my $max = ceil(max (@macd));
 my $min = 0;
 my $max = 100; 
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = $x.",".$gapstr;
$macd = $macd.",".$gapstr;
$signal = $signal.",".$gapstrb;
$signaltop = $signaltop.",".$gapstrt;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$signaltop = '['.$signaltop.']';
my $str = "(".$x.",".$signal.",".$signaltop.",".$macd.")";
#print "$str\n";
#exit 1;
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => '9.30     10         11          12          1          2          3          4',
      y_label           => 'Histogram',
      title             => 'RSI (14) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 0,
      line_width        => 3,
	box_axis => 1, 
        x_label_skip => 60,
        x_tick_offset => 0,
        x_ticks  => 0,
	#x_tick_offset => 2,
        y_number_format    => "%d", 
        skip_undef => 1,
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
