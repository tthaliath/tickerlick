<?PHP
require_once("./include/membersite_config.php");

if(!$fgmembersite->CheckLogin())
{
    $fgmembersite->RedirectToURL("http://www.luckyticker.com/users/login.php");
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
      <link rel="STYLESHEET" type="text/css" href="style/fg_membersite.css" />
      <link rel="stylesheet" href="http://luckyticker.com/common/ishtaar.css" type="text/css">
      <!--<link rel="stylesheet" type="text/css" href="style/userlogin.css">-->
      <link rel="stylesheet" href="http://luckyticker.com/common/ishtaar.css" type="text/css">
      <link rel="stylesheet" href="http://luckyticker.com/common/link.css" type="text/css">
      <script type='text/javascript' src='scripts/gen_validatorv31.js'></script>
      <title>Tickerlick Home</title>
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
<div id='fg_membersite_content' align="center">
Welcome back <b><?PHP echo $fgmembersite->UserFullName(); ?></b>
<h3><a href="http://www.luckyticker.com">Home</a></h3>
<p><a href='http://www.luckyticker.com/users/change-pwd.php'>Change password</a></p>
<br>
</div>
<table align="center">
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=100></td></tr>
  <tr></tr><td align="center"><font size=-1>&copy;2012 LuckyTicker - All rights reserved.</font><p></p></td></tr>
  <tr><td><img src="http://luckyticker.com/images/spacer.gif" width = "100%" height=10></td></tr>
</table>
</body>
</html>
