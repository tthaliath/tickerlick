#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexbypage.pl
#Date started : 10/09/03
#Last Modified : 10/09/03
#Purpose : Read the contents of an index file, group the data by term, also store,
#total no of ocuurences.

use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%hash,$k,$rem);
my $data_dir = "d:/ishtaar/rank/index/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my $indexfilename = 'indexbypage.txt';
tie (%hash, 'DB_File', $indexfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$data_dir.$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;
foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 open (F,"<$filename");
 while (<F>){
 chomp;
 ($keyword,$page_id,$cnt,$rem) = split (/\t/,$_);
 if ($hash{$keyword})
  {
     ($total,$links) = split (/\t/,$hash{$keyword});
     $total += $cnt;
     $links .= ','.$page_id;
     $hash{$keyword} = "$total\t$links";
  }
  else
  {
    $hash{$keyword} = "$cnt\t$page_id";
    $k++;
  }
}
close (F);
}
untie %hash;

print "total terms: $k\n";
                           
exit 1;

 