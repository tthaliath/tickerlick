use GD;
use GD::Graph;
use GD::Graph::lines;
@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th","10th"],
    [    1,    2,    5,    -6,    0,  1.5,    1,     3,     4, 9],
    [ 1, 4, 5, -7, 3, 1.5, 3, -3, 6, 9 ]
  );

#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(500, 400);

#Set the graph options.
  $graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 9,
      y_tick_number     => 9,
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

