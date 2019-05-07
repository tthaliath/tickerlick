<?php
 $con=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");
$sql = "select ticker_id,report_flag from report where report_flag in ('MBU','SS')";

$result = mysqli_query($con,$sql);
while($row = mysqli_fetch_array($result))
{
    echo $row['ticker_id']." ".$row['report_flag']."\n";
}

mysqli_close ($con);
?>

