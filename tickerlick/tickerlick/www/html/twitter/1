<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$command = escapeshellcmd('/usr/bin/env python /home/tickerlick/www/html/twitter/parse_tweets.py @elonmusk linux');
$output = shell_exec($command);
echo json_encode($output);
?>
