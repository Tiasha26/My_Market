import 'package:flutter/material.dart';
import 'package:my_market/util/bubble_story.dart';
import 'package:my_market/util/posts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 /* final List people = [
    'keith_tattoo',
    'Business_name',
    'trend_wagon',
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.transparent,
        ),
        title: const Text(
          'My Market',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: SingleChildScrollView(
        child: const Column(
          children:  <Widget>[

            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 2),
              child:
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BubbleStories(),
                    BubbleStories(),
                    BubbleStories(),
                    BubbleStories(),
                    BubbleStories(),
                    BubbleStories(),
                  ],
                ),
              ),
              /*ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: people.length,
                  itemBuilder: (context, index){
                    return BubbleStories(text: people[index]);
                  }),*/
            ),

           Posts(),
            Posts(),
            Posts(),Posts(),

           /* ListView.builder(
              itemCount: people.length,
                itemBuilder: (context, index){
                  return Posts(name: people[index],);
                }),*/

          ],
        ),
      ),
    );
  }
}
