<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

 $req = "SELECT a.ticker, a.comp_name "
	."FROM tickermaster a "
	."WHERE (a.comp_name LIKE '%".$_REQUEST['term']."%' or a.ticker LIKE '%".$_REQUEST['term']."%')"; 
 $result = mysqli_query($con,$req);

 while($row = mysqli_fetch_array($result)) {
      $str = $row['ticker']."  ". $row['comp_name'];
      $results[] = array('label' => $str);
 }

echo json_encode($results);
 
 mysqli_close($con);
 ?> 
