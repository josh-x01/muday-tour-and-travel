// ignore_for_file: public_member_api_docs, sort_constructors_first
class RecommendedPlaceModel {
  final String image;
  final double rating;
  final String location;

  RecommendedPlaceModel({
    required this.image,
    required this.rating,
    required this.location,
  });
}

List<RecommendedPlaceModel> recommendedPlaces = [];

void addDataToRecommendedPlaces(List<Map<String, dynamic>> data) {
  for (var item in data) {
    recommendedPlaces.add(RecommendedPlaceModel(
      image: item['image'],
      rating: double.parse(item['rating']),
      location: item['location'],
    ));
  }
}
