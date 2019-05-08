#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
$| = 1;
use strict;
use CGI;
my ($q) = new CGI;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count);
my ($size,$nolinks,$sortby,$keycnt,$query_option);

print "Content-type:text/html\n\n";


print "hello\n";
exit 1;
