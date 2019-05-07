<?php
class Car
{
  var $color;
  function Car($color="green") 
  {
    $this->color = $color;
  }
  function what_color() 
  {
    return $this->color;
  }
}
?> 


