import 'package:niiflicks/classes/users.dart';
import 'package:niiflicks/constant/api_constant.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/constant/string_const.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/screens/change_profile_pics.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BuildContext _context;
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
          Icons.arrow_back_ios, //menu,//dehaze,
          color: ColorConst.WHITE_ORIG_COLOR,
        ),
        onPressed: () => Navigator.of(_context).pop());
    return Scaffold(
        backgroundColor: ColorConst.WHITE_BG_COLOR,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: homeIcon,
        ),
        body: Builder(
          builder: (context) => _createUi(context),
        ));
  }

  Widget _createUi(BuildContext context) {
    _context = context;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: user(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'no data found',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ProfileHeader(
                    avatar: NetworkImage(snapshot.data.profilepicture),
                    coverImage: NetworkImage(snapshot.data.profilepicture),
                    actions: <Widget>[
                      MaterialButton(
                          color: ColorConst.BLACK_COLOR,
                          shape: CircleBorder(),
                          elevation: 0,
                          child: Icon(
                            Icons.edit,
                            color: ColorConst.WhiteColor,
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SampleScreen())))
                      // showSnackBar(_context, 'Comming Soon'),
                    ],
                  );
                } else {
                  return Center(
                      child: JumpingDotsProgressIndicator(
                    numberOfDots: 5,
                    color: Colors.red,
                    fontSize: 100.0,
                    // valueColor:
                    //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
                  ));
                }
              }),
          const SizedBox(height: 10.0),
          UserInfo(),
        ],
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String email = "";
  String mobile = "";
  String fullname = "";
  String gender = "";
  Future getInfo() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/getuserdata');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return UsersInfo.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('There was no internet connection');
    }
  }

  @override
  void initState() {
    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      mobile = prefs.getString('mobile');
      fullname = prefs.getString('fullname');
      gender = prefs.getString('gender');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "User Information",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                              leading: Icon(Icons.email),
                              title: getTxt(msg: "Email"),
                              subtitle: Text(email)),
                          // ListTile(
                          //   leading: Icon(Icons.phone),
                          //   title: getTxt(msg: "Phone"),
                          //   subtitle: Text("mobile"),
                          // ),
                          // ListTile(
                          //   leading: Icon(Icons.my_location),
                          //   title: getTxt(msg: "Location"),
                          //   subtitle: getTxt(msg: "Aba, Nigeria"),
                          // ),
                          // ListTile(
                          //   leading: Icon(Icons.web),
                          //   title: getTxt(msg: "Website"),
                          //   subtitle: getTxt(msg: "https://www.niiflicks.com"),
                          // ),
                          // ListTile(
                          //   leading: Icon(Icons.calendar_view_day),
                          //   title: getTxt(msg: "Joined Date"),
                          //   subtitle: getTxt(msg: "12 January 2021"),
                          // ),
                          // ListTile(
                          //   leading: Icon(Icons.person),
                          //   title: getTxt(msg: "About Me"),
                          //   subtitle: getTxt(
                          //       msg:
                          //           "This is a about me link and you can khow about me in this section."),
                          // ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;

  final List<Widget> actions;

  const ProfileHeader(
      {Key key, this.coverImage, @required this.avatar, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 210),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              // getTxtBlackColor(
              //   msg: title,
              //   fontSize: 18,
              //   fontWeight: FontWeight.bold,
              // ),
              // if (subtitle != null) ...[
              //   const SizedBox(height: 5.0),
              //   getTxtColor(
              //       msg: subtitle, fontSize: 17, txtColor: ColorConst.GREY_800),
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}
