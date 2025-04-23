import 'package:flutter/material.dart';
import 'package:my_market/widgets/cached_image.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Picture',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton//IconButton
        ], //<Widget>[]
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Menu Icon',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: NetworkImage('https://picsum.photos/seed/509/600'),
              width: double.infinity,
              height: 304,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: 56,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Gallery',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.add_box_rounded,
                      color: Colors.white,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: GridView.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 1,
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                children: const [
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                  CachedImage(
                    imageUrl: 'https://picsum.photos/seed/825/600',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
