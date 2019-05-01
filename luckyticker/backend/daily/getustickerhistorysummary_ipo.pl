#!/usr/bin/perl
open (OUT,">/home/tthaliath/tickerlick/daily/pricehistipo.csv");
$dirname = "/home/tthaliath/tickerlick/daily/usticker/ipo";
$today = $ARGV[0];
$today =~ s/\-//g;

opendir ( DIR, $dirname ) || die "Error in opening dir $dirname\n";
while( $filename = readdir(DIR))
{
     #print("$filename\n");
     if ($filename =~ /^(.*?)\./){$ticker_id = $1;}
     open (IN,"$dirname\/$filename");
     while (<IN>)
     {
	 chomp;
	 ($date,$open,$high,$low,$close,$volume,$sdj_close) = split (/\,/,$_);
	 if ($date eq 'Date'){next;} 
	 print OUT "$ticker_id,$date,$high,$low,$close\n";
         
    } 	 

 }
closedir(DIR);
close (OUT);
#copy data file to data dir
$data_dir = "/home/tthaliath/tickerdata/history/price/daily/$today/pricehistipo.csv";
system ("cp /home/tthaliath/tickerlick/daily/pricehistipo.csv  $data_dir");

