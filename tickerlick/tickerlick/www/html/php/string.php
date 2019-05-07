<?php

// set up some string variables

$a = 'the';

$b = 'games';

$c = 'begin';

$d = 'now';

// combine them using the concatenation operator

// this returns 'the games begin now<br />'

$statement = '<br>'.$a.' '.$b.' '.$c.' '.$d.'<br />';

print $statement;

// and this returns 'begin the games now!'

$command = $c.' '.$a.' '.$b.' '.$d.'!';

print $command;

// define string

$str = 'the';

// add and assign

$str .= 'n';

// str now contains "then"

echo $str;

?>



