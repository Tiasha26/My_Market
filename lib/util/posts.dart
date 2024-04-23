import 'package:flutter/material.dart';
import 'package:my_market/pages/account.dart';

class Posts extends StatelessWidget {
  const Posts({super.key, /*required this.name*/});
 // final String name;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Divider(
          height: 20,
          indent: 50,
          endIndent: 50,
          thickness: 1,
          color: Color(0xFFEAE9E9),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return Account(uid: AutofillHints.username);
                          }));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('images/man.png'),
                      backgroundColor: Colors.transparent,

                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text('name',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
              /*const*/ Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Location',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF57636C),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 4, 4, 0),
                      child: Text(
                        'Rating',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: Color(0xFF57636C),
                      size: 24,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image(
                    image: NetworkImage('https://picsum.photos/seed/892/600'),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
