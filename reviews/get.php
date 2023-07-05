<?php
header('Content-Type: application/json');
include('../models/review.php');
$id = $_GET['id'];
echo (json_encode(getReviewByPlaceId($id)));
