<?php

function myTest()
{
static $x=0;
echo "<h1>$x</h1>";
$x++;
}

myTest();
myTest();
myTest();
echo phpversion();
?> 


