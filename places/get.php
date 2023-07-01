<?php
header('Content-Type: application/json');
include('../models/place.php');
if (isset($_GET['id'])) {
  $id = $_GET['id'];
  echo (json_encode(getPlacesById($id)));
} else {
  echo (json_encode(getPlaces()));
}
?>