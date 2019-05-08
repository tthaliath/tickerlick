#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_link_key_datafile.pl
#Date started : 11/07/03
#create category master lookup DB file from category_master table

use strict;
use DB_File;


my $linkfilename;
my ($link_id,$keyword,%hash,$dbh,$query1,$key);

open (OUT, ">link_key_datafile.txt");
my $i = 0;
my $catfilename = 'link_key_dbfile.txt';
tie (%hash, 'DB_File', $catfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
foreach $key(keys(%hash))
{
   $i++;
   print OUT "$key\t$hash{$key}\n";
}

untie %hash;
close (OUT);
print "$i records processed\n";
exit 1;

