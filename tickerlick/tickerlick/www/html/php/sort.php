<?php
$numbers=array(4,6,2,22,11);
sort($numbers);
var_dump ($numbers);
?>

<?php
$numbers=array(4,6,2,22,11);
rsort($numbers);
var_dump ($numbers);
?>


<?php
$age=array("Peter"=>"35","Ben"=>"33","Joe"=>"43");
arsort($age);
var_dump ($age);
?> 


<?php
$age=array("Peter"=>"35","Ben"=>"33","Joe"=>"43");
krsort($age);
var_dump ($age);
?> 


