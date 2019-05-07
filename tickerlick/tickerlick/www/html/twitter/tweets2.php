<?php 
$command = escapeshellcmd('/usr/bin/env python /home/tickerlick/www/html/twitter/parse_tweets.py @elonmusk linux');
$output = shell_exec($command);
echo '<div id="bottom">';
 echo '<p>'.$output.'</p';
 echo "</div>";
?>
