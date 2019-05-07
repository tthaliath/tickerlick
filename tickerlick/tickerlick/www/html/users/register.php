<?PHP
require_once("./include/membersite_config.php");

if(isset($_POST['submitted']))
{
   if($fgmembersite->RegisterUser())
   {
        $fgmembersite->RedirectToURL("/users/thank-you.html");
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
       <meta name="description" content=LUCKYTICKER - Real time buy and sell signals based on technical indicators" />
      <title>Register</title>
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://luckyticker.com/common/ishtaar.css" type="text/css">
      <!--<link rel="stylesheet" type="text/css" href="style/userlogin.css">-->
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
      <link rel="STYLESHEET" type="text/css" href="style/pwdwidget.css" />
      <script src="scripts/pwdwidget.js" type="text/javascript"></script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>
  <table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=5></td></tr>
  <tr>
                <tr>
        <td height="25" class="companytext" ><font color="#05840C">LUCKY</font><font color="#FA3205">TICKER</font>
        </td>

  </tr>
   <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=5></td></tr>
   </table>
   <table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=1></td></tr>
   </table>

<!-- Form Code Start -->
<div id='fg_membersite' align="center">
<form id='register' action='<?php echo $fgmembersite->GetSelfScript(); ?>' method='post' accept-charset='UTF-8'>
<fieldset >
<legend>Register</legend>

<input type='hidden' name='submitted' id='submitted' value='1'/>

<div class='short_explanation'>* required fields</div>
<input type='text'  class='spmhidip' name='<?php echo $fgmembersite->GetSpamTrapInputName(); ?>' />

<div><span class='error'><?php echo $fgmembersite->GetErrorMessage(); ?></span></div>
<div class='container'>
    <label for='name' >Screen Name*: </label><br/>
    <input type='text' name='name' id='name' value='<?php echo $fgmembersite->SafeDisplay('name') ?>' maxlength="50" /><br/>
    <span id='register_name_errorloc' class='error'></span>
</div>
<div class='container'>
    <label for='username' >Email Address*:</label><br/>
    <input type='text' name='username' id='username' value='<?php echo $fgmembersite->SafeDisplay('username') ?>' maxlength="50" /><br/>
    <span id='register_username_errorloc' class='error'></span>
</div>
<div class='container' style='height:80px;'>
    <label for='password' >Password*:</label><br/>
    <div class='pwdwidgetdiv' id='thepwddiv' ></div>
    <noscript>
    <input type='password' name='password' id='password' maxlength="50" />
    </noscript>    
    <div id='register_password_errorloc' class='error' style='clear:both'></div>
</div>

<div class='container'>
    <input type='submit' name='Submit' value='Submit' />
</div>

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
<!-- client-side Form Validations:
Uses the excellent form validation script from JavaScript-coder.com-->

<script type='text/javascript'>
// <![CDATA[
    var pwdwidget = new PasswordWidget('thepwddiv','password');
    pwdwidget.enableGenerate = false;
    pwdwidget.MakePWDWidget();
    
    var frmvalidator  = new Validator("register");
    frmvalidator.EnableOnPageErrorDisplay();
    frmvalidator.EnableMsgsTogether();
    frmvalidator.addValidation("name","req","Please provide your name");

    frmvalidator.addValidation("email","req","Please provide your email address");

    frmvalidator.addValidation("email","email","Please provide a valid email address");

    frmvalidator.addValidation("username","req","Please provide a username");
    
    frmvalidator.addValidation("password","req","Please provide a password");

// ]]>
</script>

<!--
Form Code End (see html-form-guide.com for more info.)
-->

</body>
</html>
