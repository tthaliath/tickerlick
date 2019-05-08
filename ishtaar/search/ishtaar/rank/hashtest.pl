#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: hashtest.pl
#Date started : 10/21/03
#Last Modified : 10/21/03

@arr = [4,5,6];

my $key = 'xxx';

my %Hash = ();

$Hash{xxx}[0] = 1;
$Hash{xxx}[1] = 2;
$Hash{xxx}[2] = 3;
#push (@{$Hash{$key}},@Arr);



#Then to reference them: 




#print "$Hash{$key}[1]\n";;



#or to iterate over the array (in the hash element) 




#foreach $item (@{$Hash{$key}}){
	#print "\$item = $item\n";
# or
	#print @{$Hash{$key}} . "\n";
#}

foreach $item (keys (%Hash))
{
	print "\$item = $item\n";
        print join("\n",@{$Hash{$item}});
        print "\n";
        foreach $val(sort { $b <=> $a } @{$Hash{$item}}){print "$val\n";}
}
