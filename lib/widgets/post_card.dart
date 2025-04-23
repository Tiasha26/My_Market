import 'package:flutter/material.dart';
import 'package:my_market/resource/firestore_method.dart';
import 'package:my_market/models/users.dart' as model;
import 'package:my_market/users_provider.dart';
import 'package:my_market/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err){
      showSnackBar(context, err.toString(),);
    }
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > 900 ? Colors.grey : Colors.white,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ Container(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding
                  (padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.snap['username'].toString(),
                    style: TextStyle(
                      fontFamily: 'Monsterrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid ?
                IconButton(
                onPressed: () {
                  showDialog(
                    useRootNavigator: false,
                    context: context, 
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            vertical: 16
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ] .map((e) => InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16
                              ),
                              child: Text(e),
                            ),
                            onTap: () {
                              deletePost(
                                widget.snap['postId'].toString(),
                              );
                              Navigator.of(context).pop();
                            }
                          ),
                          ).toList()
                        ), 
                      );
                    }
                    );
                },
                icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 24.0,
                ),
                ) :Container(),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height *0.5,
              width: double.infinity,
              child: Image.network(
                widget.snap['postUrl'].toString(),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10, left: 10),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black,
              fontSize: 16,
              ),
              text: '${widget.snap['bio']}',
              
            ),
            textAlign: TextAlign.start, 
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              DateFormat.yMMMd()
              .format(widget.snap['datePublished'].toDate()),
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ),
          Divider()
          ],
        ),
        ),
    );

  }
} 