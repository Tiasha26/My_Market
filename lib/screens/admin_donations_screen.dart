import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';

class AdminDonationsScreen extends StatelessWidget {
  const AdminDonationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _adminService = AdminService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Donations',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: StreamBuilder<List<AdminDonation>>(
        stream: _adminService.getDonations(),
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

          final donations = snapshot.data ?? [];

          if (donations.isEmpty) {
            return const Center(
              child: Text('No donations found'),
            );
          }

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Donation #${donation.id.substring(0, 8)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                          Text(
                            'Status: ${donation.status.toUpperCase()}',
                            style: TextStyle(
                              color: _getStatusColor(donation.status),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Amount',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                              Text(
                                '\$${donation.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans',
                                  color: Color(0xFF95D6A4),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Admin Fee (15%)',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                              Text(
                                '\$${donation.adminFee.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans',
                                  color: Color(0xFF95D6A4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                      Text(
                        donation.description,
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Date: ${donation.date.toString().split(' ')[0]}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                      if (donation.status == 'pending') ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _updateDonationStatus(
                                context,
                                donation.id,
                                'rejected',
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _updateDonationStatus(
                                context,
                                donation.id,
                                'approved',
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
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateDonationStatus(
    BuildContext context,
    String donationId,
    String status,
  ) async {
    try {
      await AdminService().updateDonationStatus(donationId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donation ${status.toUpperCase()} successfully'),
          backgroundColor: status == 'approved' ? Colors.green : Colors.red,
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