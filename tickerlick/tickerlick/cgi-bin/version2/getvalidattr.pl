open (F,"<usedattr");
while (<F>)
{
   chomp;
   $hash1{$_}++;
}

close (F);

open (F,"<validattr");
while (<F>)
{
   chomp;
   if ($hash1{$_}){next;}
   print "$_\n";
}

close (F);

