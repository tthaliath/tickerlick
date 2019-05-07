#!/usr/bin/perl  -w
#use strict;
$firststring = "abcd"; $secondstring = "efgh"; 
$combine = $firststring." ".$secondstring; 
print "$combine\n";

$test = 2.3456; { my $test = 3; print "In block, $test = $test "; print "In block, $::test = $::test "; } print "Outside the block, $test = $test "; print "Outside the block, $::test = $::test\n"; 
$ddd = 1;
 our $ee = 1;

if ($ee == 1)
{
  local $ee  =2;
  print "$ee\n";
}
print "$ee\n";
my $string="APerlAReplAFunction"; my $counter = ($string =~ tr/A/a/); print "There are $counter As in the given string\n"; print "$string\n";

#$counter = ($string =~ tr/A/a/);

print "$string\n";

@array = ("perl","php","perl","asp");
%hash =  map { $_ => 1 } @array ; 

foreach $key (keys %hash)
{
   
 print "$key\n";
}	

opendir(DIR, ".");
#@files = grep(/\.html$/,readdir(DIR));

@files = map {/html/; $_;} readdir(DIR);
closedir(DIR);


foreach $file (@files) {
print "$file\n";
}
my @lamps = qw(perl php python);
@files = map {s/php/PHP/; $_; } @lamps;



foreach $file (@lamps) {
print "$file\n";
}

@files= grep  {/php/i} @lamps;


foreach $file (@files) {
print "$file\n";
}

@crops = qw(wheat corn barley rice corn soybean hay 
            alfalfa rice hay beets corn hay);
@dupes = grep { $count{$_} == 3 } 
              grep { $count{$_}++ } @crops;
print "@dupes\n";
