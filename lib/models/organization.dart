import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double totalDonations;
  final int donorCount;
  final bool isApproved;
  final DateTime dateCreated;
  final String contactEmail;
  final String contactPhone;

  const Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.totalDonations,
    required this.donorCount,
    required this.isApproved,
    required this.dateCreated,
    required this.contactEmail,
    required this.contactPhone,
  });

  static Organization fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Organization(
      id: snapshot["id"],
      name: snapshot["name"],
      description: snapshot["description"],
      imageUrl: snapshot["imageUrl"],
      category: snapshot["category"],
      totalDonations: snapshot["totalDonations"].toDouble(),
      donorCount: snapshot["donorCount"],
      isApproved: snapshot["isApproved"],
      dateCreated: (snapshot["dateCreated"] as Timestamp).toDate(),
      contactEmail: snapshot["contactEmail"],
      contactPhone: snapshot["contactPhone"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "category": category,
    "totalDonations": totalDonations,
    "donorCount": donorCount,
    "isApproved": isApproved,
    "dateCreated": Timestamp.fromDate(dateCreated),
    "contactEmail": contactEmail,
    "contactPhone": contactPhone,
  };
} 