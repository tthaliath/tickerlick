use GD;
use GD::Graph;
use GD::Graph::lines;
 @data = [
            ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                                         "Sep", "Oct", "Nov", "Dec", ],
            [-5, -4, -3, -3, -1,  0,  2,  1,  3,  4,  6,  7],
            [4,   3,  5,  6,  3,1.5, -1, -3, -4, -6, -7, -8],
            [1,   2,  2,  3,  4,  3,  1, -1,  0,  2,  3,  2],
        ];
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(500, 400);

#Set the graph options.
  $graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 12,
      y_tick_number     => 12,
      y_label_skip      => 2 
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

