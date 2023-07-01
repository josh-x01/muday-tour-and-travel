<?php
header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
  header('HTTP/1.1 405 Method Not Allowed');
  echo (json_encode(["status" => 405, "error" => "Method not allowed"]));
  exit;
}

include('../models/place.php');
$jsonData = file_get_contents('php://input');
$data = json_decode($jsonData, true);
$name = $data['name'];
$desc = $data['description'];
$coord = $data['coordinates'];
$imageUrl = $data['imageUrl'];
$id = $data['id'];
echo(json_encode(updatePlace($name, $desc, $coord, $imageUrl, $id)));
?>