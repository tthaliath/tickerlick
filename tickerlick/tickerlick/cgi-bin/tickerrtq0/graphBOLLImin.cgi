#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

use GD;
use GD::Graph;
use GD::Graph::lines;
use List::Util qw/ max min /;

#print "Content-type:text/html\n\n";
use DBI;
use CGI;
use List::Util qw( min max );
use POSIX;
my ($q) = new CGI;
my ($ticker_id) = $q->param("tickid");
my $x = "";
my $close_price = "";
my $signalbottom = "";
my $signaltop = "";
my $dma_20 = "";
$ticker_id = 4030;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select DATE_FORMAT(price_date, '%m/%d/%y') as price_date1,close_price,dma_20, (dma_20 + (2 * dma_20_sd)) as dma_20_top,(dma_20 -  (2 * dma_20_sd)) as dma_20_bottom from (select a.price_date,a.close_price,a.dma_20,a.dma_20_sd from tickerprice a  where  ticker_id = ".$ticker_id." ORDER BY price_date DESC LIMIT 0,100) as abc order by price_date ASC";
#print "$sql\n";

 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $close_price .= $row[1].",";
   $dma_20 .= $row[2].",";
   $signaltop .= $row[3].",";
   $signalbottom .= $row[4].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/\1/;
 $close_price =~ s/(.*)\,$/\1/;
 $dma_20 =~ s/(.*)\,$/\1/;
 $signalbottom =~ s/(.*)\,$/\1/;
 $signaltop =~ s/(.*)\,$/\1/;
 #my @macd = split (/\,/,$macd);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 my $maxmin = "select max((dma_20 + (2 * dma_20_sd))) as dmax,min((dma_20 -  (2 * dma_20_sd))) as dmin, max(close_price) pmax, min(close_price) pmin from  (select a.dma_20,a.dma_20_sd,close_price from tickerprice a  where  ticker_id = ".$ticker_id." ORDER BY price_date DESC LIMIT 0,100) as abc";
 #my $maxmin = "select max(close_price) as max,min(close_price) as min from  (select a.close_price from tickerprice a  where  ticker_id = ".$ticker_id." ORDER BY price_date DESC LIMIT 0,100) as abc";
 $sth = $dbh->prepare($maxmin);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
  my ($max,$min);
 while (@row = $sth->fetchrow_array)
 {  
  #print "$row[0]\t$row[1]\n";
  if ($row[1] < 0)
  {
    $min = floor(min($row[1]));
  } 
   else
   {
     $min = abs(floor(min ($row[1])));
   }
    $max = ceil(max ($row[0]));
 # print "$min\t$max\n";
 $max =ceil( max(@row));
 $min = floor(min(@row));
 }
 #if ($min > $max){$max = $min;}
$x =~ s/\,/\"\,\"/g;
$x = '["'.$x.'"]';
$close_price = '['.$close_price.']';
$dma_20 = '['.$dma_20.']'; 
$signalbottom = '['.$signalbottom.']';
$signaltop = '['.$signaltop.']';
my $str = "(".$x.",".$signalbottom.",".$close_price.",".$dma_20.",".$signaltop.")";
#print "$str\n";
my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(1000,200);

#Set the graph options.
  $graph->set( 
      x_label           => '',
      y_label           => 'Histogram',
      title             => 'Bollinger (20) Histogram Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 2,
      x_labels_vertical => 1,
      line_width        => 3,
	box_axis => 1, 
	x_label_skip => 3, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => marine,
      dclrs       => ['green','blue', 'cyan', 'red'],

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
