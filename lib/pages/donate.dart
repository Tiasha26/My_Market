import 'package:flutter/material.dart';

class Donate extends StatelessWidget {
  const Donate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.transparent
        ),
        title: const Text(
          'Donate',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: SingleChildScrollView(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text('Help someone make their dreams come true!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,

                    ),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
