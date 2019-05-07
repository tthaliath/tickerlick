<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

$query = $_GET['r'];
 $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBE' and b.ticker_id = a.ticker_id order by  sector desc";
$result = $conn->query($query);
$outp = "";
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    if ($outp != "") {$outp .= ",";}
    $outp .= '{"ticker":"'  . $rs["ticker"] . '",';
    $outp .= '"compname":"'   . $rs["comp_name"]        . '",';
    $outp .= '"sector":"'. $rs["sector"]    . '",'; 
    $outp .= '"industry":"'. $rs["industry"]     . '"}';
}
$outp ='{"records":['.$outp.']}';
$conn->close();

echo($outp);
?>
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

$ratinghash = array('U'=>'Upgrade','D'=>'Downgrade','P'=>'Price','I'=>'Initiated');
// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

$ticker_id = $_GET['q'];

$result = $conn->query("select brokerage_name,rating_date,updown,rating_from,rating_to,price_from,price_to from rating_master where ticker_id = $ticker_id order by rating_date desc limit 10");

$outp = "";
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    if ($outp != "") {$outp .= ",";}
    $rating = $ratinghash[ $rs["updown"] ];
    $converted = trim($rs["rating_from"],chr(0xC2).chr(0xA0)); 
    $outp .= '{"brokeragename":"'  . $rs["brokerage_name"] . '",';
    $outp .= '"ratingdate":"'   . $rs["rating_date"]        . '",';
    $outp .= '"updown":"'. $rating    . '",'; 
    $outp .= '"ratingfrom":"'. $converted     . '",';
    $outp .= '"ratingto":"'. $rs["rating_to"]     . '",';
    $outp .= '"pricefrom":"'. $rs["price_from"]     . '",';
    $outp .= '"priceto":"'. $rs["price_to"]     . '"}';

}
$outp ='{"records":['.$outp.']}';
$conn->close();

echo($outp);
?>
