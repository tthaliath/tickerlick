#!/usr/bin/perl
use strict;
use GD;
use GD::Graph::lines;

my @months = ( "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" );
my @rainfall = ( 1, 2, 3, 4 );
my @array = (\@months, \@rainfall);

my $graph = new GD::Graph::lines(768, 896);
$graph->set( y_long_ticks => "1", x_tick_offset => "2" );

my $gd_image = $graph->plot( \@array );
use CGI qw(:standard);
  #...
  my $format = $graph->export_format;
  #print "$format\n";
  print header("image/$format");
  binmode STDOUT;
  print $graph->plot(\@array)->$format();
exit 0;

