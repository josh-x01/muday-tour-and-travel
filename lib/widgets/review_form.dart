import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project/api.dart';

class ReviewForm extends StatefulWidget {
  final String placeId;

  const ReviewForm({Key? key, required this.placeId}) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  void submitReview() {
    final String username = _usernameController.text.trim();
    final String comment = _commentController.text.trim();

    if (username.isNotEmpty && comment.isNotEmpty && _rating > 0.0) {
      // Submit the review to the API
      submitReviewToApi(widget.placeId, username, comment, _rating);

      // Clear the input fields
      _usernameController.clear();
      _commentController.clear();
      setState(() {
        _rating = 0.0;
      });

      // Show a confirmation dialog or perform any desired actions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Review Submitted'),
            content: Text('Thank you for your review!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error dialog if any field is empty or rating is not selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Review'),
            content: Text('Please fill in all the fields and select a rating.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Comment',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Rating:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            for (int i = 1; i <= 5; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = i.toDouble();
                  });
                },
                child: Icon(
                  Ionicons.star,
                  size: 30,
                  color: _rating >= i ? Colors.amber : Colors.grey,
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: submitReview,
          child: Text('Submit Review'),
        ),
      ],
    );
  }
}
