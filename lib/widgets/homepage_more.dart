import 'package:flutter/material.dart';

class MoreHP extends StatelessWidget {
  const MoreHP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(7),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: 83,
          width: 152,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Icon(Icons.forum, color: Colors.black, size: 20,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Message", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    decoration: TextDecoration.none
                  ),
                  textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Icon(Icons.share,
                  size: 20,
                  color: Colors.black,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Share", style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      decoration: TextDecoration.none
                  ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Icon(Icons.visibility_off_outlined,
                    size: 20,
                    color: Colors.black,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Hide Content", style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      decoration: TextDecoration.none
                  ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
