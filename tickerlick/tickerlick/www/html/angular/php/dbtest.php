?php
require_once("DB.php");

function get_user_id( $name )
{
  $dsn = 'mysql://root:password@localhost/users';
  $db =& DB::Connect( $dsn, array() );
  if (PEAR::isError($db)) { die($db->getMessage()); }

  $res = $db->query( 'SELECT id FROM users WHERE login=?',
  array( $name ) );
  $id = null;
  while( $res->fetchInto( $row ) ) { $id = $row[0]; }

  return $id;
}

var_dump( get_user_id( 'jack' ) );
?>
