#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File:in31_link_key_text.pl
#Date started : 10/12/03
#Last Modified : 10/15/03
#Purpose : Read the contents of files from data2 folder and update text for each keyword

#require "ut15_stemmer.pl";
use strict;
use DBI;
use DB_File;

my $data_dir = "data/" ;
my $fullname;
my $linkfilename;
my $file;
my ($in,$header,%hash,%hash1,$keywordnew,$fileid,$r,$rstr,$lstr,$keyword,$linktext,$query1,$dbh,$keystr,$query2);
my @sub_list;
my $i = 0;
my $stop_words = "a all also an and are as at be been before but by can do each etc for from had has have he his how however i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when whenever where wherever which while who will with would you your";
my $stopwords = join("\|",split(/\s/,$stop_words));
$linkfilename = 'link_key_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
my ($key,$keystr);
my ($flag) = 0;
$dbh = open_dbi();
$query2 = $dbh->prepare('update link_key set key_text = ? where link_id = ? and keyword = ?') || die $query2->errstr;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    if ($file eq "vedika.txt"){$flag = 1;}
 
   if ($flag){push (@sub_list,$data_dir.$file);}
    
  }
}
closedir (DIR);
my $filename;
foreach $filename(@sub_list)
{
#print "$filename\n";
open (F,"$filename");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";
open (OUT, ">>noid2.txt");
open (OUT1,">>nokey2.txt");
while ($texthtml =~ /^(\d+-\d+)\thttp:\/\/.*?\n(.*?)\n\n/mgi)
{
 $i++;
   $fileid = $1;
   #print "$fileid\n";
   $linktext =  $2;
   $keystr = $hash{$fileid};
   if ($keystr){
   #print "$fileid\t$linktext\n";
   #map { $lt2  .= stem1($_)." "; } 
 #              split /\s/, $linktext; 
   foreach $keyword (split (/\,/,$keystr))
  {	
   #print "$fileid\t$keyword\t\n";
   if ($keyword =~ /\+/){$keyword =~ s/\+/\\\+/g;}
   if ($keyword =~ /(y)$/){$keywordnew = $keyword;$keywordnew = $keyword."|".$`."ies"."|".$`."ied";}
   #elsif ($keyword =~ /y\s/){$keywordnew = $keyword;$keywordnew =~ s/(y?)\s/$`."y|".$`."ies"/g;}
   elsif ($keyword =~ /\s/){$keywordnew = $keyword;$keywordnew =~ s/\s/(?:ed|s|)?(?: )?(?:$stopwords)? /g;}
   else {$keywordnew = $keyword;}
   #print "$fileid\t$keyword\t$keywordnew\n";
   if ($linktext =~ /($keywordnew)/i){
   $r = reverse($`);
   $lstr = substr($r,0,index($r," ",50));
   $lstr = reverse($lstr);
   $rstr = substr($',0,index($'," ",50));
   $keystr = "...$lstr$1$rstr...";
   $query2->execute($keystr,$fileid,$keyword);
   #print "$fileid\t$keyword\t...$lstr$1$rstr...\n";
}
else{print OUT "$fileid\t$keyword\n";}
} 
}
else {print OUT1 "NOKEYSTR\t$fileid\n";}
}
close (OUT);
close (OUT1);
}
#$query1->finish;
$query2->finish;
$dbh->disconnect();
untie %hash;
print "$i links processed\n";

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

   # Connect to the requested server
   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password",
      {AutoCommit => 0 })
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
