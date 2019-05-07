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

<form action="login.php" method="post">
 <fieldset>
 <legend>Login Form  </legend>

 <p>Enter Your username and Password Below  </p>

 <div>
 <label for="name">Email :</label>
 <input type="text" id="e-mail" name="e-mail" size="25" />
 </div>

 <div>
 <label for="Password">Password:</label>
 <input type="password" id="Password" name="Password" size="25" />
 </div>
 <div>
 <input type="hidden" name="formsubmitted" value="TRUE" />
 <input type="submit" value="Login" />
 </div>
 </fieldset>
</form>
 
 mysqli_close($dbc);
?> 
