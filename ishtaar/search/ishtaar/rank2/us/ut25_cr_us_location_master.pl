#!c:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: ut25_cr_us_location_master.pl
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History
#-------------------------------------------------------------------------
use strict ;

my (%lochash,$location,$key,$domain_name,$rest,$domain);
my ($locid,$cat2,$statcode,$state,$metro,$metrodesc,$cat1,$cname,$url,$loc,$curl);
my ($i) = 2000;

open (F,"us_state_metro_desc_master.txt");
while (<F>)
{
chomp;
($locid,$statcode,$state,$metro,$metrodesc)= split(/\t/,$_);
$key = $state."-".$metro;
$lochash{$key} = "$locid\t$metrodesc";
}

close(F);
open (OUT,">us_location_master.txt");
open (F,"us_metros_com_list_all.txt");
while (<F>)
{
chomp;
$i++;
if ($i>5200){
($state,$metro,$cat1,$cat2,$cname,$curl,$loc)= split(/\t/,$_);
}
else{
($state,$metro,$cat1,$cname,$curl,$loc)= split(/\t/,$_);
}
$state =lc ($state);
$metro = lc ($metro);
$key = $state."-".$metro;
($locid,$metrodesc) = split(/\t/,$lochash{$key});
$url = $curl;
$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
$url=~s#^([^/]+).*#$1#;   # everything before first / is domain
$domain_name ='';
if ($url =~ /^www\./i){
if ($url =~ /.*?\.(.*?)\.(.*)/){
$domain = lc $1;
$rest = lc $2;
$domain_name = $domain.$rest;
$domain_name =~ s/\.//g;
}
}
else{
$url =~ /(.*?)\.(.*)/;
$domain = lc $1;
$rest = lc $2;
$domain_name = $domain.$rest;
$domain_name =~ s/\.//g;
}
if (!$domain_name){print "$_\n";}
print OUT "$i\t$locid\t$metrodesc\t$cname\t$curl\t$loc\t$domain_name\n";

}
	
close(F);

close (OUT);

print "$i - 2000 metros processed\n";
1;
