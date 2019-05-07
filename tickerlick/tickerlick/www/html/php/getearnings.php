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
#$today = '2017-10-30';
$todaystr = date("D, M d");
$query = "select t.ticker,t.comp_name,t.sector,t.industry from earnings_master e, tickermaster t where e.ticker_id = t.ticker_id and e.earnings_date = '".$today."' order by t.tflag desc, t.ticker"; 
$result = $conn->query($query);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $results[] = array(
      'ticker' => $rs["ticker"],
      'compname' => $rs["comp_name"],
      'sector' => $rs["sector"],
      'industry' => $rs["industry"],
      'earnings_date' => $todaystr
      );

}
$conn->close();
$records["records"] = $results;
echo json_encode($records);
?>
