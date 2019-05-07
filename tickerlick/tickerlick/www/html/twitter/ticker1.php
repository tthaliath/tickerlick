<?php 
$screenname = $_POST["screenname"];
$keyword = $_POST["keyword"];
$keyword = 'linux';
$screenname = '@elonmusk';
$command = escapeshellcmd('/usr/bin/env python /home/tickerlick/www/html/twitter/parse_tweets.py '.$screenname.' '.$keyword);
$output = shell_exec($command);
echo '<div id="bottom">';
echo '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
echo '<tr bgcolor="#00FFFF"><th colspan=4>Matched Tweets</th></tr>';
echo "<tr><td>No</td><td>username</td><td>Created at</td><td>text</td></tr>";
echo '<tr bgcolor="#00FFFF"><th colspan=4>'.$output.'</th></tr>';
echo "</table>";
echo "</div>";
?>
