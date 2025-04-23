import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_market/pages/add_post.dart';
import 'package:my_market/pages/home.dart';
import 'package:my_market/pages/account.dart';
import 'package:my_market/pages/search.dart';
import 'package:my_market/pages/donate.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});
  static const String id = 'WebScreenLayout';

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Home(),
    SearchScreen(),
    AddPost(),
    Donate(),
    // News(),
    // Customers(),
    Account(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Add Post'),
          
          BottomNavigationBarItem(
             icon: Icon(Icons.monetization_on), label: 'Donate'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.newspaper_rounded), label: 'News'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.groups), label: 'Customers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile')
        ],
        selectedItemColor: Color(0xFF235381),
        unselectedItemColor: Color(0xFF95D6A4),
        iconSize: 55,
      ),
    );
  }
}
