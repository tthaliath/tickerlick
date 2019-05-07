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
#my ($fill) = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0';
my ($fill) = ",,,,,,,,,,,,,,,,,,,,,,,,,";
#my ($fill) = 'undef,undef,undef,undef,undef,undef,undef,undef,undef,undef,undef';
my  @data = (
    [ qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ) ],
    [ 1,2,3,7,3,4,undef,undef,undef,undef,undef,undef  ]
  );
#my  @data = (
#    [ qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ) ],
#    [ 1,2,3,7,3,4,8,9,3,5,6,2  ]
#  );
#my $str = "(".$x.",".$signal.",".$rtq.")";
#print "$str\n";
#exit 1;
#my @data = eval ($str);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.
#my ($fill) = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0';
#my ($fill) = "'','','','','','','','','','','','','','','','','','','','','','','',','','','',''";
#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
my $graph = GD::Graph::lines->new(1000,200);
$min = 0;
$max =10;
#Set the graph options.
  $graph->set( 
      x_label           => '',
      y_label           => 'Histogram',
      title             => 'DMA Vs price Intra Day Chart',
      y_max_value       => $max,
      y_min_value       => $min,
      y_tick_number     => 5,
      y_label_skip      => 0,
      x_labels_vertical => 0,
      line_width        => 2,
	box_axis => 1, 
	#x_label_skip => 25, 
	#x_tick_offset => 2,
        y_number_format    => "%d", 
      boxclr            => marine,
      dclrs       => ['cyan', 'green','red','blue'],
      show_values => 0,
      values_space => 10,
      values_vertical => 1,
      skip_undef =>1,
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
