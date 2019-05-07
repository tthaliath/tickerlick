<?PHP
require_once("./include/membersite_config.php");
$ustat = 1;
$reports = array();
if(!$fgmembersite->CheckLogin())
{
    $ustat = 0;
    $fgmembersite->RedirectToURL("http://www.tickerlick.com/users/login.php?p=ma");
    exit;
}
else
{
 $reports = $fgmembersite->getUserAlert();
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
       <title>Manage Alerts</title>
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://tickerlick.com/common/ishtaar.css" type="text/css">
      <!--<link rel="stylesheet" type="text/css" href="style/userlogin.css">-->
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
      <link rel="STYLESHEET" type="text/css" href="style/pwdwidget.css" />
      <link rel="STYLESHEET" type="text/css" href="http://tickerlick.com/users/style/checkbox.css" />
      <script src="scripts/pwdwidget.js" type="text/javascript"></script>
</head>
<body>
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
        //Checking whether a particular check box is selected
        //See the IsChecked() function below
        if(IsChecked('formAlert','OSD'))
        {
            $fgmembersite->UpdateDBAlertConfirmation('OSD','Y');
        }
        else
        {
           $fgmembersite->UpdateDBAlertConfirmation('OSD','N');
        }        
         if(IsChecked('formAlert','OBD'))
        {
            $fgmembersite->UpdateDBAlertConfirmation('OBD','Y');
        }
        else
        {
            $fgmembersite->UpdateDBAlertConfirmation('OBD','N');
        }
         if(IsChecked('formAlert','INT'))
        {
            $fgmembersite->UpdateDBAlertConfirmation('INT','Y');
        }
        else
        {
            $fgmembersite->UpdateDBAlertConfirmation('INT','N');
        }
        }
        $reports = $fgmembersite->getUserAlert();
    function IsChecked($chkname,$value)
    {
        if(!empty($_POST[$chkname]))
        {
            foreach($_POST[$chkname] as $chkval)
            {
                if($chkval == $value)
                {
                    return true;
                }
            }
        }
        return false;
    }
?>
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
<form action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>" method="post">
	        <div class='short_explanation'>Please check the reports you would like to subscribe</div><br/>
		<div class='smallcontainer'><input type="checkbox" name="formAlert[]" value="OSD" <?php echo ($reports[0]); ?>/>Oversold - Daily at 10 PM PST</div><br />
	       <div class='smallcontainer'><input type="checkbox" name="formAlert[]" value="OBD" <?php echo ($reports[1]); ?> />Overbought - Daily at 10 PM PST</div><br />
	       <div class='smallcontainer'><input type="checkbox" name="formAlert[]" value="INT" <?php echo ($reports[2]); ?> />Intraday - Every 5 minutes during trading session</div><br />
	        <div class='short_explanation'><input type="submit" name="formSubmit" value="Submit" /></div>
</form>
</div>
<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com/users">Home</a>
                <a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick</a>
                <a href="http://www.tickerlick.com/contactus.htm">Contact Us</a>
                <a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a>
        </td>
  </tr>

  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=50></td></tr>
  <tr></tr><td align="center"><font size=-1>&copy;2012 Tickerlick - All rights reserved.</font><p></p></td></tr>
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
</table>
</td></tr></table>
</body>
</html>
