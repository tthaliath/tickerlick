use Date::Simple qw(d8); 
 
my $d = d8('10/5/2012'); 
print $d->format('%d-%b-%Y'), "\n"; 

