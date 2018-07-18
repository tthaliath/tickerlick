#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: sort.pl
#Date started : 10/09/03
#Last Modified : 10/13/03
# sort files by data

my (%res,$key);
my ($i) = 0;
my $sortfilename = $ARGV[0];
open (F,"$sortfilename");
while (<F>)
{
chomp;
my ($id,$desc) = split (/\t/,$_);
$res{$desc} = $id;
}
close (F);
foreach $key(sort keys(%res)){
$str1 .= '"'.$key.'",';
$str2 .= $res{$key}.',';
}
print "$str1\n";
print "$str2\n";


exit 1;