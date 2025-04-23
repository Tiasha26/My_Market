import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _adminService = AdminService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Payments',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: StreamBuilder<List<AdminPayment>>(
        stream: _adminService.getPayments(),
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

          final payments = snapshot.data ?? [];

          if (payments.isEmpty) {
            return const Center(
              child: Text('No payments found'),
            );
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    payment.type == 'ad' ? Icons.campaign : Icons.favorite,
                    color: payment.type == 'ad' ? Colors.blue : Colors.red,
                  ),
                  title: Text(
                    '${payment.type.toUpperCase()} Payment',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount: \$${payment.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                          color: Color(0xFF95D6A4),
                        ),
                      ),
                      Text(
                        'Date: ${payment.date.toString().split(' ')[0]}',
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                        ),
                      ),
                      Text(
                        'Status: ${payment.status.toUpperCase()}',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          color: _getStatusColor(payment.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: payment.status == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _updatePaymentStatus(
                                context,
                                payment.id,
                                'approved',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _updatePaymentStatus(
                                context,
                                payment.id,
                                'rejected',
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updatePaymentStatus(
    BuildContext context,
    String paymentId,
    String status,
  ) async {
    try {
      await AdminService().updatePaymentStatus(paymentId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment ${status.toUpperCase()} successfully'),
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

  Color _getStatusColor(String status) {
    if (status == 'approved') {
      return Colors.green;
    } else if (status == 'rejected') {
      return Colors.red;
    } else {
      throw Exception('Unknown status');
    }
  }
} 