<?php
$dbHost = "localhost";
$dbUsername = "root";
$dbPassword = "";
$dbName = "tour";
$conn = new mysqli($dbHost, $dbUsername, $dbPassword, $dbName);
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
function execQuery($query) {
  global $conn;
  return $conn->query($query);
}