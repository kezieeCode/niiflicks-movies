import 'package:flutter/material.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
// import 'package:niiflicks/view/search/search_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Colors.red,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: 'GoudyHvyface BT'),
        ),
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.search_rounded,
        //         color: Colors.red,
        //       ),
        //       onPressed: () => navigationPush(context, SearchScreen()))
        // ],
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: Container(),
    );
  }
}
