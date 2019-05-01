#!/usr/bin/perl -w
use MIME::Lite;

my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@hotmail.com',
    Subject => 'A message with 2 parts...',
    Type    => 'multipart/mixed',
);

my $attachment = "/home/tthaliath/tickerlick/daily/pricehist.csv";
my $datafilename = "pricehist.csv";
my $Mail_msg = "file pricehist.csv is attached";
### Add the text message part
 $msg->attach (
  Type => 'TEXT',
   Data => $Mail_msg
   ) or die "Error adding the text message part: $!\n";

     ### Add the text file
      $msg->attach (
       Encoding => 'base64',
        Type => "text/csv",
         Path => $attachment,
          Filename => $datafilename,
           Disposition => 'attachment'
            ) or die "Error adding $datafilename: $!\n";


$msg->send;
