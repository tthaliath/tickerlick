<?php
$array = array(3, 5, 10, 4,11,234, 173);
foreach($array as $number) {
if(is_prime($number)) {
print "$number is prime.\n";
}
}
function is_prime($number)
{
if(($number % 2) != 0) {
return true;
}
for($i=0; $i < $number; $i++) {
// A cheap check to see if $i is even
if( ($i & 1) == 0 ) {
continue;
}
if ( ($number % $i ) == 0) {
print "$i is even.\n";
return false;
}
}
return true;
}
?>
