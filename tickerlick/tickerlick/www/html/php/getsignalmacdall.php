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
#$today = '2018-06-01';
#$todaystr = date("D, M d");
$record = [];
$query_main = "select distinct z.ticker from (select indicator, tradesignal, ticker, rtq, rsi_14,sma_3_3_stc_osci_14 from (select 'RSI' as indicator,'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 < 25  and d.rsi_14 != 0 union select 'RSI' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 > 75  and d.rsi_14 != 0 union select 'Stochastic' as indicator,  'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 < 20 and d.sma_3_3_stc_osci_14  >  1 union select 'Stochastic' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 > 80 and d.sma_3_3_stc_osci_14 < 99 union select 'Bollinger Band' as indicator, 'Buy' as tradesignal, d.ticker,d.rtq, d.rsi_14,abs((d.rtq - (d.dma_20 - (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq < (d.dma_20 - (2 * d.dma_20_sd)) union select 'Bollinger Band' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14, abs((d.rtq - (d.dma_20 + (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq > abs((d.dma_20 + (2 * d.dma_20_sd)))) x) z";

$result_main = $conn->query($query_main);
while($rs_main = $result_main->fetch_array(MYSQLI_ASSOC)) {

$ticker =  $rs_main["ticker"];
$query_det = "select b.ticker,b.rtq,(b.ema_diff_5_35 - b.ema_macd_5) diff from secpricert b where ticker = '".$ticker."' and price_date = '".$today."' ORDER BY seq DESC limit 5";
#echo $query ;
$result = $conn->query($query_det);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
     array_push($record, array(
      'ticker' => $rs["ticker"],
      'diff' => $rs["diff"],
      'lastprice' =>  $rs["rtq"]
      ));

}
}
$records["records"] = $record;
$conn->close();
echo json_encode($records);
?>
