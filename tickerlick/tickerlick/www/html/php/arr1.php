<?php
$txt1="Learn PHP";
$txt2="W3Schools.com";
$cars=array("Volvo","BMW","Toyota","Nissan");
function incr()
{
static $x=0;
global $cars;
echo "My car is a {$cars[$x]}";
$x++;
}

echo $txt1;
echo "<br>";
echo "Study PHP at $txt2";
incr();
incr();
incr();
incr();
?> 


