#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath

open (F,"siteallnew3.txt");
while (<F>){
chop;
print "$_\n\n\n";
}
close(F);