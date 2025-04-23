import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_models.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all payments
  Stream<List<AdminPayment>> getPayments() {
    return _firestore
        .collection('payments')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdminPayment.fromFirestore(doc))
            .toList());
  }

  // Update payment status
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    await _firestore.collection('payments').doc(paymentId).update({
      'status': status,
    });
  }

  // Get all ads
  Stream<List<AdminAd>> getAds() {
    return _firestore
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AdminAd.fromFirestore(doc)).toList());
  }

  // Update ad status
  Future<void> updateAdStatus(String adId, String status) async {
    await _firestore.collection('ads').doc(adId).update({
      'status': status,
    });
  }

  // Get all donations
  Stream<List<AdminDonation>> getDonations() {
    return _firestore
        .collection('donations')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdminDonation.fromFirestore(doc))
            .toList());
  }

  // Update donation status
  Future<void> updateDonationStatus(String donationId, String status) async {
    await _firestore.collection('donations').doc(donationId).update({
      'status': status,
    });
  }

  // Get admin dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfYear = DateTime(now.year, 1, 1);

    // Get total payments
    final totalPayments = await _firestore
        .collection('payments')
        .where('status', isEqualTo: 'approved')
        .get();

    // Get monthly payments
    final monthlyPayments = await _firestore
        .collection('payments')
        .where('status', isEqualTo: 'approved')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .get();

    // Get yearly payments
    final yearlyPayments = await _firestore
        .collection('payments')
        .where('status', isEqualTo: 'approved')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
        .get();

    // Calculate totals
    double totalAmount = 0;
    double monthlyAmount = 0;
    double yearlyAmount = 0;

    for (var doc in totalPayments.docs) {
      totalAmount += (doc.data()['amount'] as num).toDouble();
    }

    for (var doc in monthlyPayments.docs) {
      monthlyAmount += (doc.data()['amount'] as num).toDouble();
    }

    for (var doc in yearlyPayments.docs) {
      yearlyAmount += (doc.data()['amount'] as num).toDouble();
    }

    // Get pending items counts
    final pendingAds = await _firestore
        .collection('ads')
        .where('status', isEqualTo: 'pending')
        .count()
        .get();

    final pendingDonations = await _firestore
        .collection('donations')
        .where('status', isEqualTo: 'pending')
        .count()
        .get();

    return {
      'totalPayments': totalAmount,
      'monthlyPayments': monthlyAmount,
      'yearlyPayments': yearlyAmount,
      'pendingAds': pendingAds.count ?? 0,
      'pendingDonations': pendingDonations.count ?? 0,
    };
  }
} 