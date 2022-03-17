import 'package:flutter/material.dart';
import 'package:niiflicks/view/home/reg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() => runApp(PinPutTest());

class PinPutTest extends StatefulWidget {
  @override
  PinPutTestState createState() => PinPutTestState();
}

class PinPutTestState extends State<PinPutTest> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final otpController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  int _start = 10;
  int _current = 10;
  bool started = false;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),

      //resend otp function
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

  @override
  Widget build(BuildContext context) {
    Widget alright = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry OTP code provided does not Match Sent OTP"),
      actions: [
        alright,
      ],
    );

    //ALERT DIALOG FOR  SUCCESS RESULT

    AlertDialog alertt = AlertDialog(
      title: Text("Notification"),
      content: Text("Otp sent Successfully"),
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
    AlertDialog unsentmessage = AlertDialog(
      title: Text("Notification"),
      content: Text("Sorry A Server Error occured"),
      actions: [
        alright,
      ],
    );

    verifyOTP() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String otp = prefs.getString('otp');
      String mobile = prefs.getString('mobile');
      if (otp == _pinPutController.text) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    }

    sendMobileData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //IF DATA IS SAVED TO temporARY STORAGE PROCEED
      String otp = prefs.getString('otp');
      String mobile = prefs.getString('mobile');
      var url = Uri.parse('https://niiflicks.com/niiflicks/apis/user/otp.php');
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

    sendMobileData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        hintColor: Colors.green,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Enter OTP',
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      ' OTP in $_current(s)',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(20.0),
                      child: PinPut(
                        fieldsCount: 5,
                        onSubmit: (String pin) => _showSnackBar(pin, context),
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.deepPurpleAccent.withOpacity(.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: const Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // FlatButton(
                        //   onPressed: () => _pinPutFocusNode.requestFocus(),
                        //   child: const Text('Focus'),
                        // ),
                        // FlatButton(
                        //   onPressed: () => _pinPutFocusNode.unfocus(),
                        //   child: const Text('Unfocus'),
                        // ),
                        FlatButton(
                          onPressed: () {
                            // startTimer();
                            sendMobileData();
                          },
                          child: const Text('Tap to resend OTP'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    Container(
                      width: 300,
                      child: Material(
                        color: Colors.red,
                        elevation: 7,
                        shadowColor: Colors.red,
                        child: MaterialButton(
                          onPressed: () {
                            // VERIFY OTP PROCESS CHECK TYPED VALUE AGAINST SENT OTP?
                            verifyOTP();
                            //navigate to register page
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));

                            // _pinPutController
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return alert;
                            //   },
                            // );
                          },
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Container(
        height: 80.0,
        child: Center(
          child: Text(
            'Your Niiflicks Pin: $pin',
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      backgroundColor: Colors.deepPurpleAccent,
    );
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
