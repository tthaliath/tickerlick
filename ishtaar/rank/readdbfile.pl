#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: readdbfile.pl
#Date started : 10/09/03
#Last Modified : 10/13/03
#Purpose : Read the contents of a db_file

use strict;
use DB_File;
my ($i) = 0;
my $indexfilename = $ARGV[0];
my ($key,%res);
tie (%res, 'DB_File', $indexfilename, O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $key(sort { $a <=> $b } keys(%res)){
$i++;
print "$key\t$res{$key}\n";
#if ($i > 1000){last;}
}
print "no of keywords: $i\n";
untie %res;
exit 1;