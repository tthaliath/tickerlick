#!/usr/bin/perl
use DB_File;
open (OUT,">validlinkdatafile.txt");
my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $key (keys %hash){
print OUT "$key\t$hash{$key}\n";
}
untie %hash;
close (OUT);
1;
