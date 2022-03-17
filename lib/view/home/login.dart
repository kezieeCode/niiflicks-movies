import 'dart:convert';
import 'package:niiflicks/payments/payment_forms.dart';
import 'package:niiflicks/view/home/forgor_password.dart';
import 'package:niiflicks/view/home/reg_phone.dart';
import 'package:niiflicks/view/subscription/subscription1.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:quiver/async.dart';
// import 'package:flutter_autofill/flutter_autofill.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:timer_button/timer_button.dart';
import 'dart:ui';
import 'package:niiflicks/view/home/reg.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/likemovie/movie_like.dart';
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isAuthenticating = false;
  int _state = 0;
  bool visible = false;
  @override
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);

  Future sendDetails(BuildContext context) async {
    String email1 = emailController.text;
  }
  // @override
  // Widget build(BuildContext context){
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //   child: child, onWillPop: onWillPop)
  // }

  Future _login(
      // BuildContext context,
      ) async {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }

    //getting values from controllers
    bool isAuthenticating;
    String email1 = emailController.text;
    String password = passwordController.text;

    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/loginuser.php');
    var data = {'email': email1, 'password': password};
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print('things');
      print(data);
      var newresponse = jsonDecode(response.body)["error"];
      print(newresponse);
      if (newresponse == true) {
        print('nothing');

        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.ERROR,
            dialogBackgroundColor: Colors.white,
            title: 'Check details properly',
            desc: 'Incorrect username or password',
            btnOkOnPress: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            })
          ..show();
      } else if (newresponse == false) {
        final prefs = await SharedPreferences.getInstance();
        print('news');

        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            dialogBackgroundColor: Colors.white,
            title: 'Welcome to Niiflicks',
            desc: 'Enjoy Unlimited Content!',
            btnOkOnPress: () {
              prefs.setString("logged", "logged");
              prefs.setString('regemail', emailController.text);
              prefs.setString('password', passwordController.text);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            })
          ..show();
      }
    } else {
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          dialogBackgroundColor: Colors.white,
          title: 'Server error',
          desc: 'Server is on downtime',
          btnOkOnPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          })
        ..show();
    }
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
    bool isChecked = true;
    void toggleCheckbox(bool value) {
      if (isChecked == false) {
        setState(() {
          isChecked = false;
        });
      } else {
        setState(() {
          isChecked = false;
        });
      }
    }

    final email = Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        style: style,
        controller: emailController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
            enabled: true,
            contentPadding: EdgeInsets.all(20),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.red[900],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            // autoFillHints:
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.red),
            border: OutlineInputBorder()),
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            return 'Enter a valid email';
          else
            return null;
        },
      ),
    );
    final otp = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          style: style,
          keyboardType: TextInputType.number,
          // controller: emailController,
          obscureText: false,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.security,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "OTP code",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));

    final pass = Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        style: style,
        controller: passwordController,
        autofillHints: [AutofillHints.password],
        obscureText: true,
        decoration: InputDecoration(
            enabled: true,
            contentPadding: EdgeInsets.all(20),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.red[900],
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            hintText: "password",
            hintStyle: TextStyle(color: Colors.red),
            border: OutlineInputBorder()),
      ),
    );

    final logButton = Container(
        child: Material(
            shadowColor: Colors.red,
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(30),
            child: MaterialButton(
              elevation: 7,
              height: 40,
              child: Text("LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Oswald',
                    fontSize: 18,
                  )),
              onPressed: () {
                _login();
              },
            )));
    final signUp = Container(
        child: Material(
            shadowColor: Colors.red,
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(30),
            child: MaterialButton(
              elevation: 7,
              height: 40,
              child: Text("SIGN UP",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Oswald',
                    fontSize: 18,
                  )),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
            )));
    final logHelp = InkWell(
        onTap: () {
          launch("https://wa.me/+2349011145523");
        },
        child: Text("Help?",
            style: TextStyle(
                color: Colors.red[700],
                fontSize: 17,
                fontWeight: FontWeight.bold)));
    final signIn = Text(
      'Sign up',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    final forgotPassword = Text(
      'Forgot password',
      style: TextStyle(
          color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.bold),
    );
    bool commited = false;
    return WillPopScope(
      onWillPop: () async => false,
      // Column: Padding(
      //       padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
      //       child: logHelp,
      //     ),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   // leading: logHelp,
        //   // elevation: 0,
        //   // actions: [logHelp],
        // ),
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
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: pass,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        toggleCheckbox(value);
                      },
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      tristate: false,
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Center(
                    child: JumpingDotsProgressIndicator(
                      numberOfDots: 5,
                      color: Colors.red,
                      fontSize: 50.0,
                      // valueColor:
                      //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: logButton,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: signUp,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    logHelp,
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: forgotPassword,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                    ),
                  ],
                ),
              ),
            ])),
          ),
        ),
      ),
    );
  }
}
