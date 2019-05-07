<html>

<head>

</head>

<body>
<?php
$email = "";
$emailerr = "email format is wrong";
$emailerr2 = "email is required";
$name="";
$namerr="name is required";
if ($_SERVER["REQUEST_METHOD"] == "POST")
{
if ($_POST['name'])
{
   $name=$_POST['name'];
   echo "$name\n";
}
else
{
   echo "$namerr\n";
}
if ($_POST['email'])
{
   $email=$_POST['email'];
   if (validateemail($email))
   {
      echo "$email\n";
   }
   else
   {
      echo "$emailerr\n";
   }
}
else
{
   echo "$emailerr2\n";
}
}
function validateemail($email)
{	
  echo "$email\n";
  $regex="^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$";
  if (preg_match("/^[\w\-\_]+\@[\w\-]+\.[\w\-]+$/",$email))
  {
   echo "1\n";
    return 1;
  }
  else
  {
   echo "0\n";
    return 0;
  }
} 
?>
<form method=post  action="mand3.php">
<input type=text name="name"/>
<input type=text name="email"/>
<input type=submit name="submit" value="submit"/>
</form>
</body>
</html>
