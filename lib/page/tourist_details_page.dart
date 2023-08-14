import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project/api.dart';
import 'package:project/widgets/distance.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/tourist_detail_model.dart';
import 'package:project/widgets/review.dart';
import 'package:project/widgets/review_widget.dart';
import 'package:project/widgets/review_form.dart';


class TouristDetailsPage extends StatelessWidget {
  final String id;

  const TouristDetailsPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<TouristDetailsPageModel> getTouristDetails() async {
    final data = await getPlacesById(id);
    final touristDetails = TouristDetailsPageModel(
      image: data["data"]["imageUrl"],
      name: data["data"]["name"],
      description: data["data"]["description"],
      price: data["data"]["price"],
      location: data["data"]["location"],
      coordinates: data["data"]["coordinates"],
    );
    return touristDetails;
  }

  Future<List<dynamic>> getReview() async {
    final data = await getReviewByPlaceId(id);
    if (data["status"] != 200) {
      return [];
    }
    return data["data"]["reviews"];
  }

  Widget getLocation(BuildContext context, String coordinates) {
    String lat = coordinates.split(" ")[0];
    String log = coordinates.split(" ")[1];
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(lat), double.parse(log)),
      zoom: 14.4746,
    );

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<TouristDetailsPageModel>(
      future: getTouristDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          final touristDetails = snapshot.data!;
          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  SizedBox(
                    height: size.height * 0.38,
                    width: double.maxFinite,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                            image: DecorationImage(
                              image: AssetImage(touristDetails.image),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 0,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  iconSize: 20,
                                  icon: const Icon(Ionicons.chevron_back),
                                ),
                                IconButton(
                                  iconSize: 20,
                                  onPressed: () {},
                                  icon: const Icon(Ionicons.heart_outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            touristDetails.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "ETB ${touristDetails.price}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.orange,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width:
                                size.width - 120, // Adjust the width as needed
                            child: Flexible(
                              child: Text(
                                touristDetails.description,
                                style: Theme.of(context).textTheme.labelLarge,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ReviewAverage(id: id),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Check the map",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  getLocation(context, touristDetails.coordinates),
                  const SizedBox(height: 15),
                  const SizedBox(height: 20),
                  // Render reviews
                  FutureBuilder<List<dynamic>>(
                    future: getReview(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final reviews = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              'Reviews',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final reviewData = reviews[index];
                                return Review(
                                  username: "${reviewData['user']["firstName"] + " " + reviewData['user']["lastName"]}",
                                  comment: reviewData['comment'],
                                  rating: reviewData['rating'],
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return Text('Failed to load reviews.');
                    },
                  ),

                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text('Failed to load tourist details.'),
          ),
        );
      },
    );
  }
}
