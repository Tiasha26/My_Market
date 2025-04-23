
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_market/pages/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
const SearchScreen({super.key});

@override
State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
title: Form(
  child: TextFormField(
    controller: searchController,
    decoration: const InputDecoration(labelText: 'Search for a business...'),
    onFieldSubmitted: (String _) {
      setState(() {
        isShowUsers = true;
      });
    },
  ) 
  ),
),
body: isShowUsers ? FutureBuilder(
  future: FirebaseFirestore.instance.collection('users').where('username', 
  isGreaterThanOrEqualTo: searchController.text).get(),
  builder: (context, snapshot){
    if (!snapshot.hasData){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: (snapshot.data! as dynamic).docs.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Account(
                uid: (snapshot.data! as dynamic).docs[index]['uid'],
                ),
                ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                (snapshot.data! as dynamic).docs[index]['photoUrl'],
              ),
              radius: 16,
            ),
            title: Text(
              (snapshot.data! as dynamic).docs[index]['username'],
            ),
          ),
        );
      }
      );
  },
  )
  : FutureBuilder(
    future: FirebaseFirestore.instance.collection('posts').get(), 
  builder: (context, snapshot) {
    if (!snapshot.hasData){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return MasonryGridView.count(
      crossAxisCount: 3,
      itemCount: (snapshot.data! as dynamic).docs.length,
      itemBuilder: (context, index) => Image.network(
        (snapshot.data! as dynamic).docs[index]['postUrl'],
        fit: BoxFit.cover,
      ),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
  )
);
}
}
