import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:niiflicks/classes/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoggedProvider extends ChangeNotifier {
  UsersInfo _userLog;
  bool _authenticated = false;

  UserLoggedProvider() {
    authenticate();
  }
  UsersInfo get userInfo => _userLog;
  bool get authenticated => _authenticated;

  void createAppUser(UsersInfo usersIn) {
    _userLog = usersIn;
    notifyListeners();
  }

  void saveAuth(data) async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    preference.setString("auth-data", data.toString());
  }

  void authenticate() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var user = preference.getString("auth-data");
    if (user != null) {
      _userLog = UsersInfo.fromJson(jsonDecode(user));
      _authenticated = true;
      notifyListeners();
    }
  }
}
