<?php
header('Content-type: text/csv');
header('Content-disposition: attachment;filename=preg.csv');

 // The PDF source is in original.pdf
 readfile("preg.csv");
 //echo $_SERVER['REMOTE_ADDR'],$_SERVER['HTTP_REFERER'] 
?>

