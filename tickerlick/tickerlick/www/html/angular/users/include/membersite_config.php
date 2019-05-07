<?PHP
require_once("/home/tickerlick/www/html/users/include/fg_membersite.php");

$fgmembersite = new FGMembersite();

//Provide your site name here
$fgmembersite->SetWebsiteName('tickerlick.com');

//Provide the email address where you want to get notifications
$fgmembersite->SetAdminEmail('info@tickerlick.com');

//Provide your database login details here:
//hostname, user name, password, database name and table name
//note that the script will create the table (for example, fgusers in this case)
//by itself on submitting register.php for the first time
$fgmembersite->InitDB(/*hostname*/'localhost',
                      /*username*/'root',
                      /*password*/'Neha*2005',
                      /*database name*/'tickmaster',
                      /*table name*/'usermaster');

//For better security. Get a random string from this link: http://tinyurl.com/randstr
// and put it here
$fgmembersite->SetRandomKey('qSRcVS6DrTzrPvr');

?>
