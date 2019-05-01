#!/usr/bin/perl -w
use MIME::Lite;
my $day  = $ARGV[0];
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@gmail.com',
    Subject => 'daily security list',
    Type    => 'multipart/mixed',
);
my $Mail_msg = "$day\n\n";
$Mail_msg .= "BULL\n\n";
my $bullfilename = "/home/tthaliath/tickerlick/daily/bull/oversold_mail.csv";
open (F,"<$bullfilename");
undef $/;
$Mail_msg .= <F>;
close (F);
my $bearfilename = "/home/tthaliath/tickerlick/daily/bear/overbought_mail.csv";
$Mail_msg .= "\nBEAR\n\n";
open (F,"<$bearfilename");
$Mail_msg .= <F>;
$/ = 1;
close (F);
### Add the text message part
 $msg->attach (
  Type => 'TEXT',
   Data => $Mail_msg
   ) or die "Error adding the text message part: $!\n";

$msg->send;
