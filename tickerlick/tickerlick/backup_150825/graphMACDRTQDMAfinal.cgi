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
my $ticker_id = 10909;
my $x = "";
my $dma200 = "";
my $signal = "";
my $rtq = "";
my $dma50 = "";
my $dma10 = "";
my ($fill) = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0';
#my ($fill) = "'','','','','','','','','','','','','','','','','','','','','','','',','','','',''";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select seq, 0 as centerline,rtq,dma_200,dma_10,dma_50 from (select a.rtq,a.seq,a.dma_200,a.dma_50,a.dma_10 from tickerrtq a where a.ticker_id =".$ticker_id." and price_date = '2015-08-11' ORDER BY a.seq ASC LIMIT 0,2100) as abc order by seq ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $dma200 .= $row[3].",";
   $signal .= $row[1].",";
   $rtq  .= $row[2].",";
   $dma50 .= $row[5].",";
   $dma10 .= $row[4].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $dma200 =~ s/(.*)\,$/\1/;
 $dma50 =~ s/(.*)\,$/\1/;
 $dma10 =~ s/(.*)\,$/\1/;

 $signal =~ s/(.*)\,$/\1/;
 $rtq =~ s/(.*)\,$/\1/; 
 my @macd = split (/\,/,$rtq);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 my $min = abs(floor(min (@macd)));
 my $max = ceil(max (@macd));
 if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$dma200 = '['.$dma200.']';
$dma50 = '['.$dma50.']';
$dma10 = '['.$dma10.']';
#$rtq = $rtq.",".$fill.",".$fill.",".$fill.",".$fill.",".$fill.",".$fill.",".$fill.",".$fill.",".$fill;
$rtq = '['.$rtq.']';
#print "$rtq\n";
#exit 1;
$signal = '['.$signal.']';
#my $str = "(".$x.",".$signalbottom.",".$rtq.",".$dma_20.",".$signaltop.")";
#my $str = "(".$x.",".$rtq.",".$dma50.",".$dma10.")";
my $str = "(".$x.",".$rtq.")";

#my $str = "(".$x.",".$signal.",".$rtq.")";
#print "$str\n";
#exit 1;
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.
my ($fill) = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0';
my ($fill) = "'','','','','','','','','','','','','','','','','','','','','','','',','','','',''";
#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(1000,200);

#Set the graph options.
  $graph->set( 
      x_label           => '',
      y_label           => 'Histogram',
      title             => 'DMA Vs price Intra Day Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 5,
      y_label_skip      => 0,
      x_labels_vertical => 1,
      line_width        => 2,
	box_axis => 1, 
	x_label_skip => 25, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => marine,
      dclrs       => ['cyan', 'green','red','blue'],

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
