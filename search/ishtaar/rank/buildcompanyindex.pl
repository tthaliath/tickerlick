#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: buildcompanyindex.pl
#Date started : 10/13/03
#Last Modified : 10/13/03
#Purpose : Read the contents of an index file, group the categories by company

use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($keyword,$key);
my ($total,$links,%hash,%chash,$str,$k,%src,$cid,$link,$catid,@arr,@arr1);


my $i = 0;
#delete the existing file
system("del companycat.txt");
my $sourcefile = 'indexbycatcompany.txt';
tie (%src, 'DB_File', $sourcefile, O_RDWR, 0444, $DB_BTREE) || die $!;
my $indexfile = 'companycat.txt';
tie (%hash, 'DB_File', $indexfile, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;



foreach $keyword(keys(%src))
{
 #$i++;
 ($catid,$links) = split (/\t/,$src{$keyword});
 foreach $link(split (/\,/,$links))
 {
  
  ($cid,$cnt) = split(/\*/,$link);
   if ($chash{$cid})
   {
     $chash{$cid} .= ",".$keyword."*".$cnt;
   }
    else
    {
    
    $chash{$cid} = $keyword."*".$cnt;
    
  }
}
#if ($i > 9){last;}
}
my $j;
foreach $keyword(sort { $a <=> $b } keys(%chash)){
   $k++;
   $j = 0;
   @arr = [];
   @arr1 = [];
   print "$keyword\n";
   $str = "";  
   @arr1 =  split(/\,/,$chash{$keyword}); 
   #foreach (@arr1){print "$_\n"; } 
   #map {@arr[$j++]= $chash{$_}} 
   @arr = map {$_->[0].'*'.$_->[1]}
          sort { $b->[1] <=> $a->[1]} 
          map { [split (/\*/,$_)] }
          @arr1;
   #foreach (@arr){print "$_\n"; } 
   $str = join(",",@arr);
   $hash{$keyword} = $str;
   #print "$keyword\t$str\n";
}
untie %src;
untie %hash;

print "total companies: $k\n";
                           
exit 1;

 