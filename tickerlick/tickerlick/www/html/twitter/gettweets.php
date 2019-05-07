<html>
<head>
<title>Twitter Crawler Demo</title>
<script>
$(document).ready(function(){
  $("#tweeter").click(function(event){
    event.preventDefault(); 
    $.post("tweets1.php",
    {
      echo $(this).attr("value"),
      r:$(this).attr("value"),
    },
    function(data){
    echo data
    $("#div1").html(data)
    $('html, body').animate({
           scrollTop: $("#div1").offset().top
           }, 20);
    });
  });
});
</script>
</head>

<body>

<?php
if (!isset($_POST['submit']))
{
  ?>
  <p>
  <div id="tweeter">
  <form method="post" action="">
  Twitter Profile Id (for example @elonmusk): <input type="text" name="screenname">
  <br/>Key Word in tweet text: <input type="text" name="keyword">
  <br/><input type="submit" value="submit" name="submit" id="submit">
  </form>
  </div>
  </p>

<?php
}
else
{
  echo "<p>";
  echo "Twitter Profile Id: $screenname<br />";
  echo "Key Word : $keyword<br />";
  echo "</p>";
}
?>
<div id="div1"></div>
</body>
</html>
