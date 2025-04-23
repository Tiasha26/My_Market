import 'package:flutter/material.dart';
import 'package:my_market/widgets/cached_image.dart';

class Images extends StatelessWidget {
  const Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 2),
      child: CachedImage(
        imageUrl: 'https://picsum.photos/seed/868/600',
        width: 250,
        height: 200,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
