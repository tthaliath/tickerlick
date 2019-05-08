#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in11_buildindexbylocation.pl
#Date started : 04/10/04
#Last Modified : 04/10/04
#Purpose : index the data by keuword and location


use strict;


my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$rem);
my ($id,$query,$key_str,$dbh,$link_id_pos);
my ($loc_id,$loc_desc,%lochash);
open (LOC,"locationweb.txt");
while (<LOC>)
{
   chomp;
   ($loc_id,$loc_desc,$rem) = split(/\t/,$_);
   $loc_desc = lc $loc_desc;
   #$loc_desc =~ s/\s//g;
   $lochash{$loc_desc} = $loc_id;
   #print "$loc_id\t$loc_desc\n";
}
close(LOC);
my ($site_id,$site_url,$site_loc,%sitehash,$i);
open(SITE,"siteallnew4.txt");
while (<SITE>)
{
   chomp;
   ($site_id,$site_url,$site_loc,$rem) = split (/\t/,$_);
  # $site_loc =~ s/\s//g;
   $sitehash{$site_id} = $site_loc;
   #print "$site_id\t$site_loc\n";
}
close(SITE);
my ($site_desc,$site_rank,%siterankhash,$log_rank,$a,$b,$c,$d,$e);
open (RANK,"sitemasterrank.txt");
while (<RANK>)
{
   chomp;
   ($site_id,$a,$b,$c,$d,$e,$log_rank) = split(/\t/,$_);
    $siterankhash{$site_id} = $log_rank;
}
close(RANK);

open (F,"termmasterstem.txt");

my (%linkhash,@linklist,%fileid);
while(<F>)
{
   chomp;
   $i++;
   ($key_str,$link_id_pos) = split (/\t/,$_);
   @linklist = []; 
   if ($link_id_pos =~ /k/){@linklist = split (/k/, $link_id_pos); }
   else{push(@linklist,$link_id_pos);} 
   #print "$i\t$key_str\n";
   foreach $key(@linklist){
   if ($key =~ /(.*?)\-/){
    # print "loc:$1\t$sitehash{$1}\n";
     $loc_id = $lochash{$sitehash{$1}};
     $log_rank = $siterankhash{$1};
     if (!$loc_id){print "NO LOC ID:$1\n";}
     if (!$log_rank){print "NO RANK:$1\n";}
     if ($keyhash{$key_str}{$loc_id})
     { 
       $keyhash{$key_str}{$loc_id} .= 'k'.$log_rank.'j'.$key;}
     else
     {$keyhash{$key_str}{$loc_id} = $log_rank.'j'.$key;}
   }
   
}
#if ($i > 99){last;}  
}



close(F);
open (OUT,">termbyloc.txt");
foreach $links(sort keys(%keyhash))
{

 %linkhash = ();
 %linkhash = %{$keyhash{$links}};
 foreach $key(keys (%linkhash))
  {
     print OUT "$links\t$key\t$linkhash{$key}\n";  

  }
}
close(OUT);
 
exit 1;


