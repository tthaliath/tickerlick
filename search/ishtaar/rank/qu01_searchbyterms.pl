#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: qu01_searchbyterms.pl
#Date started : 03/06/04
#Last Modified : 03/06/04
#Purpose : select the links sort by rank for the given terms


use strict;


my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$c,$d);
my ($id,$query,$key_str,$dbh,$link_id_pos);
#Get the URL from command argument.
my ($terms) = 'values|auto|sprint';
open (F,"<termlist.txt");
my (%linkhash,@linklist,%fileid);
while(<F>)
{
    chomp;
    ($key_str,$link_id_pos) = split (/\t/,$_);
    #if ($key_str =~ /$terms/){
   @linklist = split /k/, $link_id_pos;  
   #print "$key_str\t$link_id_pos\n\n\n";
   foreach $key(@linklist){
     ($c,$d) = split(/_/,$key);
     if ($keyhash{$key_str}{$c})
     { print "ALREADY:$key_str\t$keyhash{$key_str}{$c}\n";
       $keyhash{$key_str}{$c} .= ",".$d;}
     else
     {$keyhash{$key_str}{$c} = $d;}
     $fileid{$c}++;
    

}
#}
}
close(F);
foreach $links(keys(%keyhash))
{
 print "\n\n\n1:$links\n\n\n";
 %linkhash = ();
 %linkhash = %{$keyhash{$links}};
 foreach $key(keys (%linkhash))
  {
     print "key:$links\tcom$key\tpos$linkhash{$key}\n";  

  }
}
  #last;
foreach $key(sort {$fileid{$b} <=> $fileid{$a}} keys (%fileid))
{ print "FILEID:$key\t$fileid{$key}\n";}


exit 1;
