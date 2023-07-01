<?php
header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
  header('HTTP/1.1 405 Method Not Allowed');
  echo (json_encode(["status" => 405, "error" => "Method not allowed"]));
  exit;
}

include('../models/review.php');
$jsonData = file_get_contents('php://input');
$data = json_decode($jsonData, true);
$rating = $data['rating'];
$comment = $data['comment'];
$placeId = $data['placeId'];
$userId = $data['userId'];
echo(json_encode(reviewPlaceById($rating, $comment, $placeId, $userId)));
?>