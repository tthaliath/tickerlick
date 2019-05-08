#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: qu01_searchbyterms2.pl
#Date started : 03/06/04
#Last Modified : 03/06/04
#Purpose : select the links sort by rank for the given terms


use strict;
use DBI;

my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$c,$d,$link);
my ($id,$query,$key_str,$dbh,$link_id_pos);
#Get the URL from command argument.
my ($terms) = 'java,';
$dbh = open_dbi();
$query= $dbh->prepare ('select key_str,link_id_pos from index_by_key where key_str in("suppli","chain","managemen") and loc_id = 33' ) || die $query->errstr;
$query->execute();\
my (%linkhash,@linklist,%fileid,%siterankhash,$site_rank);
while(($key_str,$link_id_pos)= $query->fetchrow_array())
{

   @linklist = []; 
   @linklist = split /k/, $link_id_pos;  
   #print "$key_str\n\n\n";
   foreach $key(@linklist){
   ($c,$d) = split(/_/,$key);
    ($site_rank,$link) = split(/j/,$c);
     #if ($keyhash{$key_str}{$c})
     #{ 
      # $keyhash{$key_str}{$c} .= ",".$d;}
     #else
    #$keyhash{$key_str}{$c} = $d;}
     $fileid{$link}{$key_str}++;
     $siterankhash{$link} = $site_rank;
}

}
$query->finish;
$dbh->disconnect;  

#foreach $links(keys(%keyhash))
#{
 #print "\n\n\n1:$links\n\n\n";
 #%linkhash = ();
 #%linkhash = %{$keyhash{$links}};
 #foreach $key(keys (%linkhash))
  #{
  #   print "key:$links\tcom$key\tpos$linkhash{$key}\n";  

  #}
#}
  #last;
foreach $link(sort { scalar keys %{$fileid{$b}} <=> scalar keys %{$fileid{$a}} || $siterankhash{$b} <=> $siterankhash{$a} } keys (%fileid))
{ #print "FILEID:$key\t$fileid{$key}\n";
  $key_str = '';
  %linkhash = %{$fileid{$link}};
  foreach $key(keys (%linkhash))
  {
     $key_str .= $linkhash{$key}.',';

  }
  print "$link\t$key_str\t$siterankhash{$link}\n";  

}
 
  

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password") 
      or err_trap("Cannot connect to the database");
   return $dbh;
}#end: open_dbi

#==================== [ err_trap ] ==================== 
sub err_trap 
{
   my $error_message = shift(@_);
   die "$error_message\n  
      ERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap


                           
exit 1;


