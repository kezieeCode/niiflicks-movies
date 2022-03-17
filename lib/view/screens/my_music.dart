import 'package:flutter/material.dart';
import 'package:niiflicks/components/custom_list_tile.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:http/http.dart' as http;

class MyPlayList extends StatefulWidget {
  MyPlayList({Key key}) : super(key: key);

  @override
  _MyPlayListState createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList> {
  Future songs() async {
    var url = Uri.parse('https://api.deezer.com/album/302127');
    var apiKey = '';
    var response = await http.get(url);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          ctx: context,
          bgColor: Colors.black,
          title: Text(
            'My PlayList'.toUpperCase(),
            style:
                TextStyle(color: Colors.red, fontFamily: 'Montserrat-Regular'),
          ),
          icon: IconButton(
              onPressed: () => Navigator.of(context),
              icon: Icon(Icons.arrow_back_ios, color: Colors.red))),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) => Container(
                        child: FlatButton(
                          child: Text('Tap'),
                          onPressed: () {
                            songs();
                          },
                        ),
                      ))),
          Container()
        ],
      ),
    );
  }
}
