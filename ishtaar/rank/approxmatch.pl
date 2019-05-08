#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler3.pl
use String::Approx qw(amatch);
open(DICT, "/usr/dict/words")               or die "Can't open dict: $!";
while(<DICT>) {
    print if amatch("balast");
}
