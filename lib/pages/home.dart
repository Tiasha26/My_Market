import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_market/widgets/post_card.dart';
import 'package:my_market/widgets/notification_badge.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final int _postsPerPage = 10;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  DocumentSnapshot? _lastDocument;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialPosts() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .limit(_postsPerPage)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _posts = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          _lastDocument = querySnapshot.docs.last;
          _hasMorePosts = querySnapshot.docs.length >= _postsPerPage;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load posts: ${e.toString()}');
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_hasMorePosts || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(_postsPerPage)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _posts.addAll(
            querySnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList(),
          );
          _lastDocument = querySnapshot.docs.last;
          _hasMorePosts = querySnapshot.docs.length >= _postsPerPage;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _hasMorePosts = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      _showErrorSnackBar('Failed to load more posts: ${e.toString()}');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadInitialPosts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: width > 900 ? Colors.grey : Colors.white70,
        appBar: width > 900
            ? null
            : AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.transparent,
                ),
                title: const Text(
                  'My Market',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: const Color(0xFF95D6A4),
                actions: [
                  NotificationBadge(
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                ],
              ),
        body: RefreshIndicator(
          onRefresh: _loadInitialPosts,
          child: _posts.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _posts.length + (_hasMorePosts ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == _posts.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > 900 ? width * 0.3 : 0,
                        vertical: width > 900 ? 15 : 0,
                      ),
                      child: PostCard(
                        snap: _posts[index],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
