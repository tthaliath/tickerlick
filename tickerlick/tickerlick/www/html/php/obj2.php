<?php

class test
{
public $name;
public $age;
 
public function __construct($name,$age)
{
     $this->name = $name;
     $this->age = $age;
}
public function getname()
{
return $this->name;
}
}
$var = new test ('tom',49);
echo $var->name;
echo $var->age;
echo  $var->getname();
?>
