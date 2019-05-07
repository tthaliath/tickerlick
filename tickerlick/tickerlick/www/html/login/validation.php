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

if (isset($_POST['formsubmitted'])) {
 // Initialize a session:
session_start();
 $error = array();//this aaray will store all error messages

 if (empty($_POST['e-mail'])) {//if the email supplied is empty
 $error[] = 'You forgot to enter  your Email ';
 } else {

 if (preg_match("/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/", $_POST['e-mail'])) {
 $Email = $_POST['e-mail'];
 } else {
 $error[] = 'Your EMail Address is invalid  ';
 }
}

if (empty($_POST['Password'])) {
 $error[] = 'Please Enter Your Password ';
 } else {
 $Password = $_POST['Password'];
 }

 if (empty($error))//if the array is empty , it means no error found
 {
$query_check_credentials = "SELECT * FROM members WHERE (Email='$Email' AND password='$Password') AND Activation IS NULL";
 $result_check_credentials = mysqli_query($dbc, $query_check_credentials);
 if(!$result_check_credentials){//If the QUery Failed
 echo 'Query Failed ';
 }

 if (@mysqli_num_rows($result_check_credentials) == 1)//if Query is successfull
 { // A match was made.

 $_SESSION = mysqli_fetch_array($result_check_credentials, MYSQLI_ASSOC);

//Assign the result of this query to SESSION Global Variable

 header("Location: page.php");

 }else
 { $msg_error= 'Either Your Account is inactive or Email address /Password is Incorrect';
 }
}  else {
 echo '<div> <ol>';
 foreach ($error as $key => $values) {
 echo '    <li>'.$values.'</li>';
}
 echo '</ol></div>';
}
 if(isset($msg_error)){
 echo '<div>'.$msg_error.' </div>';
 }
 /// var_dump($error);
} // End of the main Submit conditional.
 
 mysqli_close($dbc);
 ?> 
