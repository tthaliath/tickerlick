<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");
// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

 $rep_type = $_GET['q'];
 switch ($rep_type) {
   case "os":
     $title = "MACD (5,35,5) Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id order by sector";
     break;
   case "ob":
     $title = "MACD (5,35,5) Overbought (Bearish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id order by sector";
     break;
   case "rs":
     $title = "RSI Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RS') and a.ticker_id = b.ticker_id order by sector";
     break;
   case "rb":
     $title = "RSI Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RB') and a.ticker_id = b.ticker_id order by sector";
     break;
     case "ss":
     $title = "Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SS') and a.ticker_id = b.ticker_id order by sector";
     break;
   case "sb":
     $title = "Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SB') and a.ticker_id = b.ticker_id order by sector";
     break;
    case "mbu":
     $title = "MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBU' and b.ticker_id = a.ticker_id order by sector";
     break;
   case "mbe":
     $title = "MACD Bearish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBE' and b.ticker_id = a.ticker_id order by  sector";
     break;
   case "vbe":
     $title = "Very Bearish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SB','RB','OB','MBE') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id";
     break;
   case "vbu":
     $title = "Very Bullish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SS','RS','OS','MBU') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id";
     break;
   case "bbu":
     $title = "Bollinger Bullish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBU' and b.ticker_id = a.ticker_id order by val desc";
     break;
   case "bbe":
     $title = "Bollinger Bearish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBE' and b.ticker_id = a.ticker_id order by val desc";
     break;
   case "mbux":
     $title = "S&P 500 - MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'mbu' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
     break;
   case "osx":
     $title = "S&P 500 - MACD Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'os' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
     break;
   case "rsx":
     $title = "S&P 500 - RSI Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'rs' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
     break;
  case "ssx":
     $title = "S&P 500 - Stochastic Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'ss' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
     break;
  case "bbux":
     $title = "S&P 500 - Bollinger Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'bbu' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
    break;
  case "ssrx":
     $title = "S&P 500 - Stochastic RSI Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'ssr' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by val desc";
     break;  
   case "ssr":
     $title = "Stochastic RSI Oversold (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'SSR' and b.ticker_id = a.ticker_id order by val desc";
     break; 
   case "sbr":
     $title = "Stochastic RSI Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SBR') and a.ticker_id = b.ticker_id order by sector";
     break;
    case "xob":
     $title = "Extremely Overbought";
     $query = "SELECT distinct a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b, (select ticker_id,count(*) from report c where c.report_flag in ('BBE','MBE','OB','RB','SB') group by c.ticker_id having count(*) > 2) c where b.ticker_id = a.ticker_id and b.ticker_id = c.ticker_id order by sector";
     break;
    case "xos":
     $title = "Extremely Oversold";
     $query = "SELECT distinct a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b, (select ticker_id,count(*) from report c where c.report_flag in ('BBU','MBU','OS','RS','SS') group by c.ticker_id having count(*) > 2) c where b.ticker_id = a.ticker_id and b.ticker_id = c.ticker_id order by sector";
     break;

   default:
     echo "";
     return;
 }
$result = $conn->query($query);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $results[] = array(
      'ticker' => $rs["ticker"],
      'compname' => $rs["comp_name"],
      'sector' => $rs["sector"],
      'industry' => $rs["industry"],
      );

}
$conn->close();
$records["records"] = $results;
echo json_encode($records);
?> 
