<?php 
$screenname = $_GET["u"];
$keyword = $_GET["k"];
$command = escapeshellcmd('/usr/bin/env python /home/tickerlick/www/html/twitter/get_tweets.py '.$screenname);
$output = shell_exec($command);
echo $command;
echo $screenname;
echo $keyword;
echo $output;
echo '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
echo '<tr bgcolor="#00FFFF"><th colspan=4>'.$title.'</th></tr>';
echo "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td></tr></table>";
?>
