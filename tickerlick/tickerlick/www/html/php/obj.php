<?php
class User {
public $name;
public $birthday;
public function __construct($name, $birthday)
{
$this->name = $name;
$this->birthday = $birthday;
}
public function hello()
{
return "Hello $this->name!\n";
}
public function goodbye()
{
return "Goodbye $this->name!\n";
}
public function age() {
$ts = date_default_timezone_set($this->birthday);
if($ts === -1) {
return "Unknown";
}
else {
$diff = time() - $ts;
return floor($diff/(24*60*60*365)) ;
}
}
}
$user = new User("george", "feb 5 1965");
echo $user->hello();
echo "You are ".$user->age()." years old.\n";
echo $user->goodbye();
?>
