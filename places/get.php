<?php
header('Content-Type: application/json');
include('../models/place.php');
if (isset($_GET['id'])) {
  $id = $_GET['id'];
  echo (json_encode(getPlacesById($id)));
} elseif(isset($_GET['recommended'])) {
  
} 
else {
  echo (json_encode(getPlaces()));
}
?>