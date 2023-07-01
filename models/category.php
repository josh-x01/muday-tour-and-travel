<?php
include_once('../config.php');
include_once('place.php');

function getCategories() {
  $table_name = 'category';
  $query = 'SELECT * from ' . $table_name;
  $result = execQuery($query);
  if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
      $category = [
        'id' => $row['id'],
        'name' => $row['name'],
      ];
      array_push($data, $category);
    }
    $response = [
      "status" => 200,
      "data" => $data
    ];
    return $response;
  } else {
    return [];
  }
}

function getCategoriesById($id) {
  $table_name = 'category';
  $query = 'SELECT * from ' . $table_name . ' WHERE id = ' . $id;
  $result = execQuery($query);
  if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
      $category = [
        'id' => $row['id'],
        'name' => $row['name'],
        'places' => getPlacesByCategoryId($id)['data']
      ];
    }
    $response = [
      "status" => 200,
      "data" => $category
    ];
    return $response;
  } else {
    return [];
  }
}

?>
