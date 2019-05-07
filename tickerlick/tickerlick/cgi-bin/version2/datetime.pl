#!/usr/bin/perl

use POSIX 'strftime', 'mktime';

my ($second,$minute,$hour,$day,$month,$year) = localtime();
print "second,minute,hour,day,month,year\n";

print "$second,$minute,$hour,$day,$month,$year\n";
my $time_183_days_ago = mktime($second,$minute,$hour,$day-183,$month,$year);
my $start_date = strftime("%Y-%m-%d", localtime $time_183_days_ago);
print "$start_date\n";
