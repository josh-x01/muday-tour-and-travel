import 'dart:core';

import 'package:flutter/material.dart';

import 'api.dart';

class TouristPlacesModel {
  final String id;
  final String name;
  final String image;

  TouristPlacesModel({
    required this.id,
    required this.name,
    required this.image,
  });
}

List<TouristPlacesModel> touristPlaces = [];

Future<void> fetchTourPlaces() async {
  final Map<String, dynamic> json = await getTourPlaces();

  // Assuming the API response contains a list of places
  final List<dynamic> placesJson = json['data'];

  // Map the API response to TouristPlacesModel objects
  final List<TouristPlacesModel> places = placesJson.map((placeJson) {
    return TouristPlacesModel(
      id: placeJson['id'],
      name: placeJson['name'],
      image: placeJson['image'],
    );
  }).toList();

  touristPlaces = places;
}
