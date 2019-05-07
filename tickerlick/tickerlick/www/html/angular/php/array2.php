<?php
$array = array ('a' => 'apple', 'b' => 'berry');
while ($fruit = current ($array))
{
    echo "$fruit\n";
    next($array);
}

foreach ($array as  $key=>$value)
{
    echo "$key\t$value\n";
}  
?>
