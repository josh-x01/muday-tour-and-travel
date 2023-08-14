import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project/api.dart';
import 'package:project/widgets/distance.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/tourist_detail_model.dart';

Widget buildReviewAverage(AsyncSnapshot<String> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
  if (snapshot.hasData) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.yellow[800]),
        SizedBox(width: 5),
      Text(
      "${snapshot.data!}/5",
      style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
  if (snapshot.hasError) {
    return Text(
      'Error: ${snapshot.error}',
      style: TextStyle(fontSize: 16),
    );
  }
  return SizedBox();
}

class ReviewAverage extends StatelessWidget {
  final String id;

  const ReviewAverage({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<String> getReview() async {
    final data = await getReviewByPlaceId(id);
    if (data["status"] != 200) {
      return "0";
    }
    return data["data"]["average"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getReview(),
      builder: (context, snapshot) {
        return buildReviewAverage(snapshot);
      },
    );
  }
}
