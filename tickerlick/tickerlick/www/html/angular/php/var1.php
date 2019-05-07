<?php

$q = 5;

function mytest()
{
  //global $q;
  $q= 10;
}

mytest();
echo "$q\n";
?>
