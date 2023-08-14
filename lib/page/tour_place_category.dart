import 'package:flutter/material.dart';
import 'package:project/widgets/distance.dart';
import 'package:project/widgets/review.dart';

import '../page/tourist_details_page.dart';
import '../api.dart';
import '../tourist_place_model.dart';

class PlaceByCategory extends StatelessWidget {
  final String id;
  const PlaceByCategory({Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getPlaceByCategory(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Show an error message if data fetching fails
          return Text('Error: ${snapshot.error}');
        } else {
          // Data fetching is successful, build the widget with the fetched data
          final data = snapshot.data!;
          // if (data == []) {

          // }
          final places = data["data"]["places"];


          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text("From Category")),
            ),
            body: SafeArea(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];

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
                                  id: place['id'],
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
                                    place['imageUrl'],
                                    height: double.maxFinite,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // DISTANCE WIDGET
                                      Distance(
                                        location: place['location'],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          ReviewAverage(id: place['id']),
                                          const Spacer(),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              text: "ETB ${place['price']}",
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
                },
              ),
            ),
          );
        }
      },
    );
  }
}
