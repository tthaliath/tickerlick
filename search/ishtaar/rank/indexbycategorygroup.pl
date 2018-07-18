#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexbycategorygroup.pl
#Date started : 10/09/03
#Last Modified : 10/09/03
#Purpose : Read the contents of an index category files, group the data by term, also store,
#total no of ocuurences.

use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt,$catid,$cid);
my ($total,$links,%hash,$k,$rem);
my $data_dir = "d:/ishtaar/rank/indexcat/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my $indexfilename = 'indexbycategory.txt';
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
 #print "$i\t$filename\n";
 open (F,"<$filename");
 while (<F>){
 chomp;
 ($page_id,$keyword,$catid,$cnt) = split (/\t/,$_);
 if ($hash{$keyword})
  {
     ($cid,$total,$links) = split (/\t/,$hash{$keyword});
     $total += $cnt;
     $links .= ','.$page_id;
     $hash{$keyword} = "$cid\t$total\t$links";
  }
  else
  {
    $hash{$keyword} = "$catid\t$cnt\t$page_id";
    $k++;
  }
}
close (F);
}
untie %hash;
print "total terms: $k\n";
                           
exit 1;

 