import 'package:flutter/material.dart';
import 'package:my_market/pages/home.dart';
import 'package:my_market/pages/donate.dart';
import 'package:my_market/pages/account.dart';
import 'package:my_market/pages/customers.dart';
import 'package:my_market/pages/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'homepage_screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Home(),
    Donate(),
    News(),
    Customers(),
    Account(uid: AutofillHints.username)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Donate'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: 'News'),
            BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Customers'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile')
          ],
        selectedItemColor: Color(0xFF235381),
        unselectedItemColor: Color(0xFF95D6A4),
        iconSize: 45,
      ),
    );
  }
}
