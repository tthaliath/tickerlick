#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexbycompany.pl
#Date started : 10/10/03
#Last Modified : 10/10/03
#Purpose : Read the contents of an index file, group the data by term and company, also store,
#total no of ocuurences.

use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%hash,$k,%src,%chash);


my $i = 0;
my $sourcefile = 'indexbypage.txt';
tie (%src, 'DB_File', $sourcefile, O_RDWR, 0444, $DB_BTREE) || die $!;
my $indexfile = 'indexbycompany.txt';
tie (%hash, 'DB_File', $indexfile, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

my ($filename,$cid,$str,@arr,$val,@arr1,$j);

foreach $keyword(keys(%src))
{
 $i++;
  @arr = [];
  @arr1 = [];
  %chash = ();
  print "$i\n";
 ($cnt,$links) = split (/\t/,$src{$keyword});
  #print "$keyword\t$cnt\t$links\n";
  @arr = split (/,/, $links);
  foreach $val (@arr)
   {
      
      ($val) = split(/-/,$val);
      #print "$val\n";
      $chash{$val}++;
   }
 
  
   $j = 0; 
   $str = "";       
   map {@arr1[$j++]= $_.'*'.$chash{$_}} 
          sort {$chash{$b} <=> $chash{$a} } keys (%chash);
   $str = join(",",@arr1);
   $hash{$keyword} = $str;

 #if ($i > 900){last;}
}

untie %hash;
untie %src;
#my %res;
#tie (%res, 'DB_File', $indexfile, O_RDWR, 0444, $DB_BTREE) || die $!;
#foreach $keyword(keys(%res)){print "$keyword\t$res{$keyword}\n";}
#untie %res;
print "total terms: $i\n";
                           
exit 1;

 