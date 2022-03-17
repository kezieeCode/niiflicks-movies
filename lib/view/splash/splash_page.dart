import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:niiflicks/constant/assets_const.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/utils/sp/sp_manager.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/verify_auth.dart';
// import 'package:niiflicks/view/home/email.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niiflicks/view/home/login.dart';

import 'package:niiflicks/view/intro/intro_screen.dart';
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:niiflicks/view/video/video_player.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  var _visible = false;

  _check() async {
    final prefs = await SharedPreferences.getInstance();
    var expirydate = prefs.getString("expirydate");
    var expirytrial = prefs.getString("expirytrial");
    var now = DateTime.now();

    String year1 = expirytrial.split("-")[0];
    String month1 = expirytrial.split("-")[1];
    String day1 = expirytrial.split("-")[2];

    String year = expirydate.split("-")[0];
    String month = expirydate.split("-")[1];
    String day = expirydate.split("-")[2];

    final today = DateTime(now.year, now.month, now.day);
    final expirationDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    final expirationTrial =
        DateTime(int.parse(year1), int.parse(month1), int.parse(day1));
    if (expirationDate == null && expirationTrial == null) {
      print('nothing1');
    } else if (expirationDate == null) {
      print('nothing2');
      final bool isExpired = expirationTrial.isBefore(today);
      if (isExpired) {
        print('nothing3');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        print('nothing4');
        final bool isExpired = expirationDate.isBefore(today);
        if (isExpired) {
          print('nothing5');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
      }
    } else {
      print('nothing');
    }
  }

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool areulogged = false;

    if (prefs.getString("logged") != null) {
      areulogged = true;
    }
    var isOnboardingShow = await SPManager.getOnboarding();
    Future.delayed(const Duration(seconds: 4), () {
      // if (isOnboardingShow)
      if (areulogged == true) {
        print('henryhenryhenry');

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VerifyAuth()));
      }

      // navigationPushReplacement(
      //     context,
      //     isOnboardingShow != null && isOnboardingShow
      // ? Login()
      //         : IntroScreen());
      // else
      //   navigationPush(context, IntroScreen());
    });
  }

  @override
  void initState() {
    disableCapture();
    super.initState();
    // _check();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 3));
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.decelerate);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorConst.WHITE_COLOR,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.dstATop,
            ),
            image: AssetImage('assets/images/collage.jpg'),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 250,
                      height: 250, //Adapt.px(500),
                      child: Image.asset('assets/images/Niiflix.png')),
                  SizedBox(height: 180),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: JumpingDotsProgressIndicator(
                        numberOfDots: 5,
                        color: Colors.red,
                        fontSize: 100.0,
                        // valueColor:
                        //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
