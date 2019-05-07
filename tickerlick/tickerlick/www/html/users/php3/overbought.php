<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

 $result = mysqli_query($con,"SELECT a.ticker,a.comp_name FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id");
 echo "<table>";
 echo "<tr><td>Symbol<td>Security Name</td></tr>";
 while($row = mysqli_fetch_array($result)) {
   echo "<tr><td>".$row['ticker'] . "<td>" . $row['comp_name']."</td></tr>";
 }
 echo "</table>"; 
 mysqli_close($con);
 ?> 
