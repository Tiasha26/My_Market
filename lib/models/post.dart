import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String bio;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post(
      {required this.bio,
        required this.uid,
        required this.username,
        required this.postId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        bio: snapshot["bio"],
        uid: snapshot["uid"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']
    );
  }

  Map<String, dynamic> toJson() => {
    "bio": bio,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage
  };
}