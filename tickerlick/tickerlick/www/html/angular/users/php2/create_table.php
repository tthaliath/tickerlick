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
 $sql="CREATE TABLE Persons(FirstName CHAR(30),LastName CHAR(30),Age INT)";

 // Execute query
 if (mysqli_query($con,$sql)) {
  echo "Table persons created successfully";
} else {
  echo "Error creating table: " . mysqli_error($con);
}
 mysqli_close($con);
 ?> 
