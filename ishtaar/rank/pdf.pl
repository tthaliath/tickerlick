#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: pdf.pl
#Date started : 03/25/03
#Last Modified : 09/25/03
#Purpose : Read and save the contents of a URL, store it in a file 
# with the same name as url. Extract all the links 
#(excluding redirect links) and store it in a file

use PDF;
  $filename = "c:/download/reg_notice.pdf";
  $pdf=PDF->new ;
  $pdf=PDF->new($filename);
  #$result=$pdf->TargetFile($filename );
  print "is a pdf file\n" if ( $pdf->IsaPDF ) ;
  print "Has ",$pdf->Pages," Pages \n";
  print "Use a PDF Version  ",$pdf->Version ," \n";
  #print "and it is crypted  " if ( $pdf->iscryptedPDF) ;
  print "filename with title",$pdf->GetInfo("Title"),"\n";
  print "and with subject ",$pdf->GetInfo("Subject"),"\n";
  print "was written by ",$pdf->GetInfo("Author"),"\n";
  print "in date ",$pdf->GetInfo("CreationDate"),"\n";
  print "using ",$pdf->GetInfo("Creator"),"\n";
  print "and converted with ",$pdf->GetInfo("Producer"),"\n";
  print "The last modification occurred ",$pdf->GetInfo("ModDate"),"\n";
  print "The associated keywords are ",$pdf->GetInfo("Keywords"),"\n";
