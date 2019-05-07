<?PHP
require_once("./include/membersite_config.php");

if(!$fgmembersite->CheckLogin())
{
  echo 'notlogged';
  exit;
}
echo 'logged';
?>
