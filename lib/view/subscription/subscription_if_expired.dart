import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:niiflicks/view/subscription/subscription1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/users.dart';
import 'dart:math';
import 'package:niiflicks/view/screens/dashboard_screen.dart';

class SubscriptionExpired extends StatefulWidget {
  SubscriptionExpired({Key key}) : super(key: key);
  @override
  _SubscriptionExpiredState createState() => _SubscriptionExpiredState();
}

class _SubscriptionExpiredState extends State<SubscriptionExpired> {
  final _paystackPlugin = PaystackPlugin();
  bool visible = false;
  var publicKey = "pk_live_3eb344779b6325507d74e6d9a9f7afd0760087ef";
  void expired() {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        dialogBackgroundColor: Colors.white,
        title: 'Your subscription has expired',
        desc: 'Kindly re-subscribe',
        btnOkOnPress: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SubscriptionExpired()));
        })
      ..show();
  }

  @override
  void initState() {
    super.initState();
    // expired();
    user();
    _paystackPlugin.initialize(publicKey: publicKey);
  }

  String displayName;
  Future user() async {
    Uri url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/getuserdata');

    final prefs = await SharedPreferences.getInstance();
    displayName = prefs.getString('email');
    var data = {'email': displayName};
    print(data);
    final newUri = url.replace(queryParameters: data);
    print(displayName);
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

  String _getReference() {
    String platform;
    var rng = new Random();
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    var reff =
        "iosChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}" +
            (rng.nextInt(100)).toString();

    return reff;
  }

  _chargeCard(amount, plan, plann) async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // setState(() {
    // displayName = prefs.getString('email');
    // print(displayName);

    print(prefs.getString('email'));

    var reference = _getReference();
    print(reference);
    var charge = Charge()
      ..amount = (amount * 100).toInt()
      ..email = displayName
      // ..email = prefs.getString('email')
      ..reference = reference
      ..plan = plann
      ..card = PaymentCard(
          number: null, cvc: null, expiryMonth: null, expiryYear: null)
      ..putCustomField('Charged From', 'Niiflicks');
    final CheckoutResponse response1 =
        await _paystackPlugin.chargeCard(context, charge: charge);
    print(response1.status);
    visible = false;
    var customeremail = displayName;
    var chosenplan = plan;
    var payment = amount;
    var expirydate;
    var currDt = DateTime.now();
    var year = currDt.year;
    var month = currDt.month;
    var day = currDt.day;

    if (response1.status == true) {
      if (plan == 'monthly') {
        var expirymonth = month + 1;
        if (expirymonth <= 12) {
          expirydate = year.toString() +
              "-" +
              expirymonth.toString() +
              "-" +
              day.toString();
        } else {
          expirydate = (year + 1).toString() +
              "-" +
              (expirymonth - 12).toString() +
              "-" +
              day.toString();
        }

        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': displayName,
          'amount': payment.toString(),
          'expiry': expirydate.toString(),
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          print("success");
          // var newresponse = jsonDecode(response.body)["error"];
          // if (newresponse == false) {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Login()));
          // } else {
          //   print('no amount in account');
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => Subscription()));
          // }
        } else {
          print('failed');
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Subscription()));
        }
        visible = false;
      }
      if (plan == 'biannual') {
        var expirymonth = month + 6;
        if (expirymonth <= 12) {
          expirydate = year.toString() +
              "-" +
              expirymonth.toString() +
              "-" +
              day.toString();
        } else {
          expirydate = (year + 1).toString() +
              "-" +
              (expirymonth - 12).toString() +
              "-" +
              day.toString();
        }
        print(expirydate);
        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': customeremail,
          'amount': payment.toString(),
          'expiry': expirydate.toString(),
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          print(response.body);

          // print('time has passed');
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Login()));

        } else {
          print(response.body);
          // print('money didnt go through');
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Subscription()));
        }
        visible = false;
      }
      if (plan == 'yearly') {
        expirydate = (year + 1).toString() +
            "-" +
            month.toString() +
            "-" +
            day.toString();

        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': customeremail,
          'amount': payment.toString(),
          'expiry': expirydate.toString(),
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          print(response.body);
        } else {
          print(response.body);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Subscription()));
        }
        visible = false;
      }
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          dialogBackgroundColor: Colors.white,
          title: 'Success',
          desc: 'Subscription Successful',
          btnOkOnPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          })
        ..show();
    } else {
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          dialogBackgroundColor: Colors.white,
          title: 'Failed',
          desc: 'Subscription Failed',
          btnOkOnPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Subscription()));
          })
        ..show();
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: Text(
              'Subscription Plans'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red, fontFamily: 'Montserrat-Regular'),
            ),
            elevation: 0,
            bgColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('Sign In'),
              )
            ],
            icon: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.red),
                onPressed: () => Navigator.pop(context))),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              ListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Your 7-Day free trial just expired.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Choose the Best plan that suits you.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                        'NB: Virtual Cards are not supported for payments'),
                  ),
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        )),
                      )),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: InkWell(
                      onTap: () {
                        visible = true;
                        _chargeCard(2000, "monthly", "PLN_s11pwvxrcfma6wh");
                      },
                      child: Container(
                        height: 340,
                        width: 60,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 7,
                          shadowColor: Colors.redAccent,
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Monthly plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '\$4 (~ ₦2,000)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('7 day free trial',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Full HD 1080p',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.tv,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Multiple Users',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Montserrat')),
                                    Text('Ultra HD(4K)',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie_outlined,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text('HDR',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 60,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: InkWell(
                      onTap: () {
                        visible = true;
                        _chargeCard(4000, "biannual", "PLN_p7b2chakk4x36af");
                      },
                      child: Container(
                        height: 340,
                        width: 160,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 7,
                          shadowColor: Colors.redAccent,
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Six Months plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '\$8 (~ ₦4,000)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('7 day free trial',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Full HD 1080p',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.tv,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Multiple Users',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Montserrat')),
                                    Text('Ultra HD(4K)',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie_outlined,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text('HDR',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        )),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: InkWell(
                      onTap: () {
                        visible = true;
                        _chargeCard(7500, "yearly", "PLN_z63phwm3j9si6tj");
                      },
                      child: Container(
                        height: 340,
                        width: 160,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 7,
                          shadowColor: Colors.redAccent,
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '(Recommended)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'Yearly plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '\$15 (~ ₦7,500)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('7 day free trial',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Full HD 1080p',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.tv,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    Text('Multiple Users',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Montserrat')),
                                    Text('Ultra HD(4K)',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.movie_outlined,
                                      size: 21,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text('HDR',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Divider(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }
}
