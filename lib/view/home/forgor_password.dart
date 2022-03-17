import 'dart:convert';
import 'dart:math';
import 'package:niiflicks/view/home/confirmation_code.dart';
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

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);

  int _start = 10;
  int _current = 10;
  bool started = false;
// for random numbers

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

  //Adding my string to shared prefrence
  addStringToSF(String forgotEmail, String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('forgotEmail', forgotEmail);
    prefs.setString('code', code);
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
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content: Text("Check email for your code"),
      actions: [
        okButton,
      ],
    );
    AlertDialog unsentmessage = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry A Server Error occured"),
      actions: [
        alright,
      ],
    );
    AlertDialog servererror = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry A Server Error occured"),
      actions: [
        alright,
      ],
    );
    int min = 10000; //min and max values act as your 6 digit range
    int max = 99999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);
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
                Icons.email,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(27),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Registered email address",
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
                child: Text("Generate Code".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          //  PinPutTest()
                          ConfirmationCode()));

                  //SAVE THE DATA temporarily on a shared preference to be acessed from other page
                  addStringToSF(emailController.text, rNum.toString());

                  sendMobileData() async {
                    var url = Uri.parse(
                        'https://niiflicks.com/niiflicks/apis/user/forgotpasswordone');
                    var data = {
                      'email': emailController.text,
                      'code': rNum.toString()
                    };
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
                            return alert;
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

                    // sendDetails(context);
                    // _login(context);
                  }

                  sendMobileData();
                })));
    final signIn = Text(
      'Sign up',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    final genCode = Text(
      'Send Code',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    // void notification() {
    //   AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //           id: 10,
    //           channelKey: 'basic_channel',
    //           title: 'Hey there',
    //           body: 'Get the latest movie at your finger tips',
    //           icon: 'ini'));
    // }

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
              //   Padding(
              //   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              //   child: otp,
              // ),
              // SizedBox(height: 20,),
              // Padding(
              //   padding: const EdgeInsets.only(left: 40),
              //   child: Text(' Sending OTP in $_current...',style: TextStyle(color: Colors.white),),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 240),
              //   child: InkWell(
              //     onTap: (){
              //       startTimer();
              //     },
              //     child:Row(
              //       children: [
              //         Icon(Icons.refresh,color: Colors.red),
              //         Text('Send OTP in $_current(s)',style: TextStyle(color: Colors.red),),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
                child:
                    isAuthenticating ? CircularProgressIndicator() : logButton,
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
