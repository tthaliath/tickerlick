#!/usr/bin/perl

$str = "occurred";

if ($str =~ /([a-z])(\1)ed$/){print $`.$1."\n";}
