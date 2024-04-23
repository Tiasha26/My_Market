import 'package:flutter/material.dart';

class BubbleStories extends StatelessWidget {
  const BubbleStories({super.key, /*required this.text*/});

  //final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0,15,0),
      child:  const Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('images/user.png'),
            radius: 45,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Text('text',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11
              ),
            ),
          )
        ],
      ),
    );
  }
}
