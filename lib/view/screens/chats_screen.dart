import 'package:flutter/material.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          ctx: context,
          title: Text(
            'Discussions'.toUpperCase(),
            style:
                TextStyle(color: Colors.red, fontFamily: 'Montserrat-Regular'),
          ),
          bgColor: Colors.black,
          icon: IconButton(
              onPressed: () => Navigator.of(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ))),
      body: Container(
        child: Column(
          children: [Expanded(child: Container())],
        ),
      ),
    );
  }
}
