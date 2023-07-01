<?php
header('Content-Type: application/json');
include('../models/place.php');
$id = $_GET['id'];
echo(json_encode(deletePlace($id)));
?>