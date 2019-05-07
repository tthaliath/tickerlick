<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

$ratinghash = array('U'=>'Upgrade','D'=>'Downgrade','P'=>'Price','I'=>'Initiated');
// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

$today =  date("Y-m-d");
#$today = '2017-11-30';
#$todaystr = date("D, M d");
$arr = array("AAPL","NVDA","AMD","EBAY","AMZN","TSLA","FB","NFLX","AGN","QCOM","SQ","TWTR","SPY","QQQ","GOOGL","AAL","GBTC","GE","AA");
foreach ($arr as $ticker) {
$query = "select b.cr_time,b.ticker,b.rtq,b.ema_macd_5,b.ema_diff_5_35 from secpricert b where ticker = '".$ticker."' and price_date = '2018-05-04' ORDER BY seq DESC limit 5";
#echo $query ;
$result = $conn->query($query);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $results[] = array(
      'ticker' => $rs["ticker"],
      'diff' => $rs["cr_time"],
      'lastprice' => $rs["rtq"],
      'ema_macd_5' =>  $rs["ema_macd_5"] ,
      'ema_diff_5_35' => $rs["ema_diff_5_35"]
      );

}
$records["records"][$ticker] = $results;
#$records[$ticker] = $results;
}
$conn->close();
echo json_encode($records);
?>
