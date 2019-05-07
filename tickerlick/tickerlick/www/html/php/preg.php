<?php
$url = "http://info@acds.co.in";
if (preg_match("/(http:)\W.+@(.*)$/",$url,$match))
{

echo "$match[2]\n";
}
?>
