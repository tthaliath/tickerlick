<?php 
for ($x=0; $x<=10; $x++)
  {
  echo "The number is: $x <br>";
  } 
?>

<?php 
$colors = array("red","green","blue","yellow"); 
foreach ($colors as $value)
  {
  echo "$value <br>";
  }
while ($val = current ($colors))
{
   echo "$val\n";
   next ($colors);
}
?> 


