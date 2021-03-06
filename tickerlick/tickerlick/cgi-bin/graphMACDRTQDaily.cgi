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
#my $ticker_id = 10909;
my $x = "";
my $macd = "";
my $signal = "";
my $rtq = "";
my $maxticks = 390;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select seq, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) * 10 as signalstrength2, 0 as centerline,rtq from (select a.rtq,a.ema_diff_5_35,a.ema_macd_5,(a.ema_diff_5_35 - a.ema_macd_5) as signalstrength2,a.seq from tickerrtq1 a where a.ticker_id =".$ticker_id." and price_date = '2015-09-04' ORDER BY a.seq DESC LIMIT 0,200) as abc where signalstrength2 is not null order by seq ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $macd .= $row[3].",";
   $signal .= $row[4].",";
   $rtq  .= $row[5].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $macd =~ s/(.*)\,$/\1/;
 $signal =~ s/(.*)\,$/\1/;
 $rtq =~ s/(.*)\,$/\1/; 
 my @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 my $min = abs(floor(min (@macd)));
 my $max = ceil(max (@macd));
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
 my $noticks = scalar (@macd);
my $gap = $maxticks - $noticks;
my @gaparr = ('undef')x$gap;
my @gaparr1 = (0)x$gap;
my $gapstr = join (",",@gaparr);
my $gapstr1 = join (",",@gaparr1);
$x = $x.",".$gapstr;
$signal = $signal.",".$gapstr1;
$macd = $macd.",".$gapstr;
 #my @bigarr = split (/\,/,$signal);
$x = '["'.$x.'"]';
$macd = '['.$macd.']';
$rtq = '['.$rtq.']';
#print "$rtq\n";
$signal = '['.$signal.']';
#my $str = "(".$x.",".$signalbottom.",".$rtq.",".$dma_20.",".$signaltop.")";
#my $str = "(".$x.",".$signal.",".$rtq.",".$macd.")";
my $str = "(".$x.",".$signal.",".$macd.")";
#print "$str\n";
#exit 1;
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(500,200);

#Set the graph options.
 $graph->set(
      x_label           => '9.30     10         11          12          1          2          3          4',
      y_label           => 'DMA/Price',
      title             => 'MACD(5,35,5) Intra Day Chart',
      y_max_value       => $max,
      y_min_value       => -$max,
      y_tick_number     => 6,
      y_label_skip      => 6,
      x_labels_vertical => 0,
      line_width        => 3,
        box_axis => 1,
        x_label_skip => 60,
        x_tick_offset => 0,
        x_ticks  => 0,
        y_number_format    => "%d",
      boxclr            => marine,
      dclrs       => ['cyan','green','red','blue'],
       skip_undef => 1,
  ) or die $graph->error;
#      dclrs       => ['green','blue', 'cyan', 'red'],
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
