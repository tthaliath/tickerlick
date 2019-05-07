use Switch;
 switch ($rep_type) {
   case "os" {
     $title = "MACD (5,35,5) Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id order by sector";
     }
   case "ob" {
     $title = "MACD (5,35,5) Overbought (Bearish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id order by sector";
     }
   case "rs" {
     $title = "RSI Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry,b.* from tickermaster a, report b where report_flag in ('RS') and a.ticker_id = b.ticker_id order by sector";
     }
   case "rb" {
     $title = "RSI Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry,b.* from tickermaster a, report b where report_flag in ('RB') and a.ticker_id = b.ticker_id order by sector";
     }
   case "ss" {
     $title = "Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry,b.* from tickermaster a, report b where report_flag in ('SS') and a.ticker_id = b.ticker_id order by sector";
     }
   case "sb" {
     $title = "Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry,b.* from tickermaster a, report b where report_flag in ('SB') and a.ticker_id = b.ticker_id order by sector";
     }
   case "mbu" {
     $title = "MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBU' and b.ticker_id = a.ticker_id order by sector";
     }
   case "mbe" {
     $title = "MACD Bearish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBE' and b.ticker_id = a.ticker_id order by  sector";
     }
     else  {
     print "Please choose a report";
     }
 }
 print '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
 print  '<tr bgcolor="#00FFFF"><th colspan=4>'.$title.'</th></tr>';
 print "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td></tr>";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   print "<tr><td>";
   print "<a href=http://www.luckyticker.com/cgi-bin/gettickerdataone.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[4];
   print "</td></tr>";    
 }
 print "</table>";
