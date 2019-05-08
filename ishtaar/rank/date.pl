use strict;

#	input file handler
my $fileIn;
#	date holder
my @localDT = localtime;
#	MM/DD/YYYY string
my $strDate = sprintf("%02d/%02d/%04d",
	$localDT[4] + 1, $localDT[3], $localDT[5] + 1900);

print "$strDate\n";