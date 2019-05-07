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
#my $ticker_id = 10909;
my $x = "";
my $dma200 = "";
my $signal = "";
my $rtq = "";
my $dma50 = "";
my $dma10 = "";
my $topline = '';
my $bottomline = '';
my $maxticks = 390;
my (@row);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my  $sql = "select  rsi_14, 30 as bottomline, 70 as topline,'' from (select rsi_14,seq  from tickerrtq1 a where a.ticker_id = ".$ticker_id." and price_date = '2015-09-10' ORDER BY a.seq DESC LIMIT 0,390) as abc where rsi_14 is not null order by seq ASC";
#print "$sql\n";
 my $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 my (@macd1val,@macd2valss);
 while (@row = $sth->fetchrow_array)
 {
   $x .= $row[3].",";
   $signal .= $row[0].",";
   $bottomline .= $row[1].",";
   $topline .= $row[2].",";
}
 $sth->finish;
 #$dbh->disconnect;
 $x =~ s/(.*)\,$/$1/;
 $bottomline =~ s/(.*)\,$/$1/;
 $topline =~ s/(.*)\,$/$1/;

 $signal =~ s/(.*)\,$/$1/;
 my @macd = split (/\,/,$signal);
  my $noticks = scalar (@macd);
my $gap = $maxticks - $noticks;
my @gaparr = ('undef')x$gap;
my @gaparr1 = (30)x$gap;
my @gaparr2= (70)x$gap;
my $gapstr = join (",",@gaparr);
my $gapstr1 = join (",",@gaparr1);
my $gapstr2 = join (",",@gaparr2);
 #my @bigarr = split (/\,/,$signal); 
 #push (@bigarr,@macd);
 #my $min = abs(floor(min (@macd)));
 #my $max = ceil(max (@macd));
 #if ($min > $max){$max = $min;}
my $min = 0;
 my $max = 100;

$x =~ s/\,/\"\,\"/g;
$x = '"'.$x.'"';
$x = $x.",".$gapstr;
$signal = $signal.",".$gapstr;
$bottomline = $bottomline.",".$gapstr1;
$topline = $topline.",".$gapstr2;
$x = '['.$x.']';
$topline = '['.$topline.']';
$bottomline = '['.$bottomline.']';
$signal = '['.$signal.']';
#my $str = "(".$x.",".$signalbottom.",".$rtq.",".$dma_20.",".$signaltop.")";
#my $str = "(".$x.",".$rtq.",".$dma50.",".$dma10.")";
my $str = "(".$x.",".$signal.",".$bottomline.",".$topline.")";

#my $str = "(".$rtq.",".$dma50.",".$dma10.")";

#my $str = "(".$x.",".$signal.",".$rtq.",".$dma200.")";

#my $str = "(".$x.",".$signal.",".$rtq.")";
#my $str = "(".$x.",".$signal.")";
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
      title             => 'RSI vs intra Day Chart',
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

#or for CGI programs:
  use CGI qw(:standard);
  my $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@data)->$format();
