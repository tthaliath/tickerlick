#!/usr/bin/perl

my $procs = `ps -ef | grep /home/tickerlic | grep apache`;

print "$procs\n";

