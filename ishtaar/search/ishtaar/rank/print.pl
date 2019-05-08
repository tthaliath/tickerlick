#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexbypage.pl
use strict;
use DB_File;
my ($key);
my $i = 0;
my %res;
tie (%res, 'DB_File', 'indexbypage.txt', O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $key(keys(%res)){
$i++;
if ($i > 100){
print "$key\t$res{$key}\n";}
if ($i > 500) {last;}
}
untie %res;
exit 1;