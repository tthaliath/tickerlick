<?php
$cars=array("Volvo","BMW","Toyota");
echo "I like " . $cars[0] . ", " . $cars[1] . " and " . $cars[2] . ".";
?>

<?php
$cars=array("Volvo","BMW","Toyota");
echo count($cars);
?>


<?php
$cars=array("Volvo","BMW","Toyota");
$arrlength=count($cars);

for($x=0;$x<$arrlength;$x++)
  {
  echo $cars[$x];
  echo "<br>";
  }
$cols = array ('blue','red','white','yellow');
echo count($cols);
echo "<br>".$cols[1];
?> 


