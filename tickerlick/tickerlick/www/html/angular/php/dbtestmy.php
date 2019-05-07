<?php

function get_cn( $id )
{
  $dsn = 'mysql://root:Neha*2005@localhost/tickmaster';
  $db =& DB::Connect( $dsn, array() );
  if (PEAR::isError($db)) { die($db->getMessage()); }

  $res = $db->query( 'SELECT count(*) FROM tickerprice WHERE ticker_id=?',
  array( $id ) );
  $cn = null;
  while( $res->fetchInto( $row ) ) { $cn = $row[0]; }

  return $cn;
}

var_dump( get_cn( 33 ) );
?>
