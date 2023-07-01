<?php
include_once('../config.php');

  function getUserById($id) {
  $table_name = 'user';
  $query = 'SELECT * from ' . $table_name . ' WHERE id = ' . $id;
  $result = execQuery($query);
  if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
      $user = [
        'id' => $row['id'],
        'firstName' => $row['firstName'],
        'lastName' => $row['lastName'],
        'email' => $row['email'],
      ];
    }
    $response = [
      "status" => 200,
      "data" => $user
    ];
    return $response;
  } else {
    return [];
  }
  }
