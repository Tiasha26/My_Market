import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';

class AdminAdsScreen extends StatelessWidget {
  const AdminAdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _adminService = AdminService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Ads',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: StreamBuilder<List<AdminAd>>(
        stream: _adminService.getAds(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final ads = snapshot.data ?? [];

          if (ads.isEmpty) {
            return const Center(
              child: Text('No ads found'),
            );
          }

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    if (ad.imageUrl.isNotEmpty)
                      Image.network(
                        ad.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ad.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ad.description,
                            style: const TextStyle(
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price: \$${ad.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans',
                                  color: Color(0xFF95D6A4),
                                ),
                              ),
                              Text(
                                'Status: ${ad.status.toUpperCase()}',
                                style: TextStyle(
                                  color: _getStatusColor(ad.status),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Posted: ${ad.createdAt.toString().split(' ')[0]}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          if (ad.status == 'pending') ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _updateAdStatus(
                                    context,
                                    ad.id,
                                    'rejected',
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _updateAdStatus(
                                    context,
                                    ad.id,
                                    'active',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Approve'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateAdStatus(
    BuildContext context,
    String adId,
    String status,
  ) async {
    try {
      await AdminService().updateAdStatus(adId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ad ${status.toUpperCase()} successfully'),
          backgroundColor: status == 'active' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 