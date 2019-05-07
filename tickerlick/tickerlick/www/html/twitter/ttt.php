<?php
$screenname = $_POST["screenname"];
$keyword = $_POST["keyword"];
?>

<html>
<head>
<title>Twitter Crawler Demo</title>
<script>
$(document).ready(function() {
  $("#contactForm").submit(function(event) {
    event.preventDefault();
    // do the extra stuff here
    $.ajax({
     type: "GET",
      url: "tweets1.php?u=@elonmusk&k=linux",
      data: $(this).serialize(),
      success: function() {
          echo <p>data</p>

       }
    })

  })
})
</script>
</head>

<body>

<?php
if (!isset($_POST['submit']))
{
  ?>
  <p>
  <form method="post" id="contactForm" action="">
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
