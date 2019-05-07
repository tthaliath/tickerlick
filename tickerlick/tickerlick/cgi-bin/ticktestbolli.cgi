#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
use strict;
use warnings;
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
$ticker_id = 10909;
my $x = "";
my $dma_20 = "";
my $signaltop = "";
my $rtq = "";
my $dma50 = "";
my $dma10 = "";
my $topline = '';
my $signalbottom = '';
my $maxticks = 390;
my (@row);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $sql = "select '',rtq,dma_20, (dma_20 + (2 * dma_20_sd)) as dma_20_top,(dma_20 -  (2 * dma_20_sd)) as dma_20_bottom from (select a.seq,a.rtq,a.dma_20,a.dma_20_sd from tickerrtq1 a  where  ticker_id = ".$ticker_id." and price_date = '2015-09-10' ORDER BY seq DESC LIMIT 0,390) as abc order by seq ASC";
#print "$sql\n";
 my $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[0].",";
   $rtq .= $row[1].",";
   $dma_20 .= $row[2].",";
   $signaltop .= $row[3].",";
   $signalbottom .= $row[4].",";

}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/$1/;
 $rtq =~ s/(.*)\,$/$1/;
 $dma_20 =~ s/(.*)\,$/$1/;
 $signalbottom =~ s/(.*)\,$/$1/;
 $signaltop =~ s/(.*)\,$/$1/;
 my $maxmin = "select max((dma_20 + (2 * dma_20_sd))) as max,min((dma_20 -  (2 * dma_20_sd))) as min from  (select a.dma_20,a.dma_20_sd from tickerrtq1 a  where  ticker_id = ".$ticker_id." and price_date = '2015-09-10') as abc";
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

 my @macd = split (/\,/,$signaltop);
  my $noticks = scalar (@macd);
my $gap = $maxticks - $noticks;
my @gaparr = ('undef')x$gap;
my @gaparr1 = (30)x$gap;
my @gaparr2= (70)x$gap;
my $gapstr = join (",",@gaparr);
my $gapstr1 = join (",",@gaparr1);
my $gapstr2 = join (",",@gaparr2);

$x =~ s/\,/\"\,\"/g;
$x = '"'.$x.'"';
$x = $x.",".$gapstr;
$dma_20 = $dma_20.",".$gapstr;
$signalbottom = $signalbottom.",".$gapstr;
$signaltop = $signaltop.",".$gapstr;
$rtq =  $rtq.",".$gapstr;

$x = '['.$x.']';
$rtq = '['.$rtq.']';
$dma_20 = '['.$dma_20.']';
$signalbottom = '['.$signalbottom.']';
$signaltop = '['.$signaltop.']';
my $str = "(".$x.",".$signalbottom.",".$rtq.",".$dma_20.",".$signaltop.")";
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
      title             => 'Bollinger (20) Intra Day Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 6,
      y_label_skip      => 6,
      x_labels_vertical => 0,
      line_width        => 3,
        box_axis => 1,
        x_label_skip => 60,
        x_tick_offset => 0,
        x_ticks  => 0,
        y_number_format    => "%d",
      boxclr            => 'marine',
      dclrs       => ['cyan','green','red','blue'],
       skip_undef => 1,
  ) or die $graph->error;
#      dclrs       => ['green','blue', 'cyan', 'red'],
#and plot the graph.
  my $gd = $graph->plot(\@data) or die $graph->error;

#for for CGI programs:
  use CGI qw(:standard);
  my $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
