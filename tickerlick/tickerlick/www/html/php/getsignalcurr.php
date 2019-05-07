<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","cryptomaster");

$ratinghash = array('U'=>'Upgrade','D'=>'Downgrade','P'=>'Price','I'=>'Initiated');
// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

$today =  date("Y-m-d");
#$today = '2018-05-08';
#$todaystr = date("D, M d");
$query = "select indicator, tradesignal, ticker, rtq, rsi_14,sma_3_3_stc_osci_14 from (select 'RSI' as indicator,'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 < 25  and d.rsi_14 != 0 union select 'RSI' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 > 75  and d.rsi_14 != 0 union select 'Stochastic' as indicator,  'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 < 20 and d.sma_3_3_stc_osci_14  >  1 union select 'Stochastic' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 > 80 and d.sma_3_3_stc_osci_14 < 99 union select 'Bollinger Band' as indicator, 'Buy' as tradesignal, d.ticker,d.rtq, d.rsi_14,abs((d.rtq - (d.dma_20 - (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq < (d.dma_20 - (2 * d.dma_20_sd)) union select 'Bollinger Band' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14, abs((d.rtq - (d.dma_20 + (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '".$today."' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq > abs((d.dma_20 + (2 * d.dma_20_sd)))) x order by x.ticker"; 
$result = $conn->query($query);
$results = array();
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    $results[] = array(
      'ticker' => $rs["ticker"],
      'indicator' => $rs["indicator"],
      'signal' => $rs["tradesignal"],
      'lastprice' =>  $rs["rtq"] 
      );

}
$conn->close();
$records["records"] = $results;
echo json_encode($records);
?>
