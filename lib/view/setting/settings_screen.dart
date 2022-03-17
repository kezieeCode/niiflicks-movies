import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/classes/users.dart';
import 'package:niiflicks/constant/api_constant.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/constant/string_const.dart';
import 'package:niiflicks/utils/sp/sp_manager.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/home/login.dart';
import 'package:niiflicks/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var pushNoti = false;
  var emailNoti = true;
  var darkMode = false;
  String displayName;
  BuildContext ctx;

  @override
  void initState() {
    super.initState();
    darkMode = isDarkMode(context);
    getInfo();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('regemail');
    });
  }

  deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emails = prefs.getString('regemail');
    var passwords = prefs.getString('password');
    var url = 'https://www.niiflicks.com/niiflicks/apis/user/delete_user.php';
    var data = {"email": emails, "password": passwords};
    var uri = Uri.parse(url);
    final newUrl = uri.replace(queryParameters: data);
    var response = await http.get(newUrl);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged');
      await prefs.remove('regemail');
      await prefs.remove('password');

      await Future.delayed(Duration(seconds: 2));

      // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      navigationPush(context, Login());
    } else {
      return showSnackBar(ctx, 'No network connection!!');
    }
  }

  Future user() async {
    Uri url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/getuserdata');

    final prefs = await SharedPreferences.getInstance();
    var emails = prefs.getString('email');
    var data = {'email': emails};
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
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.red,
        ),
        onPressed: () => Navigator.pop(context));
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: Text(
              'Settings'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red, fontFamily: 'Montserrat-Regular'),
            ),
            bgColor: Colors.black,
            icon: homeIcon),
        body: Builder(builder: (_context) {
          return _createUi(_context);
        }));
  }

  Widget _createUi(BuildContext context) {
    ctx = context;
    return Container(
      color: Colors.black,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen())),
            child: Row(
              children: <Widget>[
                FutureBuilder(
                  future: user(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data.profilepicture),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('N/A'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${displayName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      // getTxtColor(
                      //     fontSize: 17,
                      //     msg: StringConst.WEBADDICTED,
                      //     txtColor: ColorConst.GREY_COLOR)
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          getDivider(),
          ListTile(
            title: getTxtBlackColor(
                msg: "Language", fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: "English US",
                fontSize: 15,
                txtColor: ColorConst.GREY_COLOR),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey.shade400,
            ),
            onTap: () {},
          ),
          getDivider(),
          getDivider(),
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen())),
            child: ListTile(
              title: getTxtBlackColor(
                  msg: "User mail", fontSize: 16, fontWeight: FontWeight.bold),
              subtitle: Text('${displayName}',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {},
            ),
          ),
          getDivider(),
          ListTile(
            title: getTxtBlackColor(
                msg: "Clear Data", fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: "Clear your data",
                fontSize: 15,
                txtColor: ColorConst.GREY_COLOR),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey.shade400,
            ),
            onTap: () {
              SPManager.setOnboarding(false);
              showSnackBar(ctx, 'Data clear successfully !!');
            },
          ),
          getDivider(),
          SwitchListTile(
            title: getTxtBlackColor(
                msg: "Email Notifications",
                fontSize: 16,
                fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: 'On', fontSize: 15, txtColor: ColorConst.GREY_COLOR),
            value: emailNoti,
            onChanged: (val) {
              emailNoti = !emailNoti;
              changeData();
            },
          ),
          getDivider(),
          ListTile(
            title: getTxtBlackColor(
                msg: "Delete your account",
                fontSize: 16,
                fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: "Delete account",
                fontSize: 15,
                txtColor: ColorConst.GREY_COLOR),
            trailing: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              deleteUser();
            },
          ),
          getDivider()
        ],
      ),
    );
  }

  void changeData() {
    setState(() {});
  }

// void getThemeData()async {
//   darkMode = ScopedModel.of<ThemeModel>(context).getTheme;
//   changeData();
// }
}
