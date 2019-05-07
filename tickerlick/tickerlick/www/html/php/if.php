<?php
date_default_timezone_set('America/New_York');
$t=date("H");
if ($t<"21")
  {
  echo "Have a good day!";
  }
else
  {
  echo "Have a good night!";
  }
?>
