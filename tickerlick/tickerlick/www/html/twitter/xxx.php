<?php
$screenname = $_POST["screenname"];
$keyword = $_POST["keyword"];
?>

<html>
<head>
<title>Twitter Crawler Demo</title>
<script>
$(document).ready(function(){
  $("#tweet").click(function(event){
  event.preventDefault(); 
  $.post($(this).attr('action'), $(this).serialize()); // handle the post via ajax
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
  <form method="post" id="tweet" action="tweets.php">
  Twitter Profile Id (for example @elonmusk): <input type="text" name="screenname">
  <br/>Key Word in tweet text: <input type="text" name="keyword">
  <br/><input type="submit" value="submit" name="submit" id="submit">
  </form>
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
