<?php
$con=mysqli_connect("localhost","root","Neha*2005","tickmaster");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }
//$db = mysql_select_db("tickmaster", $connection); // Selecting Database.
$fname=$_POST['name1']; // Fetching Values from URL.
$lname=$_POST['name2']; // Fetching Values from URL.
$email=$_POST['email1'];
//$password= sha1($_POST['password1']); // Password Encryption, If you like you can also leave sha1.
$password= $_POST['password1'];
// Check if e-mail address syntax is valid or not
$email = filter_var($email, FILTER_SANITIZE_EMAIL); // Sanitizing email(Remove unexpected symbol like <,>,?,#,!, etc.)
if (!filter_var($email, FILTER_VALIDATE_EMAIL)){
echo "Invalid Email.......";
}else{
$result = mysqli_query($con,"SELECT * FROM usermaster WHERE usermail='$email'");
//$data = mysqli_num_rows($result);
$row_cnt = $result->num_rows;
if(($row_cnt)==0){
$query = mysqli_query($con,"insert into usermaster(firstname,lastname,usermail,userpwd) values ('$fname','$lname', '$email', '$password')"); // Insert query
if($query){
echo "You have Successfully Registered.....";
}else
{
echo "Error....!!";
}
}else{
//print "<h2>" . $email . " is already registered</h2>";

echo "This email is already registered, Please try another email...";
}
}
mysqli_close ($con);
?>
