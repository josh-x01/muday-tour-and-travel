import 'package:flutter/material.dart';
import 'package:project/tourist_place_model.dart';
import 'package:project/page/tour_place_category.dart';


class TouristPlaces extends StatelessWidget {
  const TouristPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTourPlaces(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            height: 40,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final place = touristPlaces[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceByCategory(id: place.id),
                      ),
                    );
                  },
                  child: Chip(
                    label: Text(place.name),
                    avatar: CircleAvatar(
                      backgroundImage: AssetImage(place.image),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const Padding(padding: EdgeInsets.only(right: 10)),
              itemCount: touristPlaces.length,
            ),
          );
        }
      },
    );
  }
}
