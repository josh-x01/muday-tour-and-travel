import 'dart:convert';

import 'package:http/http.dart' as http;

const api = 'https://muday-tour-app.000webhostapp.com/api';

Future<Map<String, dynamic>> getPlaces() async {
  try {
    const url = '$api/places/get.php';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    return json;
  } catch(error) {
    print("Error: $error");
    return Map();
  }
}

Future<Map<String, dynamic>> getPlacesById(String id) async {
  String url = '$api/places/get.php?id=$id';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  return json;
}

Future<Map<String, dynamic>> getReviewByPlaceId(String id) async {
  String url = '$api/reviews/get.php?id=$id';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  return json;
}

Future<void> submitReviewToApi(
    String placeId, String username, String comment, double rating) async {
  final url = 'https://example.com/api/reviews'; // Replace with your API endpoint

  final requestBody = {
    'placeId': placeId,
    'username': username,
    'comment': comment,
    'rating': rating.toString(),
  };

  try {
    final response = await http.post(Uri.parse(url), body: requestBody);
    if (response.statusCode == 200) {
      // Review submitted successfully
      print('Review submitted successfully');
    } else {
      // Error occurred while submitting review
      print('Failed to submit review. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Error occurred during the API request
    print('Failed to submit review. Error: $e');
  }
}

Future<Map<String, dynamic>> getTourPlaces() async {
  print('fetching data');
  String url = '$api/category/get.php';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  return json;
}

Future<Map<String, dynamic>> getPlaceByCategory(String id) async {
  try {
    String url = '$api/category/get.php?id=$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    return json;
  } catch (error) {
    print("Error: $error");
    return Map();
  }
}
