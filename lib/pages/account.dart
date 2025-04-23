import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_market/pages/edit_page.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/screens/ad_paymentscreen.dart';
import 'package:my_market/screens/login_screen.dart';
import 'package:my_market/screens/contact_details_screen.dart';
import 'package:my_market/util/utils.dart';
import 'package:my_market/widgets/set_button.dart';
import 'package:my_market/pages/adscreen.dart';
import 'package:my_market/resource/firestore_method.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  final FireStoreMethods _firestoreMethods = FireStoreMethods();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
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
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
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
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Colors.white,
                size: 30,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Menu()),
                    );
                  },
                  icon: const Icon(Icons.menu)
                )
              ],
              title: Text(
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
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(userData['photoUrl']),
                          radius: 45,
                          backgroundColor: Colors.transparent,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData['username'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Open',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFFB3E59F),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star_rate, size: 20, color: Colors.amber,),
                                    SizedBox(width: 4),
                                    Text(
                                      userData['rating']?.toStringAsFixed(1) ?? '0.0',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '(${userData['totalRatings'] ?? 0})',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (FirebaseAuth.instance.currentUser!.uid != widget.uid)
                                      TextButton(
                                        onPressed: () => _showRatingDialog(context),
                                        child: Text(
                                          'Rate Business',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF95D6A4),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.more_vert,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    child: Text(
                      userData['bio'],
                      maxLines: 6,
                      softWrap: true,
                    ),
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? SetButton(
                                backgroundColor: Color(0xFFB3E59F),
                                borderColor: Color(0xFFB3E59F),
                                text: 'Edit Profile',
                                textColor: Colors.black,
                                function: () async {
                                  await AuthMethods().getUserDetails();
                                  if (context.mounted) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => EditPage()));
                                  }
                                },
                              )
                            : Container(),
                            // CircularProgressIndicator(color: Colors.black,),
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? SetButton(
                                backgroundColor: Color(0xFFB3E59F),
                                borderColor: Color(0xFFB3E59F),
                                text: 'Sign Out',
                                textColor: Colors.black,
                                function: () async {
                                  await AuthMethods().signOut();
                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  }
                                },
                              )
                            : Container(),
                      ]),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost()));
                  //   },
                  //   icon: Icon(Icons.add_a_photo_rounded)),
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
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate ${userData['username']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (rating > 0) {
                String res = await _firestoreMethods.addRating(
                  widget.uid,
                  FirebaseAuth.instance.currentUser!.uid,
                  FirebaseAuth.instance.currentUser!.displayName ?? 'Anonymous',
                  rating,
                  commentController.text,
                );
                if (res == 'success') {
                  Navigator.pop(context);
                  getData(); // Refresh the data
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res)),
                  );
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E59F),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30
        ),
        title: const Text("Settings"),
        backgroundColor: const Color(0xFFB3E59F),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('Profile Settings'),
            onTap: () {
              // Add profile settings navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.black),
            title: const Text('Contact Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactDetailsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign, color: Colors.black),
            title: const Text('Submit Advertisement'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdSubmissionScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments, color: Colors.black),
            title: const Text('My Ad Payments'),
            onTap: () {
              // Navigate to a new screen that shows user's ad payment history
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdPaymentHistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.black),
            title: const Text('Notifications'),
            onTap: () {
              // Add notifications settings navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.black),
            title: const Text('Privacy'),
            onTap: () {
              // Add privacy settings navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.black),
            title: const Text('Help & Support'),
            onTap: () {
              // Add help & support navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black),
            title: const Text('About'),
            onTap: () {
              // Add about navigation
            },
          ),
        ],
      ),
    );
  }
}

// Add a new screen for viewing ad payment history
class AdPaymentHistoryScreen extends StatelessWidget {
  const AdPaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ad Payments'),
        backgroundColor: const Color(0xFF235381),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Advertisements')
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final ads = snapshot.data?.docs ?? [];

          if (ads.isEmpty) {
            return const Center(
              child: Text('No advertisement payments found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Image.network(
                    ad['imageURL'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(ad['text']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${ad['status']}'),
                      Text('Package: ${ad['package']}'),
                      Text('Price: R${ad['price']}'),
                      if (ad['paymentTimestamp'] != null)
                        Text(
                          'Paid: ${(ad['paymentTimestamp'] as Timestamp).toDate().toString().split(' ')[0]}',
                        ),
                    ],
                  ),
                  trailing: Icon(
                    ad['status'] == 'Paid' ? Icons.check_circle : Icons.pending,
                    color: ad['status'] == 'Paid' ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
