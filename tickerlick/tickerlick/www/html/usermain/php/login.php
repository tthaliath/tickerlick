<?php
$con=mysqli_connect("localhost","root","Neha*2005","tickmaster");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }
//$db = mysql_select_db("tickmaster", $connection); // Selecting Database.
$email=$_POST['username'];
//$password= sha1($_POST['password']); // Password Encryption, If you like you can also leave sha1.
$password= $_POST['password'];
// Check if e-mail address syntax is valid or not

echo "dddddd-".$email;
$email = filter_var($email, FILTER_SANITIZE_EMAIL); // Sanitizing email(Remove unexpected symbol like <,>,?,#,!, etc.)
if (!filter_var($email, FILTER_VALIDATE_EMAIL)){
echo "Invalid Email.......";
}else{
$result = mysqli_query($con,"SELECT firstname FROM usermaster WHERE usermail COLLATE latin1_general_cs  ='$email' and userpwd='$password'");
//$data = mysqli_num_rows($result);
$row_cnt = $result->num_rows;
if(($row_cnt)==1)
{
echo "You have Successfully logged in....";
}
else
{
echo "Invalid Email or Password. Please try again..!!";
}
}
mysqli_close ($con);
?>
