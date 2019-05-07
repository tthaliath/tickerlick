<?php
$x=5; // global scope

function myTest()
{
$y=10; // local scope
//global $x;
global $y;
$y = 45;
echo "<p>Test variables inside the function:<p>";
echo "Variable x is: $x";
echo "<br>";
echo "Variable y is: $y";
} 

myTest();

echo "<p>Test variables outside the function:<p>";
echo "Variable x is: $x";
echo "<br>";
echo "Variable y is: $y";
?> 


