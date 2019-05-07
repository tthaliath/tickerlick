<?PHP
require_once("./include/membersite_config.php");
$ustat = 1;
if(!$fgmembersite->CheckLogin())
{
    $ustat = 0; 
    $fgmembersite->RedirectToURL("http://www.tickerlick.com/users/login.php");
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<title>TICKERLICK - Real time buy and sell signals based on technical indicators</title> 
<meta name="keywords" lang="en-US" content="MACD, Stochastic, Bollinger, RSI, Oversold, Overbought, Stock Research, Investment Tools,Thomas Thaliath"/>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
	   document.f.action = "/cgi-bin/gettickermain2.cgi";
	   document.f.submit();
	   return true;

}
</script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">

  <script src="//code.jquery.com/jquery-1.10.2.js"></script>

  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

<script>

  $(function() {

    var cache = {};

    $( "#symbols" ).autocomplete({

      minLength: 2,

      source: function( request, response ) {

        var term = request.term;

        if ( term in cache ) {

          response( cache[ term ] );

          return;

        }

        $.getJSON( "searchsymbol.php", request, function( data, status, xhr ) {

          cache[ term ] = data;
          response( data );

        });

      },


    });

  });

  </script>
<link rel="stylesheet" href="http://tickerlick.com/common/ishtaar.css" type="text/css">
<link rel="stylesheet" href="http://tickerlick.com/common/tickerlick2.css" type="text/css">
<script>
$(document).ready(function(){
  $("button").click(function(){
    $.get("php2/report.php",
    {
      r:$(this).attr("value"),
    },
    function(data){
    $("#div1").html(data)
    });
  });
});
</script>
</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>
 <table align="center" cellspacing="0" cellspadding="0" width="70%" ><tr><td></td><tr><td></td><tr><td></td></tr>
 <tr  align="right"><td>
 <ul>
 <li><a href="http://www.tickerlick.com">Home</a></li>
 <li><a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick</a></li>
 <li>My Account<span class="arrow">&#9660;</span>
   <ul>
     <li><a href="http://www.tickerlick.com/users/indexphp2.html">Profile</a></li>
     <li><a href="http://www.tickerlick.com">Manage Trade Signal Alerts</a></li>
   </ul>
 </li>
 <li><a href="http://www.tickerlick.com/contactus.htm">Contact Us</a></li>
 <li><a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a></li>
</ul>
</td></tr>
<tr><td>
<p style="text-align:center"><b><font class="bluetextheader">Live, Real-time buy/sell signals based on technical analysis indicators.<br />Signal data of over 8000 stocks, funds and ETF's are available.<br />Historical signal data for backtesting trading strategies.</font></b></P>
</TD></TR>
                                <TR vAlign=top>
                                <TD colSpan=3><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5>
								</TD></TR></TABLE>
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

       <form  name=f METHOD=GET action="/cgi-bin/gettickermain2.cgi">

      <table  align="center">

        <tr>
          <td height="23" class="bluetext">
          <div class="ui-widget">

             <label for="symbols">Symbol: </label>

             <input id="symbols" name="q">
            </div></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><button onclick="submitform(f)">Search</button></td>
        </tr>
        <tr>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
</a>
</form>
</tr></td></table>
<?php if ($ustat) { ?>
<table align="center">
<tr>
        <td> <button style="font-weight:bold;color:green" value="xos" >Oversold</button></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button style="font-weight:bold;color:red" value="xob" >Overbought</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

</tr>
<tr>
        <td>
               <button value="mbux" >S&P 500 - MACD Bullish Crossover</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td> <button value="osx" >S&P 500 - MACD Oversold (Bullish)</button></td>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
   <tr>
        <td>
                <button value="rsx">S&P 500 - RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>   <button value="ssx">S&P 500 - Stochastic Oversold (Bullish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>
  </tr>
   <tr>
        <td>
                <button value="bbux" >S&P 500 - Bollinger Oversold (Bullish)</button>
        </td>
         <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>   <button value="ssrx">S&P 500 - Stochastic RSI Oversold (Bullish)</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>
  </tr>
     <td>
         <tr>
            <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>
     </td>
  </tr>
<tr>
        <td>
               <button value="mbu" >MACD Bullish Crossover</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="mbe" >MACD Bearish Crossover</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

</tr>
<tr>
        <td> <button value="os" >MACD Oversold (Bullish)</button></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="ob" >MACD Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
  <tr>
        <td> <button value="bbu" >Bollinger Oversold (Bullish)</button></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="bbe" >Bollinger Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
  <tr>
        <td>
                <button value="rs" >RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="rb" >RSI Overbought (Bearish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
   <tr>
        <td>
                <button value="ss" >Stochastic Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sb" >Stochastic Overbought (Bearish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
   <tr>
        <td>
                <button value="ssr" >Stochastic RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sbr" >Stochastic RSI Overbought (Bearish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
  </table>
<?php } ?>
<div id="div1"></div>
<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com">Home</a>
                </td>
        </tr>
                
	<tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
        <tr></tr><td align="center"><font size=-1>&copy;2012 Tickerlick - All rights reserved.</font><p></p>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
</body>
</html>

