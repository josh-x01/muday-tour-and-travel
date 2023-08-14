// ignore_for_file: public_member_api_docs, sort_constructors_first
class TouristDetailsPageModel {
  final String image;
  final String name;
  final String description;
  final String price;
  final String location;
  final String coordinates;

  TouristDetailsPageModel({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.coordinates,
  });
}

List<TouristDetailsPageModel> touristDetails = [];

void addDataToTouristDetails(List<Map<String, dynamic>> data) {
  for (var item in data) {
    touristDetails.add(TouristDetailsPageModel(
      image: item["image"],
      name: item["name"],
      description: item["description"],
      price: item["price"],
      location: item["location"],
      coordinates: item["coordinates"],
    ));
  }
}
