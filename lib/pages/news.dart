import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:  [
                  // TextField(
                  //   autofocus: true,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  // Icon(
                  //   Icons.search_rounded,
                  //   size: 30,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children:  [
                    Text(
                      "Heading",
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 25,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image(
                        image: NetworkImage(
                            'https://thecitc.co.za/wp-content/uploads/IMG-20230822-WA0000.jpg'),
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
