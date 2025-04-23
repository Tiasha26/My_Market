import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_market/models/users.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/resource/storage_meth.dart';
import 'package:my_market/users_provider.dart';
import 'package:my_market/util/utils.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
    Uint8List? _newImage;

  void _selectNewImage() async {
    final pickedImage = await pickImage(ImageSource.gallery);
    if (pickedImage != null) {
      setState(() async {
        _newImage = pickedImage;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      maintainBottomViewPadding: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Edit Profile',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.white,
          )),
          backgroundColor: Color(0xfffb3e59f),
        ),
        body: Padding(padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // if (_image! == null && userProvider.getUser.photoUrl != null),
                            Stack(
                    children: [
                      _newImage != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(_newImage!),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userProvider.getUser.photoUrl),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 65,
                          child: IconButton( 
                              onPressed: () {
                                _selectNewImage();
                              },
                              icon: Icon(Icons.add_circle_outlined,
                              color: Colors.black,)
                              )
                              )
                    ],
                  ),
            const SizedBox(height: 10,),
            TextFormField(
              initialValue: userProvider.getUser.username,
              onChanged: (value) {
                userProvider.updateUsername(value);
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  
                )
              )
            ), 
            const SizedBox(height: 10,),
            TextFormField(
              initialValue: userProvider.getUser.email,
              onChanged: (value) {
                userProvider.updateEmail(value);
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  
                )
              )
            ),
            
    
            const SizedBox(height: 10,),
            TextFormField(
              maxLines: 6,
              initialValue: userProvider.getUser.bio,
              onChanged: (value) {
                userProvider.updateBio(value);
              },
              decoration: const InputDecoration(
                labelText: 'Bio',
                                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  
                )
              )
            ),
    
            ElevatedButton(
              onPressed: () async {
                if (_newImage != null) {
                  final newPhotoUrl = await StorageMethods().uploadImageToStorage('profilePics', _newImage!, false);
                  userProvider.updatePhotoUrl(newPhotoUrl);  
                }
                userProvider.saveUserData();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
        ),
      ),
    );
  }
}