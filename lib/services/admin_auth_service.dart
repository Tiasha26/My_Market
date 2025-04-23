import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Admin email addresses (you should store these securely in your backend)
  final List<String> _adminEmails = [
    'thecitc14@gmail.com', // Replace with actual admin email
  ];

  // Check if current user is admin
  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    // Check if user's email is in admin list
    if (_adminEmails.contains(user.email)) {
      // Verify admin status in Firestore
      final adminDoc = await _firestore.collection('admins').doc(user.uid).get();
      return adminDoc.exists;
    }
    return false;
  }

  // Admin login
  Future<UserCredential?> adminLogin(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify if the logged-in user is an admin
      if (await isAdmin()) {
        return userCredential;
      } else {
        // If not admin, sign out
        await _auth.signOut();
        return null;
      }
    } catch (e) {
      print('Admin login error: $e');
      return null;
    }
  }

  // Admin logout
  Future<void> adminLogout() async {
    await _auth.signOut();
  }

  // Get current admin user
  User? get currentAdminUser => _auth.currentUser;
} 