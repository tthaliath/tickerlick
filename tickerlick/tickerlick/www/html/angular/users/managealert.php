<?PHP
require_once("./include/membersite_config.php");
$ustat = 1;
if(!$fgmembersite->CheckLogin())
{
    $ustat = 0;
    $fgmembersite->RedirectToURL("http://www.tickerlick.com/users/login.php?p=ma");
    exit;
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
      <title>Register</title>
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://tickerlick.com/common/ishtaar.css" type="text/css">
      <!--<link rel="stylesheet" type="text/css" href="style/userlogin.css">-->
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
      <link rel="STYLESHEET" type="text/css" href="style/pwdwidget.css" />
      <script src="scripts/pwdwidget.js" type="text/javascript"></script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>
  <table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
  <tr>
                <tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
   </table>
   <table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=1></td></tr>
   </table>

<!-- Form Code Start -->
<?php
// Code downloaded from html-form-guide.com
// This code may be used and distributed freely without any charge.
//
// Disclaimer
// ----------
// This file is provided "as is" with no expressed or implied warranty.
// The author accepts no liability if it causes any damage whatsoever.
//

        if(isset($_POST['formSubmit']))
    {
                $aDoor = $_POST['formDoor'];

                if(isset($_POST['formWheelchair']))
        {
                        echo("<p>You DO need wheelchair access.</p>\n");
                }
        else
        {
                        echo("<p>You do NOT need wheelchair access.</p>\n");
                }

                if(empty($aDoor))
        {
                        echo("<p>You didn't select any buildings.</p>\n");
                }
        else
        {
            $N = count($aDoor);

                        echo("<p>You selected $N door(s): ");
                        for($i=0; $i < $N; $i++)
                        {
                                echo($aDoor[$i] . " ");
                        }
                        echo("</p>");
                }

        //Checking whether a particular check box is selected
        //See the IsChecked() function below
        if(IsChecked('formDoor','A'))
        {
            echo ' A is checked. ';
        }
?>
<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com">Home</a>
                <a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick</a>
                <a href="http://www.tickerlick.com/contactus.htm">Contact Us</a>
                <a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a>
        </td>
  </tr>

  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr></tr><td align="center"><font size=-1>&copy;2012 Tickerlick - All rights reserved.</font><p></p></td></tr>
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
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
