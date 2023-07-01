<?php
header('Content-Type: application/json');
include('../models/category.php');
if (isset($_GET['id'])) {
  $id = $_GET['id'];
  echo (json_encode(getCategoriesById($id)));
} else {
  echo (json_encode(getCategories()));
}
