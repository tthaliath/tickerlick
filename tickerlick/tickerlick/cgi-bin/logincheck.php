<?PHP
require_once("/home/tickerlick/www/html/users/include/membersite_config.php");
$ustat = 1;
if(!$fgmembersite->CheckLogin())
{
   $ustat = 0;
}
echo   $ustat;
?>
