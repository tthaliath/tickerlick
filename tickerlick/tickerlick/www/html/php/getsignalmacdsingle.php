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
$arr = array("AAPL");
foreach ($arr as $ticker) {
$query = "select b.seq,b.ticker,b.rtq,(b.ema_diff_5_35 - b.ema_macd_5) diff, b.ema_macd_5,b.ema_diff_5_35 from secpricert b where ticker = '".$ticker."' and price_date = '2018-05-18' ORDER BY seq DESC limit 10";
#echo $query ;
$result = $conn->query($query);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $results[] = array(
      'ticker' => $rs["ticker"],
      'diff' => $rs["diff"],
      'seq' => $rs["seq"],
      'lastprice' =>  $rs["rtq"] 
      );
     #$records["records"] = $results;

}
#$records["records"] = $results;
#$records[$ticker] = $results;
}
$records["records"] = $results;
$conn->close();
echo json_encode($records);
?>
