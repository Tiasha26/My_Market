import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPayment {
  final String id;
  final double amount;
  final String type; // 'ad' or 'donation'
  final DateTime date;
  final String status; // 'pending', 'approved', 'rejected'
  final String userId;
  final String? adId;
  final String? donationId;

  AdminPayment({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.status,
    required this.userId,
    this.adId,
    this.donationId,
  });

  factory AdminPayment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AdminPayment(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      adId: data['adId'],
      donationId: data['donationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'date': Timestamp.fromDate(date),
      'status': status,
      'userId': userId,
      'adId': adId,
      'donationId': donationId,
    };
  }
}

class AdminAd {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status; // 'pending', 'active', 'rejected'
  final String userId;
  final double price;

  AdminAd({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.userId,
    required this.price,
  });

  factory AdminAd.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AdminAd(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'userId': userId,
      'price': price,
    };
  }
}

class AdminDonation {
  final String id;
  final double amount;
  final DateTime date;
  final String status; // 'pending', 'approved', 'rejected'
  final String userId;
  final String description;
  final double adminFee; // 15% of the donation amount

  AdminDonation({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    required this.userId,
    required this.description,
    required this.adminFee,
  });

  factory AdminDonation.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AdminDonation(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      adminFee: (data['adminFee'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'status': status,
      'userId': userId,
      'description': description,
      'adminFee': adminFee,
    };
  }
} 