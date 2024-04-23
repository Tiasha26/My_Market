import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  const Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsDirectional.fromSTEB(0,0,4,2),
      child: Image(image: NetworkImage('https://picsum.photos/seed/868/600',),
        width: 250,
        height: 200,
        fit: BoxFit.cover,
        alignment: Alignment.topLeft,
      ),
    );
  }
}
