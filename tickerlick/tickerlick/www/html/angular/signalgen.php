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
