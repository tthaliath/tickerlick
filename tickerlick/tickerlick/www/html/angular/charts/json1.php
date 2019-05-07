<?php
require("dbinfo.php");
$database="tickmaster';
$dsn = 'mysql:host=localhost;dbname='.$database.';charset=utf8';

try {
  $dbh = new PDO($dsn, 'root','Neha*2005');

} catch (PDOException $e) {
  exit('DB connect error'.$e->getMessage());
}
$st = $dbh->query("select price_date,close_price from tickerprice where ticker_id = 9 and price_date > '2016-06-01'");
echo json_encode($st->fetchAll(PDO::FETCH_ASSOC));
?>
