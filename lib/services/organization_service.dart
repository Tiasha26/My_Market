import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_market/models/organization.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class OrganizationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> submitOrganization({
    required String name,
    required String description,
    required File image,
    required String category,
    required String contactEmail,
    required String contactPhone,
  }) async {
    try {
      // Upload image
      String fileName = 'organizations/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage.ref().child(fileName);
      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();

      // Create organization document
      String orgId = const Uuid().v1();
      Organization organization = Organization(
        id: orgId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        category: category,
        totalDonations: 0,
        donorCount: 0,
        isApproved: false,
        dateCreated: DateTime.now(),
        contactEmail: contactEmail,
        contactPhone: contactPhone,
      );

      await _firestore.collection('organizations').doc(orgId).set(organization.toJson());
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> makeDonation({
    required String organizationId,
    required double amount,
    required String donorId,
  }) async {
    try {
      // Calculate admin fee (15%)
      double adminFee = amount * 0.15;
      double organizationAmount = amount - adminFee;

      // Update organization's total donations and donor count
      await _firestore.collection('organizations').doc(organizationId).update({
        'totalDonations': FieldValue.increment(organizationAmount),
        'donorCount': FieldValue.increment(1),
      });

      // Record donation transaction
      await _firestore.collection('donations').add({
        'organizationId': organizationId,
        'donorId': donorId,
        'amount': amount,
        'adminFee': adminFee,
        'organizationAmount': organizationAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<Organization>> getApprovedOrganizations() {
    return _firestore
        .collection('organizations')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Organization.fromSnap(doc))
          .toList();
    });
  }

  Future<List<Organization>> getPendingOrganizations() async {
    QuerySnapshot snapshot = await _firestore
        .collection('organizations')
        .where('isApproved', isEqualTo: false)
        .get();
    
    return snapshot.docs.map((doc) => Organization.fromSnap(doc)).toList();
  }

  Future<String> approveOrganization(String organizationId) async {
    try {
      await _firestore.collection('organizations').doc(organizationId).update({
        'isApproved': true,
      });
      return "success";
    } catch (e) {
      return e.toString();
    }
  }
} 