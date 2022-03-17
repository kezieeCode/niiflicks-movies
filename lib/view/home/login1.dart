import 'dart:convert';
import 'package:niiflicks/payments/payment_forms.dart';
import 'package:niiflicks/view/home/forgor_password.dart';
import 'package:niiflicks/view/home/reg_phone.dart';
import 'package:niiflicks/view/subscription/subscription1.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
// import 'package:niiflicks/view/home/reg_phone.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:timer_button/timer_button.dart';
import 'dart:ui';
// import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
// import 'package:niiflicks/view/home/home_screen.dart';
import 'package:niiflicks/view/home/reg.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/likemovie/movie_like.dart';
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // Future<bool> saveDetails(String usersInfo) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList('users', ['userid', 'email', 'fullname']);
  //   return prefs.commit();
  // }

  Future sendDetails(BuildContext context) async {
    String email = emailController.text;
    // saveDetails(email).then((bool committed) => _login(context));
  }

  Future _login(
    BuildContext context,
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
    Widget login = FlatButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MovieLikeScreen()));
        },
        child: Text('OK'));
    Widget allowButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('OK'),
    );
    Widget cancelButton = FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel'));
    // final alert = SuccessAlertBox(
    //     context: context,
    //     title: 'Welcome back',
    //     messageText: 'Get thrilled by the latest movie and have fun');
    // AlertDialog(
    //   title: Text('You are Logged in'),
    //   content: Text('Go ahead and watch movies'),
    //   actions: [login, cancelButton],
    // );
    AlertDialog alert1 = AlertDialog(
      title: Text('Incorrect details'),
      content: Text('Your username and password is not correct check properly'),
      actions: [allowButton, cancelButton],
    );

    //getting values from controllers
    bool isAuthenticating;
    String email = emailController.text;
    String password = passwordController.text;

    var url = Uri.parse('https://niiflicks.com/niiflicks/loginuser.php');
    var data = {'email': email, 'password': password};
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var newresponse = jsonDecode(response.body)["error"];
      var anotherResponse = jsonDecode(response.body)["data"];

      print(response.body);
      if (newresponse == false) {
        var fetchMessage = anotherResponse;
        if (fetchMessage['paymenttype'].trim() == "") {
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.INFO,
              dialogBackgroundColor: Colors.white,
              title: 'You havent made payment',
              desc: 'Your one stop to unending thrilling entertainment',
              btnOkOnPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Subscription()));
              })
            ..show();
        } else {
          final now = DateTime.now();

          String expirydate = fetchMessage['expirydate'];

          String year = expirydate.split("-")[0];
          print(year);
          String month = expirydate.split("-")[1];
          // print(month);
          String day = expirydate.split("-")[2];
          // print(day);
          final today = DateTime(now.year, now.month, now.day);
          final expirationDate =
              DateTime(int.parse(year), int.parse(month), int.parse(day));
          print(expirationDate);

          final bool isExpired = expirationDate.isBefore(today);
          print(isExpired);
          if (fetchMessage['paymenttype'].trim() == "monthly") {
            print(fetchMessage);
            if (isExpired == false) {
              final prefs = await SharedPreferences.getInstance();
              var userid = fetchMessage['id'];
              prefs.setString('userid', userid);
              var email = fetchMessage['email'];
              prefs.setString('email', email);
              var fullname = fetchMessage['fullname'];
              prefs.setString('fullname', fullname);
              // var mobile = fetchMessage['mobile'];
              // prefs.setString('mobile', mobile);
              var gender = fetchMessage['gender'];
              prefs.setString('gender', gender);
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.SUCCES,
                  dialogBackgroundColor: Colors.white,
                  title: 'Welcome to Niiflicks',
                  desc: 'Your one stop to unending thrilling entertainment',
                  btnOkOnPress: () {
                    prefs.setString("logged", "logged");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()));
                  })
                ..show();
            } else {
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.SUCCES,
                  dialogBackgroundColor: Colors.white,
                  title: 'Your monthly subscription has expired',
                  desc: 'Kindly re-subscribe',
                  btnOkOnPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Subscription()));
                  })
                ..show();
            }
          } else if (fetchMessage['paymenttype'].trim() == "yearly") {
            if (isExpired == false) {
              final prefs = await SharedPreferences.getInstance();
              var userid = fetchMessage['id'];
              prefs.setString('userid', userid);
              var email = fetchMessage['email'];
              prefs.setString('email', email);
              var fullname = fetchMessage['fullname'];
              prefs.setString('fullname', fullname);
              var mobile = fetchMessage['mobile'];
              prefs.setString('mobile', mobile);
              var gender = fetchMessage['gender'];
              prefs.setString('gender', gender);
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.SUCCES,
                  dialogBackgroundColor: Colors.white,
                  title: 'Welcome to Niiflicks',
                  desc: 'Your one stop to unending thrilling entertainment',
                  btnOkOnPress: () {
                    prefs.setString("logged", "logged");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()));
                  })
                ..show();
            } else {
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.WARNING,
                  dialogBackgroundColor: Colors.white,
                  title: 'Expired Subscribption',
                  desc: 'Your yearly subscription has expired',
                  btnOkOnPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Subscription()));
                  })
                ..show();
            }
          } else {
            AwesomeDialog(
                context: context,
                animType: AnimType.LEFTSLIDE,
                headerAnimationLoop: false,
                dialogType: DialogType.INFO,
                dialogBackgroundColor: Colors.white,
                title: 'You havent made payment',
                desc: 'Your one stop to unending thrilling entertainment',
                btnOkOnPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Subscription()));
                })
              ..show();
          }

          // var fetchMessage = newresponse;
          // final now = DateTime.now();

          // String expirydate = fetchMessage['expirydate'];
          // String year = expirydate.split("-")[0];
          // // print(year);
          // String month = expirydate.split("-")[1];
          // // print(month);
          // String day = expirydate.split("-")[2];
          // // print(day);
          // final expirationDate =
          //     DateTime(int.parse(year), int.parse(month), int.parse(day));
          // final bool isExpired = expirationDate.isBefore(now);
          // // print(isExpired);
          // // print(expirydate);

          // if (fetchMessage['paymenttype'] == "monthly") {
          //   if (isExpired == true) {
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.ERROR,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Expiried subscription',
          //         desc: 'Your monthly Subscription just expired',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => Payment()));
          //         })
          //       ..show();
          //   } else if (isExpired == false) {
          //     final prefs = await SharedPreferences.getInstance();
          //     var userid = fetchMessage['id'];
          //     prefs.setString('userid', userid);
          //     var email = fetchMessage['email'];
          //     prefs.setString('email', email);
          //     var fullname = fetchMessage['fullname'];
          //     prefs.setString('fullname', fullname);
          //     var mobile = fetchMessage['mobile'];
          //     prefs.setString('mobile', mobile);
          //     var gender = fetchMessage['gender'];
          //     prefs.setString('gender', gender);
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.SUCCES,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Welcome to Niiflicks',
          //         desc: 'Your one stop to unending thrilling entertainment',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => DashboardScreen()));
          //         })
          //       ..show();
          //   } else {
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.ERROR,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Payment error'.toUpperCase(),
          //         desc: 'Check your details properly to be sure that its correct',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => Payment()));
          //         })
          //       ..show();
          //   }
          // } else if (fetchMessage['paymenttype'] == "yearly") {
          //   if (isExpired == true) {
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.ERROR,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Expiried subscription',
          //         desc: 'Your monthly Subscription just expired',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => Payment()));
          //         })
          //       ..show();
          //   } else if (isExpired == false) {
          //     final prefs = await SharedPreferences.getInstance();
          //     var userid = fetchMessage['id'];
          //     prefs.setString('userid', userid);
          //     var email = fetchMessage['email'];
          //     prefs.setString('email', email);
          //     var fullname = fetchMessage['fullname'];
          //     prefs.setString('fullname', fullname);
          //     var mobile = fetchMessage['mobile'];
          //     prefs.setString('mobile', mobile);
          //     var gender = fetchMessage['gender'];
          //     prefs.setString('gender', gender);
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.SUCCES,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Welcome to Niiflicks',
          //         desc: 'Your one stop to unending thrilling entertainment',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => DashboardScreen()));
          //         })
          //       ..show();
          //   } else {
          //     AwesomeDialog(
          //         context: context,
          //         animType: AnimType.LEFTSLIDE,
          //         headerAnimationLoop: false,
          //         dialogType: DialogType.ERROR,
          //         dialogBackgroundColor: Colors.white,
          //         title: 'Payment error'.toUpperCase(),
          //         desc: 'Check your details properly to be sure that its correct',
          //         btnOkOnPress: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => Payment()));
          //         })
          //       ..show();
          //   }
          // } else {
          //   AwesomeDialog(
          //       context: context,
          //       animType: AnimType.LEFTSLIDE,
          //       headerAnimationLoop: false,
          //       dialogType: DialogType.ERROR,
          //       dialogBackgroundColor: Colors.white,
          //       title: 'No records found',
          //       desc: 'Make payments',
          //       btnOkOnPress: () {
          //         Navigator.push(
          //             context, MaterialPageRoute(builder: (context) => Payment()));
          //       })
          //     ..show();
          // }
          // } else {
          //   AwesomeDialog(
          //       context: context,
          //       animType: AnimType.LEFTSLIDE,
          //       headerAnimationLoop: false,
          //       dialogType: DialogType.ERROR,
          //       dialogBackgroundColor: Colors.white,
          //       title: 'No internet connection',
          //       desc: 'Check internet connection',
          //       btnOkOnPress: () {
          //         Navigator.push(
          //             context, MaterialPageRoute(builder: (context) => Payment()));
          //       })
          //     ..show();
          // }

          // if (response.statusCode == 200) {
          //   print(response.body);
          //   setState(() {
          //     _isAuthenticating = false;
          //   });
          //   var newresponse = jsonDecode(response.body)["data"];
          //   print(newresponse);
          // var fetchMessage = newresponse;

          // // print(fetchMessage['email']);
          // if (fetchMessage == 'true') {
          //   print(fetchMessage);
          // } else {
          //   print(fetchMessage);
          // }

          // if (fetchMessage == true) {
          //   AwesomeDialog(
          //       context: context,
          //       animType: AnimType.LEFTSLIDE,
          //       headerAnimationLoop: false,
          //       dialogType: DialogType.ERROR,
          //       dialogBackgroundColor: Colors.white,
          //       title: 'Check Details properly',
          //       desc: 'Check your details properly to be sure that its correct',
          //       btnOkOnPress: () {
          //         Navigator.push(
          //             context, MaterialPageRoute(builder: (context) => Login()));
          //       })
          //     ..show();
          // } else {

          // AwesomeDialog(
          //     context: context,
          //     animType: AnimType.LEFTSLIDE,
          //     headerAnimationLoop: false,
          //     dialogType: DialogType.SUCCES,
          //     dialogBackgroundColor: Colors.white,
          //     title: 'Welcome back',
          //     desc: 'Get occupied by thrilling movies at your finger tips',
          //     btnOkOnPress: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => DashboardScreen()));
          //     })
          //   ..show();
          // }

          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return alert;
          //     });
          // } else {
          //   print(response.body);
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return alert1;
          //       });
          // }
        }
      } else {
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
      }
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
    final email = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(30)),
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
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));
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
        child: TextField(
          style: style,
          controller: passwordController,
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
        ));

    final logButton = Container(
        child: Material(
            shadowColor: Colors.red,
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(30),
            child: MaterialButton(
              elevation: 7,
              height: 60,
              child: Text("LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Oswald',
                    fontSize: 20,
                  )),
              onPressed: () {
                _login(context);
              },
            )));
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
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
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: pass,
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
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
                child: logButton,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(170, 30, 0, 0),
                child: InkWell(
                  child: signIn,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhoneReg()));
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(145, 30, 0, 0),
                child: InkWell(
                  child: forgotPassword,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
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
