<?php

// connect
$m = new MongoClient();

// select a database
$db = $m->analmaster;

// select a collection (analogous to a relational database's table)
$collection = $db->ratings;


// add another record, with a different "shape"
//$document = array( "title" => "XKCD", "online" => true );
//$collection->insert($document);
//$ticker = $_GET['q'];
// find everything in the collection
//$cursor = $collection->find(['ticker' => 'SNAP'],[_id => 0])->sort([ratingdate => -1])->limit(10);
$cursor = $collection->find(['ticker' => 'SNAP']);
// iterate through the results
foreach ($cursor as $document) {
    echo $document["ticker"] . "<br>";
    echo $document["brokeragename"] . "<br>";
    echo $document["ratingdate"] . "<br>";
}

?>
