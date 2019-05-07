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
my $signaltop = "";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select rtq, rsi_14, 30 as bottomline, 70 as topline,seq from (select a.seq, rsi_14,rtq  from tickerrtq a where a.ticker_id = ".$ticker_id." ORDER BY a.seq DESC LIMIT 0,200) as abc where rsi_14 is not null order by seq ASC;";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[4].",";
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
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 #my $min = abs(floor(min (@macd)));
 #my $max = ceil(max (@macd));
 my $min = 0;
 my $max = 100; 
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$signal = '['.$signal.']';
$signaltop = '['.$signaltop.']';
my $str = "(".$x.",".$signal.",".$signaltop.",".$macd.")";
#print "$str\n";
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(500,200);

#Set the graph options.
  $graph->set( 
      x_label           => '',
      y_label           => 'Histogram',
      title             => 'RSI (14) Intra Day Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 3,
	box_axis => 1, 
	x_label_skip => 6, 
	#x_tick_offset => 2,
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
