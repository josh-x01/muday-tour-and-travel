<?php
include_once('../config.php');
include_once('review.php');
$table_name = 'place';

function getPlaces() {
  global $table_name;
  $query = 'SELECT * from ' . $table_name;
  $result = execQuery($query);

  if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
      $place = [
        'id' => $row['id'],
        'name' => $row['name'],
        'description' => $row['description'],
        'coordinates' => $row['coordinates'],
        'imageUrl' => $row['imageUrl'],
      ];
      array_push($data, $place);
    }
    $response = [
      'status' => 200,
      'data' => $data];
    return $response;
  } else {
    $response = array(
      'status' => '400',
      'error' => 'No data found'
    );
    return $response;
  }
}

function getPlacesById($id) {
  global $table_name;
  $query = 'SELECT * from ' . $table_name . ' WHERE id = ' . $id;
  $result = execQuery($query);
  if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
      $place = [
        'id' => $row['id'],
        'name' => $row['name'],
        'description' => $row['description'],
        'coordinates' => $row['coordinates'],
        'imageUrl' => $row['imageUrl'],
        'review_info' => getReviewByPlaceId($id)['data']
      ];
    }
    $response = [
      'status' => 200,
      'data' => $place
    ];
    return $response;
  } else {
    $response = array(
      'status' => '400',
      'error' => 'No data found'
    );
    return $response;
  }
}

function getPlacesByCategoryId($categoryId)
{
  global $table_name;
  $query = 'SELECT * from ' . $table_name . ' WHERE categoryId = ' . $categoryId;
  $result = execQuery($query);
  if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
      $place = [
        'id' => $row['id'],
        'name' => $row['name'],
        'description' => $row['description'],
        'coordinates' => $row['coordinates'],
        'imageUrl' => $row['imageUrl'],
      ];
      array_push($data, $place);
    }
    $response = [
      'status' => 200,
      'data' => $data
    ];
    return $response;
  } else {
    $response = array(
      'status' => '400',
      'error' => 'No data found'
    );
    return $response;
  }
}


function addPlace($name, $desc, $coord, $imageUrl) {
  global $conn;
  global $table_name;
  $sql = 'INSERT INTO ' . $table_name . ' (name, description, coordinates, imageUrl) value(?,?,?,?)';
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('ssss', $name, $desc, $coord, $imageUrl);
  $stmt->execute();
  $response = [
    "status" => 200,
    "message" => "Added successfully"
  ];
  return $response;
}

function updatePlace($name, $desc, $coord, $imageUrl, $id)
{
  global $conn;
  global $table_name;
  $sql = 'UPDATE ' . $table_name . ' SET name = ?, description = ?, coordinates = ?, imageUrl = ? WHERE id = ?';
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('ssssi', $name, $desc, $coord, $imageUrl, $id);
  $stmt->execute();
  $response = [
    "status" => 200,
    "message" => "Updated successfully"
  ];
  return $response;
}

function deletePlace($id)
{
  global $conn;
  global $table_name;
  $sql = 'DELETE FROM ' . $table_name . ' WHERE id = ?';
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('i', $id);
  $stmt->execute();
  $response = [
    "status" => 200,
    "message" => "Deleted successfully"
  ];
  return $response;
}
?>
