<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

 $result = mysqli_query($con,"select ticker, comp_name,sector, cnt from tickermaster a, (select ticker_id,count(*) cnt from report where report_flag in ('OB','SB','RB') group by ticker_id having count(*) > 1) b where a.ticker_id = b.ticker_id order by cnt desc, sector");

echo "<table>";
echo "<tr><td>Symbol<td>Security Name</td><td>Sector</td><td>Count</td></tr>";
 while($row = mysqli_fetch_array($result)) {
   echo "<tr><td>";
   echo $row['ticker'] . "</td><td>" . $row['comp_name'] ."</td><td>". $row['sector'] ."</td><td>". $row['cnt'];
   echo "</td></tr>";
 }
echo "</table>"; 
 mysqli_close($con);
 ?> 
