<?PHP
require_once("./include/membersite_config.php");

$emailsent = false;
if(isset($_POST['submitted']))
{
   if($fgmembersite->EmailResetPasswordLink())
   {
        $fgmembersite->RedirectToURL("reset-pwd-link-sent.html");
        exit;
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
      <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
      <title>Reset Password Request</title>
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://tickerlick.com/common/ishtaar.css" type="text/css">
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
<title>Tickerlick - Reset Password</title>
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
<div id='fg_membersite' align="center">
<form id='resetreq' action='<?php echo $fgmembersite->GetSelfScript(); ?>' method='post' accept-charset='UTF-8'>
<fieldset >
<legend>Reset Password</legend>

<input type='hidden' name='submitted' id='submitted' value='1'/>

<div class='short_explanation'>* Required fields</div>

<div><span class='error'><?php echo $fgmembersite->GetErrorMessage(); ?></span></div>
<div class='container'>
    <label for='username' >Your Email*:</label><br/>
    <input type='text' name='email' id='email' value='<?php echo $fgmembersite->SafeDisplay('email') ?>' maxlength="50" /><br/>
    <span id='resetreq_email_errorloc' class='error'></span>
</div>
<div class='short_explanation'>A link to reset your password will be sent to the email address</div>
<div class='container'>
    <input type='submit' name='Submit' value='Submit' />
</div>
</fieldset>
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

    var frmvalidator  = new Validator("resetreq");
    frmvalidator.EnableOnPageErrorDisplay();
    frmvalidator.EnableMsgsTogether();

    frmvalidator.addValidation("email","req","Please provide the email address used to sign-up");
    frmvalidator.addValidation("email","email","Please provide the email address used to sign-up");

// ]]>
</script>

</div>
<!--
Form Code End (see html-form-guide.com for more info.)
-->

</body>
</html>
