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
$results = array();

$outp = "";
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $rating = $ratinghash[ $rs["updown"] ];
    $converted = trim($rs["rating_to"],chr(0xC2).chr(0xA0)); 
    $results[] = array(
      'brokeragename' =>($rs["brokerage_name"]),
      'ratingdate' => $rs['rating_date'],
      'updown' => $rating,
      'ratingfrom' => $rs["rating_from"],
      'ratingto' => $converted,
      'pricefrom' => $rs["price_from"],
      'priceto' => $rs["price_to"]
      ); 

}
$conn->close();
$records["records"] = $results; 
echo json_encode($records);
?>
