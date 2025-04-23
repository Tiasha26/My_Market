import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final snap;
  const ReviewCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 16,
          ),
          Expanded(child: Padding(padding: EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: snap.data()['name'],
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: '${snap.data()['text']}',
                  )
                ]
              ))
            ],
          ),
          ),
          ),
        ],
      ),
    );
  }
}