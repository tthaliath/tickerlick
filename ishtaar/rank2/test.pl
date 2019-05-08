#!/usr/bin/perl

$keyword = "c++";
$keyword =~ s/\+/\\\+/g;
print "$keyword\n";
