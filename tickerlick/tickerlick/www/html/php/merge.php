<?php
$result =[];
$array1 = array(0 => 'zero_a', 2 => 'two_a', 3 => 'three_a');
$array2 = array(1 => 'one_b', 3 => 'three_b', 4 => 'four_b');
$result = $result + $array1;
$result = $result + $array2;
$records["records"] = $result;
echo json_encode($records);
?>
