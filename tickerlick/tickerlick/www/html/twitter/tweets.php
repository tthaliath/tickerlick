<?php 
$screenname = '';
$keyword='';
$screenname = $_GET["screenname"];
$keyword = $_GET["keyword"];
$nooftweets = 10;
if (!isset($_GET["nooftweets"])) {
   $nooftweets = 10;
}
else {
   $nooftweets = $_GET["nooftweets"];
}
if ($nooftweets > 200) {
   $nooftweets = 200;
}
$command = escapeshellcmd('/usr/bin/env python /home/tickerlick/www/html/twitter/parse_tweets.py '.$screenname.' '.$keyword.' '.$nooftweets);
$output = shell_exec($command);
echo '<div id="bottom">';
echo '<table border="1" cellpadding="1" cellspacing="1" width="80%" align="center" style="border-collapse: collapse;">';
echo '<tr bgcolor="#00FFFF"><th colspan=4>Matched Tweets</th></tr>';
echo '<tr bgcolor="#00FFFF"><td>No</td><td>User Name</td><td>Created at</td><td>Text</td></tr>';
echo $output;
echo "</table>";
echo "</div>";
?>
