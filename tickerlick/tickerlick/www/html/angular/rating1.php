<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

$ratinghash = array('U'=>'Upgrade','D'=>'Downgrade','P'=>'Price','I'=>'Initiated');
// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

//$ticker_id = $_GET['r'];

$result = $conn->query("select brokerage_name,rating_date,updown,rating_from,rating_to,price_from,price_to from rating_master where ticker_id = 9 order by rating_date desc limit 10");

$outp = "";
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    if ($outp != "") {$outp .= ",";}
    $rating = $ratinghash[ $rs["updown"] ];
    $outp .= '{"name":"'  . $rs["brokerage_name"] . '",';
    $outp .= '"date":"'   . $rs["rating_date"]        . '",';

}
$outp ='{"records":['.$outp.']}';
$conn->close();

echo($outp);
?>
