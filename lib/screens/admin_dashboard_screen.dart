import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../services/admin_auth_service.dart';
import 'admin_payments_screen.dart';
import 'admin_ads_screen.dart';
import 'admin_donations_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _adminService = AdminService();
  final _adminAuthService = AdminAuthService();
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _adminService.getDashboardStats();
    setState(() => _stats = stats);
  }

  Future<void> _logout() async {
    await _adminAuthService.adminLogout();
    Navigator.pushReplacementNamed(context, '/admin/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather',
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    'Total Payments',
                    '\$${_stats['totalPayments']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.payments,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Monthly Payments',
                    '\$${_stats['monthlyPayments']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.calendar_today,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Yearly Payments',
                    '\$${_stats['yearlyPayments']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.calendar_month,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Pending Items',
                    '${(_stats['pendingAds'] ?? 0) + (_stats['pendingDonations'] ?? 0)}',
                    Icons.pending_actions,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather',
                ),
              ),
              const SizedBox(height: 16),
              _buildManagementCard(
                'Payments',
                'Manage payment transactions',
                Icons.payments,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPaymentsScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildManagementCard(
                'Ads',
                'Manage advertisement submissions',
                Icons.campaign,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAdsScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildManagementCard(
                'Donations',
                'Manage donation submissions',
                Icons.favorite,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDonationsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(0xFF95D6A4),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
                color: const Color(0xFF95D6A4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 32, color: const Color(0xFF95D6A4)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'NotoSans',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF95D6A4)),
        onTap: onTap,
      ),
    );
  }
} 