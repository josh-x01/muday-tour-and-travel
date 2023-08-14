import 'package:flutter/material.dart';
import 'package:project/nearby_places_model.dart';
import 'package:project/widgets/distance.dart';
import 'package:project/widgets/review.dart';

import '../page/tourist_details_page.dart';
import '../api.dart';

class NearbyPlaces extends StatelessWidget {
  const NearbyPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return const AlertDialog(
            title: Text('Please wait'),
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Show an error message if data fetching fails
          return Text('Error: ${snapshot.error}');
        } else {
          // Data fetching is successful, build the widget with the fetched data
          final data = snapshot.data!;
          addDataToNearPlaces(data['data']);

          return Column(
            children: List.generate(nearbyPlaces.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 135,
                  width: double.maxFinite,
                  child: Card(
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TouristDetailsPage(
                              id: nearbyPlaces[index].id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                nearbyPlaces[index].image,
                                height: double.maxFinite,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nearbyPlaces[index].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // DISTANCE WIDGET
                                  Distance(
                                    location: nearbyPlaces[index].location,
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      ReviewAverage(id: nearbyPlaces[index].id),
                                      const Spacer(),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          text:
                                              "ETB ${nearbyPlaces[index].price}",
                                          children: const [
                                            TextSpan(
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                              text: "/ Person",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
