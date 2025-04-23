import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_market/models/users.dart' as model;
import 'package:my_market/resource/storage_meth.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String bio, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
          'posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        bio: bio,
        uid: uid,
        username: username,
        postId: postId,
        postUrl: photoUrl,
        profImage: profImage,
        datePublished: DateTime.now(),
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> likePost(String postId, String uid, List likes) async {
  //   String res = "Some error occurred";
  //   try {
  //     if (likes.contains(uid)) {
  //       // if the likes list contains the user uid, we need to remove it
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       // else we need to add uid to the likes array
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

Future<void> updateUserData(model.User user) async {
  try {
    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
    await userDocRef.update({
      'username': user.username,
      'email': user.email,
      'bio': user.bio,
      'photoUrl': user.photoUrl
    });
  } catch (e) {
    print('Error updating user data: $e');
    rethrow; 
  }
}
  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Add rating to a business
  Future<String> addRating(String businessId, String userId, String username, double rating, String comment) async {
    String res = "Some error occurred";
    try {
      // Get current business data
      DocumentSnapshot businessDoc = await _firestore.collection('users').doc(businessId).get();
      Map<String, dynamic> businessData = businessDoc.data() as Map<String, dynamic>;
      
      // Calculate new average rating
      double currentRating = (businessData['rating'] ?? 0.0).toDouble();
      int totalRatings = businessData['totalRatings'] ?? 0;
      double newRating = ((currentRating * totalRatings) + rating) / (totalRatings + 1);
      
      // Create rating object
      Map<String, dynamic> ratingData = {
        'userId': userId,
        'username': username,
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      };
      
      // Update business document
      await _firestore.collection('users').doc(businessId).update({
        'rating': newRating,
        'totalRatings': totalRatings + 1,
        'ratings': FieldValue.arrayUnion([ratingData])
      });
      
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

