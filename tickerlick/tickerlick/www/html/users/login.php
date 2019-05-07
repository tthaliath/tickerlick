<?PHP
require_once("./include/membersite_config.php");

if(isset($_POST['submitted']))
{
   if($fgmembersite->Login())
   {
        if (isset($_POST['ma']))
        {
           $fgmembersite->RedirectToURL("/users/ma.php");
        }
        else
        {
           $fgmembersite->RedirectToURL("/users/login-home.php");
        }
   }
}

?>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6 lt8"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7 lt8"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8 lt8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<head>
       <meta charset="UTF-8" />
       <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">  -->
       <meta name="keywords" lang="en-US" content="MACD, Stochastic, Bollinger, RSI, Oversold, Overbought, Stock Research, Investment Tools,Thomas Thaliath"/>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <meta name="description" content="TICKERLICK - Real time buy and sell signals based on technical indicators" />
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://luckyticker.com/common/ishtaar.css" type="text/css">
      <!--<link rel="stylesheet" type="text/css" href="style/userlogin.css">-->
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
<title>LuckyTicker - Login</title>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>
  <table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=5></td></tr>
  <tr>
                <tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=5></td></tr>
   </table>
   <table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=1></td></tr>
   </table>

<!-- Form Code Start -->
<div id='fg_membersite' align="center">
<form id='login' action='<?php echo $fgmembersite->GetSelfScript(); ?>' method='post' accept-charset='UTF-8'>
<fieldset id="inputs">
<legend>Login</legend>
<?PHP
if(isset($_GET["p"]))
{
   echo "<input type='hidden' name='ma' id='ma' value='1'/>";
}
?>
<input type='hidden' name='submitted' id='submitted' value='1'/>
<div class='short_explanation'>* Required fields</div>

<div><span class='error'><?php echo $fgmembersite->GetErrorMessage(); ?></span></div>
<div class='container'>
    <label for='username' >Email*:</label><br/>
    <input type='text' name='username' id='username' value='<?php echo $fgmembersite->SafeDisplay('username') ?>' maxlength="50" /><br/>
    <span id='login_username_errorloc' class='error'></span>
</div>
<div class='container'>
    <label for='password' >Password*:</label><br/>
    <input type='password' name='password' id='password' maxlength="50" /><br/>
    <span id='login_password_errorloc' class='error'></span>
</div>
<div class='container'>
    <input type='submit' name='Submit' value='Submit' />
</div>
<div class='long_explanation'><a href='/users/reset-pwd-req.php'>Forgot Password?</a></div><br>
<div class='long_explanation'>Not a member yet? <a href="/users/register.php">Register</a></div>
</fieldset>
<table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr>
        <td>
                <a href="http://www.luckyticker.com">Home</a>
                <a href="http://www.luckyticker.com/aboutus.htm">About LuckyTicker</a>
                <a href="http://www.luckyticker.com/contactus.htm">Contact Us</a>
                <a href="http://www.luckyticker.com/disclaimer.htm">Disclaimer</a>
        </td>
  </tr>

  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr></tr><td align="center"><font size=-1>&copy;2012 LuckyTicker - All rights reserved.</font><p></p></td></tr>
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=10></td></tr>
</table>
</form>
</div>
<!-- client-side Form Validations:
Uses the excellent form validation script from JavaScript-coder.com-->

<script type='text/javascript'>
// <![CDATA[

    var frmvalidator  = new Validator("login");
    frmvalidator.EnableOnPageErrorDisplay();
    frmvalidator.EnableMsgsTogether();

    frmvalidator.addValidation("username","req","Please provide your username");
    
    frmvalidator.addValidation("password","req","Please provide the password");

// ]]>
</script>
</div>
<!--
Form Code End (see html-form-guide.com for more info.)
-->
</div>
</body>
</html>
