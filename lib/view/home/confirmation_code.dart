import 'dart:convert';
import 'package:niiflicks/view/home/new_password.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:timer_button/timer_button.dart';
import 'dart:ui';
// import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

import 'package:niiflicks/view/home/reg.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/likemovie/movie_like.dart';
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationCode extends StatefulWidget {
  @override
  _ConfirmationCodeState createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  Future<bool> saveDetails(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    return prefs.commit();
  }

  int _start = 10;
  int _current = 10;
  bool started = false;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    Widget alright = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alertt = AlertDialog(
      title: Text("Notification"),
      content: Text("Otp sent Successfully"),
      actions: [
        alright,
      ],
    );
    AlertDialog unsentmessage = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry A Server Error occured"),
      actions: [
        alright,
      ],
    );
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content:
          Text("Sorry Confirmation code provided does not Match Sent code"),
      actions: [
        alright,
      ],
    );

    verifyOTP() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String otp = prefs.getString('code');
      String mobile = prefs.getString('forgotEmail');
      if (otp == emailController.text) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewPassword()));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    }

    AlertDialog servererror = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry A Server Error occured"),
      actions: [
        alright,
      ],
    );
    sendMobileData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //IF DATA IS SAVED TO temporARY STORAGE PROCEED
      String otp = prefs.getString('otp');
      String mobile = prefs.getString('mobile');
      var url = Uri.parse(
          'https://niiflicks.com/niiflicks/apis/user/forgotpasswordtwo');
      var data = {'mobile': mobile, 'otp': otp};

      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        print(response.body);
        var newresponse = jsonDecode(response.body);

        //do something with the status of
        //if the message sent successfully
        if (newresponse['error'] == "false") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertt;
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return unsentmessage;
            },
          );
        }
      } else {
        //replace with an alert that a server error occured
        print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return servererror;
          },
        );
      }
    }

    final forgotPassword = Text(
      'Resend Code',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    final email = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(27)),
        child: TextField(
          style: style,
          controller: emailController,
          obscureText: false,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.security,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(27),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Enter Confirmation code",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));
    final logButton = Container(
        child: Material(
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(30),
            child: MaterialButton(
              elevation: 7,
              height: 50,
              child: Text("enter code".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                  )),
              onPressed: () {
                verifyOTP();
                // sendDetails(context);
                // _login(context);
              },
            )));
    final signIn = Text(
      'Sign up',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.dstATop,
              ),
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
                child: ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Image.asset('assets/images/Niiflix.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: email,
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
                child:
                    isAuthenticating ? CircularProgressIndicator() : logButton,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(145, 30, 0, 0),
                child: InkWell(
                  child: forgotPassword,
                  onTap: () {
                    sendMobileData();
                  },
                ),
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
