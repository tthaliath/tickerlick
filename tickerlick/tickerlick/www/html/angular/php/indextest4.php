<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitForm(obj ) {
    var l = obj
	var len = document.f.l.options.length
	if (l.value == "Search" )
	{
	   document.f.lindex.value = len
	   document.f.action = "/cgi-bin/gettickerdataone.cgi";
	   document.f.submit();
	   return true;
	 }

}
</script>
<link rel="stylesheet" href="common/ishtaar.css" type="text/css">


</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000 onLoad="locationDropPageLoad(document.f.c,document.f.l);">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>

<table align="center">
  <tr><td><img src="images/spacer.gif" width = "100%" height=10></td></tr>
  <tr>
		<tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
       <form  name=f METHOD=GET action="/cgi-bin/gettickerdataone.cgi">
      <table  align="center">

        <tr>
          <td height="23" class="bluetext">Enter Ticker</td>
        <td><img src="images/spacer.gif" width = "100%" height=10></td>
          <td ><input type="text" name="q" size="35" maxlength="255" value=""></td>
          <td><img src="images/spacer.gif" width = "5" height=11></td>
          <td><img src="images/spacer.gif" width = "5" height=11></td>
          <td><input type="submit" name="s" value="Search"> </td>
        </tr>
        <tr>
          <td><img src="images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
</form>
</tr></td></table>
<?php
echo "Hello World!";
phpinfo();
?>
<iframe align="middle" height="400" frameborder="0"></iframe>
<table align="center">
  <tr><td><img src="images/spacer.gif" width = "100%" height=10></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com/index.html">Home</a>
                <a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick</a>
                <a href="http://www.tickerlick.com/contactus.htm">Contact Us</a>
                <a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a>
                </td>
        </tr>
                
	<tr><td><img src="images/spacer.gif" width = "100%" height=10></td></tr>
        <tr></tr><td align="center"><font size=-2>&copy;2012 Tickerlick - All rights reserved.</font><p></p>
        </td>

  </tr>
   <tr><td><img src="images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
</body>
</html>

