import 'package:flutter/widgets.dart';
import 'package:my_market/models/users.dart';
import 'package:my_market/resource/authen_method.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;


  // // //update user
  // Future<void> updateUser(User newUserData, {required User newUserData}) async {
  //   _user = newUserData;
  //   await _authMethods.updateUserData( user: _user!);
  //   notifyListeners();
  // }


  // // void updateUser(User newUserData) {
  // //   _user = newUserData;
  // //   notifyListeners();
  // // }

void updateUsername(String newUsername) {
  _user!.username = newUsername;
  notifyListeners();
}

  void updateEmail(String newEmail) {
    _user!.email = newEmail;
    notifyListeners();
  }


  void updateBio(String newBio) {    
    _user!.bio = newBio;
    notifyListeners();
  }

  void updatePhotoUrl(String newPhotoUrl) {    
    _user!.photoUrl = newPhotoUrl;
    notifyListeners();
  }
  

  Future<void> saveUserData() async {
    await _authMethods.updateUserData(_user!);
    notifyListeners();

  }

//refresh user
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }


}