// ignore_for_file: public_member_api_docs, sort_constructors_first
class NearbyPlaceModel {
  final String image;
  final String name;
  final String description;
  final String price;
  final String location;
  final String coordinates;
  final String id;
  NearbyPlaceModel({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.coordinates,
    required this.id,
    });
}

List<NearbyPlaceModel> nearbyPlaces = [];

void addDataToNearPlaces(List<dynamic> data) {
  for (var item in data) {
    nearbyPlaces.add(
      NearbyPlaceModel(
        id: item["id"],
        image: item['imageUrl'],
        name: item['name'],
        description: item['description'],
        price: item['price'],
        location: item['location'],
        coordinates: item['coordinates'],
      ),
    );
  }
}
