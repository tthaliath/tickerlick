local $/ = undef;
open (F,"<1");
$str = <F>;
close (F);

while ($str =~ /tickerhash?{(.*?)\}/g)
{
   $hash{$1}++;
}

foreach $key (sort keys %hash)
{
    print "$key\n";
}
