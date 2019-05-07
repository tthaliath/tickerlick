<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
     $query = "select price_date,close_price from tickerprice where ticker_id = 9 and price_date > '2016-06-01'";
$result = mysqli_query($con,$query);
echo json_encode($result->fetchAll(PDO::FETCH_ASSOC));
 mysqli_close($con);
?> 
