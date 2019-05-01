open (F,"tdates");
while (<F>)
{
  if ($_ =~ /(\d\d\d\d)(\d\d)(\d\d)/)
   {
        $d = $1."-".$2."-".$3;
        print "$d\n";
  }
}
close (F);
