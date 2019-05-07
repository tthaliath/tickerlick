#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in04_createwordlistfile.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create a file with all unique words


use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file);
my $data_dir = "d:/ishtaar/rank2/index/" ;
my $fullname;
my $file;


open (OUT,"termmaster.txt");


my $filename;

 $fullname = $data_dir.$filename;
 
 undef $/;
 
   
   
   while ($texthtml =~ /\b$term\s(.*)?\s/gis){
    #print "$clink\t$1\n"; 
    $keyhash{$termnext}++;
    }
   }
   }
   
   $termlist = '';
   $i = 0;
    foreach $termnext(sort (%keyhash{$b} <=> %keyhash{$a}) keys %keyhash)
    {
      $i++;
      $termlist .= $termnext.',';
      
    if ($i > 9)
    {
     last;
    }
   
  }
  $termlist =~ s/^(.*)\,/$1/g;
  $termnexthash{$term} = $termlist;

}



}


                           
exit 1;


