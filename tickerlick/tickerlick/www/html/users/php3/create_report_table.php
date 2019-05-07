<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
 else
 {
    echo "db connection successful";
 }

// Create table
 $sql=" CREATE TABLE report ( ticker_id int(11) NOT NULL, report_flag varchar(1)  NOT NULL)";

 // Execute query
 if (mysqli_query($con,$sql)) {
  echo "Table report created successfully";
} else {
  echo "Error creating table: " . mysqli_error($con);
}

// create index on report_flag
$sql=" CREATE index report_flag_idx on report(report_flag)";

 // Execute query
 if (mysqli_query($con,$sql)) {
  echo "Table report indexed successfully";
} else {
  echo "Error indexing table: " . mysqli_error($con);
}
 mysqli_close($con);
 ?> 
