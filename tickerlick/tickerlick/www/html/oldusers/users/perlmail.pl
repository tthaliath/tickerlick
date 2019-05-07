#!/usr/bin/perl -w
use DBI;
use MIME::Lite;
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'thaliath@hotmail.com',
    Subject => 'daily security list RSI - Stochastic',
    Type    => 'multipart/mixed',
);
my $Mail_msg = "sample msg\n\n";
$Mail_msg .= "Tickerlick - Signal\n\n";
### Add the text message part
 $msg->attach (
  Type => 'TEXT',
   Data => $Mail_msg
   ) or die "Error adding the text message part: $!\n";

$msg->send;
