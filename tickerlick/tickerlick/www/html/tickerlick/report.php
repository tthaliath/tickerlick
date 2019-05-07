<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
 $rep_type = $_GET['r'];

 switch ($rep_type) {
   case "mos":
     $title = "MACD (5,35,5) Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id";
     break;
   case "mob":
     $title = "MACD (5,35,5) Overbought (Bearish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id";
     break;
   case "ros":
     $title = "RSI/Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry,cnt from tickermaster a, (select ticker_id,count(*) cnt from report where report_flag in ('OS','SS','RS') group by ticker_id having count(*) > 1) b where a.ticker_id = b.ticker_id order by cnt desc, sector";
     break;
   case "rob":
     $title = "RSI/Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry, cnt from tickermaster a, (select ticker_id,count(*) cnt from report where report_flag in ('OB','SB','RB') group by ticker_id having count(*) > 1) b where a.ticker_id = b.ticker_id order by cnt desc, sector";
     break;
    case "mbu":
     $title = "MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBU' and b.ticker_id = a.ticker_id";
     break;
   case "mbe":
     $title = "MACD Bearish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBE' and b.ticker_id = a.ticker_id";
     break;
   default:
     echo "Please choose a report";
     return;
 }
 $result = mysqli_query($con,$query);
 echo '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
 echo '<tr bgcolor="#00FFFF"><th colspan=4>'.$title.'</th></tr>';
 echo "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td></tr>";
 while($row = mysqli_fetch_array($result)) {
   echo "<tr><td>";
   echo "<a href=http://www.tickerlick.com/cgi-bin/gettickerdataone.cgi?q=".$row['ticker'].">".$row['ticker']."</a></td><td>" . $row['comp_name'] ."</td><td>". $row['sector'] ."</td><td>". $row['industry'];
   echo "</td></tr>";    
 }
 echo "</table>";
 
 mysqli_close($con);
 ?> 
