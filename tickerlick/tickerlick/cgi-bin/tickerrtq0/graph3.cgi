use GD;
use GD::Graph;
use GD::Graph::lines;
@data = ([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50],
[-25.8971,-24.5281,-21.4761,-19.3302,-18.8404,-18.121,-16.1427,-15.3929,-14.0878,-13.1002,-12.2129,-11.6454,-10.3979,-10.7587,-8.59991,-8.04059,-8.42944,-9.33051,-8.81366,-7.51166,-5.57715,-4.33167,-2.16321,0.400391,2.19751,3.01251,3.53577,5.18494,7.41077,9.35852,10.2603,12.9043,15.2406,16.2452,16.3432,16.3733,15.827,14.9191,13.7592,12.9454,12.5628,13.2349,14.8368,16.4471,16.4611,16.6636,17.2943,17.3655,18.1954,19.1291],
[-19.8697,-18.3628,-16.8215,-15.6579,-14.7398,-13.7146,-12.613,-11.7306,-10.815,-9.99674,-9.22088,-8.47288,-7.67975,-7.00021,-6.06059,-5.42576,-4.77205,-3.8577,-2.4895,-0.908462,0.742338,2.32221,3.98568,5.5229,6.80353,7.95504,9.19067,10.6044,11.9593,13.0964,14.0309,14.9736,15.4909,15.5535,15.3806,15.1399,14.8315,14.5826,14.4985,14.6833,15.1178,15.7566,16.387,16.7746,16.8565,16.9554,17.0283,16.9618,16.8609,16.5273]
);
#If you don't have a value for a point in a certain dataset, you can use undef, and the point will be skipped.

#Create a new GD::Graph object by calling the new method on the graph type you want to create (chart is bars, hbars, lines, points, linespoints, mixed or pie).
  my $graph = GD::Graph::lines->new(700,500);

#Set the graph options.
  $graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 25,
      y_tick_number     => 9,
      y_label_skip      => 2,
      x_labels_vertical => 1 
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

