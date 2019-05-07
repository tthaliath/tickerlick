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
 mysqli_query($con,"INSERT INTO Persons (FirstName, LastName, Age)
 VALUES ('Peter', 'Griffin',35)");

 mysqli_query($con,"INSERT INTO Persons (FirstName, LastName, Age) 
 VALUES ('Glenn', 'Quagmire',33)");

 mysqli_close($con);
 ?> 
