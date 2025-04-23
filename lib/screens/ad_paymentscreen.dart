import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdPaymentScreen extends StatefulWidget {
  final String adId;
  final String packageId;

  const AdPaymentScreen({super.key, required this.adId, required this.packageId});

  @override
  _AdPaymentScreenState createState() => _AdPaymentScreenState();
}

class _AdPaymentScreenState extends State<AdPaymentScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
  }

  Future<void> _initializeInAppPurchase() async {
    try {
      final bool available = await _iap.isAvailable();
      if (!available) {
        setState(() {
          _isAvailable = false;
          _isLoading = false;
          _error = 'In-app purchases are not available';
        });
        return;
      }

      // Listen to purchase updates
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      });

      // Load products
      await _loadProducts();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error initializing in-app purchase: ${e.toString()}';
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      Set<String> ids = {widget.packageId};
      final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      
      if (response.notFoundIDs.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _error = 'Some products were not found';
        });
      }

      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading products: ${e.toString()}';
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending state
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${purchaseDetails.error}')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        // Verify the purchase
        _verifyPurchase(purchaseDetails);
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // Update the ad status in Firestore
      await FirebaseFirestore.instance.collection('Advertisements').doc(widget.adId).update({
        'status': 'Paid',
        'paymentTimestamp': FieldValue.serverTimestamp(),
        'purchaseId': purchaseDetails.purchaseID,
        'transactionDate': DateTime.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful! Ad will be reviewed.")),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying purchase: ${e.toString()}')),
      );
    }
  }

  Future<void> _buyAd(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: FirebaseAuth.instance.currentUser?.uid,
      );
      
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing purchase: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pay for Ad Promotion",
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFF235381),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF235381),
                            fontFamily: 'Merriweather',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _initializeInAppPurchase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF235381),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : !_isAvailable
                  ? const Center(
                      child: Text(
                        'In-app purchases are not available',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Merriweather',
                          color: Color(0xFF235381),
                        ),
                      ),
                    )
                  : _products.isEmpty
                      ? const Center(
                          child: Text(
                            'No products available',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Merriweather',
                              color: Color(0xFF235381),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            ProductDetails product = _products[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Merriweather',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.description,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontFamily: 'Merriweather',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.price,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF235381),
                                            fontFamily: 'Merriweather',
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => _buyAd(product),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF235381),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Purchase',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Merriweather',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
    );
  }
}
