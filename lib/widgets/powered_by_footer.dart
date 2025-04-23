import 'package:flutter/material.dart';

class PoweredByFooter extends StatelessWidget {
  const PoweredByFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Powered by Zenithkode Creations',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'NotoSans',
        ),
      ),
    );
  }
} 