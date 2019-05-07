<?php
$con=mysqli_connect("localhost","root","Neha*2005","tickmaster");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }
$id = 33;
$result = mysqli_query($con,"SELECT  price_date FROM tickerprice where ticker_id = ".$id);

while($row = mysqli_fetch_array($result))
  {
  echo $row['price_date'];
  echo "<br>";
  }

mysqli_close($con);
?> 

