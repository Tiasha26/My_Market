import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    final String uid;
  late  String username;
  late  String email;
  late  String photoUrl;
  late  String bio;
  String? phone;
  String? address;
  Map<String, dynamic>? location;
  double rating;
  int totalRatings;
  List<Map<String, dynamic>> ratings;

  User (
      {
        required this.uid,
        required this.username,
        required this.email,
        required this.photoUrl,
        required this.bio, 
        this.phone,
        this.address,
        this.location,
        this.rating = 0.0,
        this.totalRatings = 0,
        this.ratings = const [],
      }
      );

  get password => null;
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
       username: snapshot["username"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      phone: snapshot["phone"],
      address: snapshot["address"],
      location: snapshot["location"],
      rating: (snapshot["rating"] ?? 0.0).toDouble(),
      totalRatings: snapshot["totalRatings"] ?? 0,
      ratings: List<Map<String, dynamic>>.from(snapshot["ratings"] ?? []),
    );
  }
  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "email": email,
    "photoUrl": photoUrl,
    "bio": bio,
    "phone": phone,
    "address": address,
    "location": location,
    "rating": rating,
    "totalRatings": totalRatings,
    "ratings": ratings,
  };
}