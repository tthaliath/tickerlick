#!/usr/bin/perl
$i = 0;
open (F,"<map_filename.txt");
while (<F>){
chomp;
$i++;
($oldfile,$newfile) = split (/\t/,$_);
 $oldfile .= "\.txt";
 $newfile .= "in\.txt"; 
 if (-e "data/$oldfile"){system("mv data/$oldfile data/$newfile");}
#if ($i > 4){last;}
}
print "$i files renamed\n";
close (F);
1;

