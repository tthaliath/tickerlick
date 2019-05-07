<?php
 $dbc=mysqli_connect("ip-50-63-188-209.ip.secureserver.net","root","Neha*2005","tickmaster");

// Check connection
 if (mysqli_connect_errno()) {
   echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }

//This is the address that will appear coming from ( Sender )
DEFINE('EMAIL', 'info@tickerlick.com');

/*Define the root url where the script will be found such as
http://website.com or http://website.com/Folder/ */
DEFINE('WEBSITE_URL', 'http://tickerlick.com/login');

if (isset($_GET['email']) && preg_match('/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/',
 $_GET['email'])) {
 $email = $_GET['email'];
}
if (isset($_GET['key']) && (strlen($_GET['key']) == 32))
 //The Activation key will always be 32 since it is MD5 Hash
 {
 $key = $_GET['key'];
}

if (isset($email) && isset($key)) {

 // Update the database to set the "activation" field to null
echo '<div>'.$email.'</div>';
echo '<div>'.$key.'</div>';
 $query_activate_account = "UPDATE usermaster SET activation_cd='',active = 'Y' WHERE usermail ='$email' AND activation_cd='$key'";
echo '<div>'.$query_activate_account.'</div>';
 $result_activate_account = mysqli_query($dbc, $query_activate_account);

 // Print a customized message:
 if (mysqli_affected_rows($dbc) == 1) //if update query was successfull
 {
 echo '<div>Your account is now active. You may now <a href="login.php">Log in</a></div>';

 } else {
 echo '<div>Oops !Your account could not be activated. Please recheck the link or contact the system administrator.</div>';

 }

 mysqli_close($dbc);

} else {
 echo '<div>Error Occured .</div>';
}
 
 mysqli_close($dbc);
 ?> 
