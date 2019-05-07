<?php
$email = 'tthaliath@gmail.com';
$domain = preg_replace( '!^(.+)?@(.+?)$!', '$1', $email );
echo "Domain is $domain";
?>
