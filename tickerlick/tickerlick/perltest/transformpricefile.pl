#!/usr/bin/perl
my ($ticker,$cname,$ticker_id,%hash,@parr,$in,$out,$d1,$file) ;
$file = "last_price.csv";
open (IN,"<tickermaster.csv");
while (<IN>)
{
  chomp;
  ($ticker_id,$cname,$ticker) = split(/\,/,$_);
  $ticker =~ s/ //g;
  $hash{$ticker} = $ticker_id;
}
close (IN);
my $dirname = "\/home\/tthaliath\/tickerdata\/history\/price\/daily\/feed\/";
my $dirnameshort = "\/home\/tthaliath\/tickerdata\/history\/price\/daily\/20121009";
$out = ">".$dirnameshort."\/".$file;
open (OUT, $out);
opendir(DIR, $dirname) or die "can't opendir $dirname: $!";
while (defined($file = readdir(DIR))) 
{
    #$file =~ s/ //g;
    if ($file =~ /^(.*)?\./) {$ticker = $1;}
    #if ($ticker ne "SPY"){next;}
    #print  "$dirname\t$file\t$ticker\n";
    $in = "<".$dirname."\/".$file;
    open (F, $in);
    while (<F>)
    {
     chomp;
     (@parr) = split(/\,/,$_);
     $d = $parr[0]; 
     $p = $parr[6];
     if ($d =~ /Date/){next;}
     #print "tom:$d\n";
      if (!$d){next;}
     print OUT "$hash{$ticker},$d,$p\n";
    }
    close (F);
 
}
closedir(DIR);
close (OUT);
