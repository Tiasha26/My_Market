import 'package:flutter/material.dart';

class CustDetail extends StatelessWidget {
  const CustDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
      child: Container(
        width: double.infinity,
        height: 72,
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
        child: const Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/user.png'),
                radius: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer Name', style: TextStyle(
                    fontSize: 12
                  ),),
                  Text('Customer ID', style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFa3a5b2)
                  ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
