import 'dart:convert';
import 'package:flutter/widgets.dart';
// import 'package:niiflicks/classes/trending.dart';
import 'package:niiflicks/classes/trends.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailsProvider extends ChangeNotifier {
  Trending _trends;

  MovieDetailsProvider() {
    loadDetails();
  }
  Trending get profile => _trends;

  void createDetails(Trending user) {
    _trends = user;
    notifyListeners();
  }

  void saveDetails(data) async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    preference.setString("user-profile", data.toString());
  }

  void loadDetails() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var movie = preference.getString("user-profile");
    if (profile != null) {
      _trends = Trending.fromJson(jsonDecode(movie));
      notifyListeners();
    }
  }
}
