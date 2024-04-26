import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/screens/login_screen.dart';
import 'package:my_market/util/utils.dart';
import 'package:my_market/widgets/set_button.dart';


class Account extends StatefulWidget {
  final String uid;
  const Account({super.key, required this.uid});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var userData = {};
  int postLen = 0;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
          context,
          e.toString());
    }
    setState(() {
      isLoading = false;
    });
    }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        :Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.transparent
        ),
        title:  Text(
          userData['username'],
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 10),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData['photoUrl']),
                    radius: 45,
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           userData['username'],
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Open',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0XFF67FF84),
                            ),
                          ),
                          FirebaseAuth.instance.currentUser!.uid ==
                              widget.uid ? SetButton(
                            backgroundColor: Colors.grey,
                            borderColor: Colors.black,
                            text: 'Sign Out',
                            textColor: Colors.black,
                            function: () async{
                              await AuthMethods().signOut();
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const LoginScreen(),),);
                              }
                            },
                          )
                        : const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.more_vert,
                    size: 30,
                  ),
                ],
              ),
            ),
    const Divider(),
    FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }

    return GridView.builder(
    shrinkWrap: true,
    itemCount: (snapshot.data! as dynamic).docs.length,
    gridDelegate:
    const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 5,
    mainAxisSpacing: 1.5,
    childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
    DocumentSnapshot snap =
    (snapshot.data! as dynamic).docs[index];

    return SizedBox(
    child: Image(
    image: NetworkImage(snap['postUrl']),
    fit: BoxFit.cover,
    ),
    );
    },
    );
    },
    )
    ],
    ),
    ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child:  Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Stack(
    //                 children: [
    //                   Images(),
    //                   Positioned(
    //                       bottom: 150,
    //                       left: 220,
    //                       child: IconButton(
    //                           onPressed: () {
    //                             Navigator.push(context, MaterialPageRoute(builder: (context) {
    //                               return Gallery();
    //                             }));
    //                           },
    //                           icon: Icon(Icons.add_a_photo_rounded)))
    //                 ],
    //               ),
    //               Images(),
    //               Images(),
    //               Images(),
    //               Images(),
    //               Images(),
    //             ],
    //           ),
    //         ),
    //         // FloatingActionButton(
    //         //     mini: true,
    //         //     elevation: 0,
    //         //     backgroundColor: Colors.white,
    //         //     onPressed: (){
    //         //       Navigator.push(context, MaterialPageRoute(
    //         //           builder: (context){
    //         //             return Gallery();
    //         //           }));
    //         //     },
    //         //     child: Icon(Icons.add_a_photo_rounded,
    //         //       color: Colors.black,
    //         //       size: 30,
    //         //     )),
    //         SizedBox(
    //           height: 10 ,
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
    //           child: const Row(
    //             children: [
    //               Icon(Icons.phone_rounded),
    //               SizedBox(
    //                 width: 20,
    //               ),
    //               Expanded(
    //                 child:
    //                 Text(
    //                   '000 000 0000',
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 )
    //                 ,
    //               ),
    //
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    //           child: const Row(
    //             children: [
    //               Icon(Icons.access_time_filled),
    //               Expanded(
    //                 child: Padding(
    //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
    //                   child: Text(
    //                     'Open Today 00:00 - 00:00',
    //                     style: TextStyle(
    //                       fontSize: 14,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Icon(Icons.arrow_drop_down)
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    //           child: const Row(
    //             children: [
    //               Icon(Icons.chat),
    //               Padding(
    //                 padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
    //                 child: Text(
    //                   'email@gmail.com',
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    //           child: const Row(
    //             children: [
    //               Icon(Icons.public),
    //               Padding(
    //                 padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
    //                 child: Text(
    //                   'https://websitename.com',
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    //           child: const Row(
    //             children:  [
    //               Icon(Icons.location_on),
    //               SizedBox(
    //                 width: 20,
    //               ),
    //               Flexible(child:
    //               Text('Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet.')
    //               )
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    //           child: const Row(
    //             children: [
    //               Icon(Icons.facebook),
    //               Padding(
    //                 padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
    //                 child: Text(
    //                   'Lorem ipsum dolor sit amet. ',
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //
    //       ],
    //     ),
    //   ),
    // );
  }
  }




