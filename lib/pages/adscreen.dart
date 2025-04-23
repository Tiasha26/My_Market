import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:my_market/screens/ad_paymentscreen.dart';

class AdSubmissionScreen extends StatefulWidget {
  const AdSubmissionScreen({super.key});

  @override
  AdSubmissionScreenState createState() => AdSubmissionScreenState();
}

class AdSubmissionScreenState extends State<AdSubmissionScreen> {
  TextEditingController adTextController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  File? _image;
  final picker = ImagePicker();
  String? selectedPackage;
  bool isLoading = false;

  final List<Map<String, dynamic>> adPackages = [
    {"name": "7 Days - R50", "duration": 7, "price": 50.0, "id": "ad_promotion_7"},
    {"name": "14 Days - R90", "duration": 14, "price": 90.0, "id": "ad_promotion_14"},
    {"name": "30 Days - R150", "duration": 30, "price": 150.0, "id": "ad_promotion_30"},
  ];

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  bool _validateDates() {
    if (startDate == null || endDate == null || selectedPackage == null) return false;
    
    final selectedPackageData = adPackages.firstWhere(
      (package) => package['id'] == selectedPackage,
      orElse: () => adPackages[0],
    );
    
    final duration = selectedPackageData['duration'] as int;
    final expectedEndDate = startDate!.add(Duration(days: duration));
    
    return endDate!.isAtSameMomentAs(expectedEndDate);
  }

  Future<void> _submitAd() async {
    if (_image == null || adTextController.text.isEmpty || startDate == null || endDate == null || selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    if (!_validateDates()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date must match the selected package duration")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
    // Upload Image
    String fileName = 'ads/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    await storageRef.putFile(_image!);
    String imageUrl = await storageRef.getDownloadURL();

    // Save Ad Details in Firestore
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference adRef = await FirebaseFirestore.instance.collection('Advertisements').add({
      'userID': userId,
      'imageURL': imageUrl,
      'text': adTextController.text,
      'startDate': startDate,
      'endDate': endDate,
      'status': 'Pending',
      'package': selectedPackage,
        'timestamp': FieldValue.serverTimestamp(),
        'price': adPackages.firstWhere((p) => p['id'] == selectedPackage)['price'],
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ad submitted successfully. Proceeding to payment.")),
      );

    // Navigate to Payment Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdPaymentScreen(adId: adRef.id, packageId: selectedPackage!),
      ),
    );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting ad: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submit Advertisement",
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ad Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB3E59F).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF95D6A4),
                            width: 2,
                          ),
                        ),
              child: _image == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, size: 50, color: Color(0xFF235381)),
                                    SizedBox(height: 8),
                                    Text(
                                      "Tap to add image",
                                      style: TextStyle(
                                        color: Color(0xFF235381),
                                        fontFamily: 'Merriweather',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ad Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: adTextController,
                      decoration: InputDecoration(
                        hintText: "Enter your ad description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF95D6A4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF95D6A4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF235381)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Package",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
              value: selectedPackage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF95D6A4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF95D6A4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF235381)),
                        ),
                      ),
                      hint: const Text(
                        "Choose a package",
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          color: Colors.grey,
                        ),
                      ),
                      items: adPackages.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                          value: item['id'] as String,
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontFamily: 'Merriweather',
                            ),
                          ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPackage = value;
                          if (startDate != null) {
                            final selectedPackageData = adPackages.firstWhere(
                              (package) => package['id'] == value,
                              orElse: () => adPackages[0],
                            );
                            endDate = startDate!.add(
                              Duration(days: selectedPackageData['duration'] as int),
                            );
                          }
                });
              },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ad Duration",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  startDate = picked;
                                  if (selectedPackage != null) {
                                    final selectedPackageData = adPackages.firstWhere(
                                      (package) => package['id'] == selectedPackage,
                                      orElse: () => adPackages[0],
                                    );
                                    endDate = startDate!.add(
                                      Duration(days: selectedPackageData['duration'] as int),
                                    );
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              startDate == null
                                  ? "Start Date"
                                  : "Start: ${startDate.toString().split(" ")[0]}",
                              style: const TextStyle(
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF95D6A4),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
              onPressed: () async {
                              if (startDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select start date first")),
                                );
                                return;
                              }
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: endDate ?? startDate!,
                                firstDate: startDate!,
                                lastDate: startDate!.add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() => endDate = picked);
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              endDate == null
                                  ? "End Date"
                                  : "End: ${endDate.toString().split(" ")[0]}",
                              style: const TextStyle(
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF95D6A4),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _submitAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF235381),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Proceed to Payment",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Merriweather',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
