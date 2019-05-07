<?php

// connect
$m = new MongoClient();

// select a database
$db = $m->mydb;

// select a collection (analogous to a relational database's table)
$collection = $db->mycol_temp;

// add a record

// add another record, with a different "shape"
//$document = array( "title" => "XKCD", "online" => true );
//$collection->insert($document);

// find everything in the collection
$cursor = $collection->find();

// iterate through the results
foreach ($cursor as $document) {
    echo $document["title"] . "<br>";
    echo $document["by"] . "<br>";
}

?>
