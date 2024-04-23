import 'package:flutter/material.dart';

class CustInfo extends StatelessWidget {
  const CustInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
      child: Container(
        width: double.infinity,
        height: 319,
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Padding(
               padding: EdgeInsets.only(top: 10,bottom: 10),
               child: Row(
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
                        Text('Customer ID',style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFa3a5b2)
                        ),),
                      ],
                    ),
                  )
                ],
            ),
             ),
            Divider(
              thickness: 1,
              color: Color(0xFFEAE9E9),
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone_rounded,
                  size:30 ,),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone'),
                      Text('000 000 0000',style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFa3a5b2)
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.mail_rounded,
                  size: 30,),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email'),
                      Text('email@gmail.com',style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFa3a5b2)
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_on,
                    size: 30,),
                  SizedBox(width: 15,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address'),
                        Text('Lorem ipsum dolor sit amet. Qui nihil ipsum sed obcaecati libero ut',style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFa3a5b2)
                        ),)

                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.payments_outlined,
                    size: 30,),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Received'),
                      Text('Yes',style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFa3a5b2)
                      ),)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
