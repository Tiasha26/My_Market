import 'package:flutter/widgets.dart';
import 'package:my_market/models/users.dart';
import 'package:my_market/resource/authen_method.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}