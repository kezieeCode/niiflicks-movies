import 'dart:convert';
import 'package:niiflicks/classes/users.dart';
// import 'package:niiflicks/constant/api_constant.dart';
import 'package:niiflicks/constant/color_const.dart';
// import 'package:niiflicks/constant/string_const.dart';
// import 'package:niiflicks/state/users.dart';
import 'package:niiflicks/utils/widgethelper/oval-right-clipper.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
// import 'package:niiflicks/view/home/card.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:niiflicks/view/musics/browse_widget.dart';
import 'package:niiflicks/view/screens/live_tv_dash.dart';
// import 'package:niiflicks/view/musics/search_widget.dart';
// import 'package:niiflicks/view/other/about_us_screen.dart';
import 'package:niiflicks/view/other/feedback_screen.dart';
import 'package:niiflicks/view/other/help_screen.dart';
import 'package:niiflicks/view/other/invite_friend_screen.dart';
import 'package:niiflicks/view/profile_screen.dart';
// import 'package:niiflicks/view/screens/albumSongs.dart';
// import 'package:niiflicks/view/screens/albums.dart';
import 'package:niiflicks/view/screens/animation.dart';
// import 'package:niiflicks/view/screens/dashboard_screen.dart';
// import 'package:niiflicks/view/screens/home.dart';
import 'package:niiflicks/view/screens/live_tv.dart';
import 'package:niiflicks/view/screens/my_movies.dart';
// import 'package:niiflicks/view/screens/my_music.dart';
// import 'package:niiflicks/view/screens/my_music_details.dart';
// import 'package:niiflicks/view/screens/play.dart';
import 'package:niiflicks/view/screens/tv_shows.dart';
import 'package:niiflicks/view/setting/settings_screen.dart';
import 'package:flutter/material.dart';

// import 'package:niiflicks/view/viewAll/watchlater.dart';
// import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:niiflicks/view/home/card.dart';

// ignore: must_be_immutable
class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged');
    await Future.delayed(Duration(seconds: 2));

    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    navigationPush(_context, Login());
  }

  BuildContext _context;
  String displayName;
  Future user() async {
    Uri url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/getuserdata');

    final prefs = await SharedPreferences.getInstance();
    var emails = prefs.getString('email');
    var data = {'email': emails};
    print(data);
    final newUri = url.replace(queryParameters: data);
    print(emails);
    var response = await http.get(newUri);
    if (response.statusCode == 200) {
      print(response.body);
      // print(response.body);
      // print(email);
      return UsersInfo.fromJson(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('Network Failure');
    }
  }

  @override
  void initState() {
    getInfo();
    user();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildDrawer(context);
  }

  _buildDrawer(BuildContext context) {
    displayEmail() {
      if (displayName != null) {
        return Text(
          '${displayName}'.toUpperCase(),
          style: TextStyle(color: Colors.white),
        );
      } else {
        return Text('logged out');
      }
    }

    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: ColorConst.WHITE_BG_COLOR,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () => Navigator.of(_context).pop()),
                  ),
                  InkWell(
                    onTap: () => user(),
                    // _navigateOnNextScreen('Profile'),
                    child: Container(
                      height: 128,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            ColorConst.RED_COLOR,
                            ColorConst.RED_COLOR
                          ])),
                      child: FutureBuilder(
                        future: user(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data.profilepicture);
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(snapshot.data.profilepicture),
                            );
                          } else if (snapshot.hasError) {
                            return Center(child: Text('N/A'));
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  displayEmail(),

                  SizedBox(height: 30.0),

                  // _buildRow(Icons.home, "Home",),
                  // _buildDivider(),
                  // _buildRow(Icons.movie, "Category"),
                  // _buildDivider(),
                  // _buildRow(Icons.local_movies, "Trending Movie",
                  //     showBadge: true),
                  // _buildDivider(),
                  // _buildRow(Icons.movie_filter, "Popular Movie",
                  //     showBadge: false),
                  // _buildDivider(),
                  // _buildRow(Icons.movie, "New Releases", showBadge: true),
                  _buildRow(Icons.live_tv, "Live TV"),
                  _buildDivider(),
                  // _buildRow(Icons.add, "My List"),
                  // _buildDivider(),
                  _buildRow(Icons.child_care, "Kids"),
                  _buildDivider(),
                  _buildRow(Icons.movie, "My Movies"),
                  _buildDivider(),
                  _buildRow(Icons.tv, "TV shows"),
                  _buildDivider(),

                  _buildRow(Icons.music_note, "My music"),
                  _buildDivider(),
                  // _buildRow(Icons.person_pin, "Profile"),
                  // _buildDivider(),
                  _buildRow(Icons.settings, "Settings"),
                  _buildDivider(),
                  // _buildRow(Icons.wallet_giftcard, "Wallets"),
                  // _buildDivider(),
                  _buildRow(Icons.share, "Share"),
                  // _buildDivider(),
                  // _buildRow(Icons.feedback, "Rate Us"),
                  _buildDivider(),
                  _buildRow(Icons.help, "Support"),
                  _buildDivider(),
                  // _buildRow(Icons.supervised_user_circle, "Invite Friend"),
                  // _buildDivider(),
                  _buildRow(Icons.logout, "Log out"),
                  _buildDivider(),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: ColorConst.GREY_COLOR,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => _navigateOnNextScreen(title, context),
        child: Row(children: [
          Icon(
            icon,
            color: ColorConst.RED_COLOR,
          ),
          SizedBox(width: 10.0),
          getTxtColor(
              msg: title,
              txtColor: ColorConst.WhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.blue,
              elevation: 2.0,
              // shadowColor: ColorConst.APP_COLOR,
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: 10,
                height: 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorConst.APP_COLOR,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // child: Text(
                //   "10+",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            )
        ]),
      ),
    );
  }

  void _navigateOnNextScreen(String title, context) {
    Navigator.of(_context).pop();
    switch (title) {
      case "Live TV":
        navigationPush(_context, LiveTVDash());
        break;
      // case "My List":
      //   navigationPush(_context, WatchLater());
      //   break;
      case "Kids":
        navigationPush(_context, Animes());
        break;
      case "My Movies":
        navigationPush(_context, MyMovies());
        break;
      case "TV shows":
        navigationPush(_context, TvShows());
        break;

        // case "Category":
        //   navigationPush(_context, CategoryMovie());
        // navigationPush(
        //     _context, MovieListScreen(apiName: ApiConstant.GENRES_LIST));
        break;

      // case "Wallets":
      //   navigationPush(_context, CreditCards());
      //   break;
      case "My music":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BrowseWidget()));

        break;
      // case "Profile":
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      //   break;
      case "Settings":
        navigationPush(_context, SettingScreen());
        break;
      case "Share":
        final RenderBox box = _context.findRenderObject();
        Share.share(
            'https://play.google.com/store/apps/details?id=com.ini.niiflicks',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        break;
      case "Feedback":
        return navigationPush(_context, FeedbackScreen());
        break;
      case "Support":
        return navigationPush(_context, HelpScreen());
        break;
      // case "Invite Friend":
      //   return navigationPush(_context, InviteFriend());
      //   break;
      case "Log out":
        logoutUser();
        return navigationPush(_context, Login());
        break;
    }
  }
}
