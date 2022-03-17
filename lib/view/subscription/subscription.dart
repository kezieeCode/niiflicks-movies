import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:niiflicks/payments/payment_forms.dart';

import 'package:niiflicks/utils/widgethelper/widget_helper.dart';

import 'package:niiflicks/view/home/forgor_password.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class Subscription extends StatefulWidget {
  Subscription({Key key}) : super(key: key);

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final _paystackPlugin = PaystackPlugin();

  String _email = 'ikoro@nifexlimited.com';
  int _amount = 600;
  String _message = '';
  // var publicKey = 'pk_live_3eb344779b6325507d74e6d9a9f7afd0760087ef';
  var publicKey = 'pk_live_3eb344779b6325507d74e6d9a9f7afd0760087ef';
  @override
  void initState() {
    super.initState();
    // isAuthenticating = true;
    // isLoading = false;
    _paystackPlugin.initialize(publicKey: publicKey);
  }

  bool isAuthenticating = false;
  String _getReference() {
    var rng = new Random();

    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    var reff =
        'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}' +
            (rng.nextInt(100)).toString();

    return reff;
  }

  _chargeCard(amount, plan) async {
    if (isAuthenticating == true) {
      setState(() {
        isAuthenticating = false;
      });
    } else {
      setState(() {
        isAuthenticating = true;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    var reference = _getReference();
    //take note i hardcoded the card details it shouldn't be so.
    var charge = Charge()
      ..amount = amount * 100
      ..email = prefs.getString('email')
      ..reference = reference
      ..card = PaymentCard(
        number: null,
        cvc: null,
        expiryMonth: null,
        expiryYear: null,
      )
      ..putCustomField('Charged From', 'Niiflicks');
    var customeremail = prefs.getString('regemail');
    var chosenplan = plan;
    var payment = amount;
    var expirydate;
    var currDt = DateTime.now();
    var year = currDt.year;
    var month = currDt.month;
    var day = currDt.day;

    // var plan
    final CheckoutResponse response =
        await _paystackPlugin.chargeCard(context, charge: charge);
    print(response.status);
    if (response.status == true) {
      if (plan == 'monthly') {
        expirydate = year.toString() +
            "-" +
            (month + 1).toString() +
            "-" +
            day.toString();
        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': customeremail,
          'amount': payment.toString(),
          'expiry': expirydate.toString()
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          var newresponse = jsonDecode(response.body)["error"];
          if (newresponse == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          } else {
            print('no amount in account');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Subscription()));
          }
        } else {
          print('money didnt go through');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Subscription()));
        }
      }
      if (plan == 'quaterly') {
        expirydate = year.toString() +
            "-" +
            (month + 1).toString() +
            "-" +
            day.toString();
        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': customeremail,
          'amount': payment.toString(),
          'expiry': expirydate.toString()
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          var newresponse = jsonDecode(response.body)["error"];
          if (newresponse == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          } else {
            print('no amount in account');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Subscription()));
          }
        } else {
          print('money didnt go through');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Subscription()));
        }
      }
      if (plan == 'yearly') {
        expirydate = year.toString() +
            "-" +
            (month + 1).toString() +
            "-" +
            day.toString();
        var url = Uri.parse(
            'https://niiflicks.com/niiflicks/apis/user/pushpayment.php');
        var data = {
          'plan': chosenplan,
          'email': customeremail,
          'amount': payment.toString(),
          'expiry': expirydate.toString()
        };
        print(data);
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          var newresponse = jsonDecode(response.body)["error"];
          if (newresponse == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Subscription()));
          }
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Subscription()));
        }
      } else {
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
          'amount': payment,
          'expiry': expirydate
        };
        var response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          var newresponse = jsonDecode(response.body)["error"];
          if (newresponse.error == false) {
            // prefs.setString("logged", "logged");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          } else {
            // prefs.setString("logged", "logged");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Subscription()));
          }
        } else {
          // prefs.setString("logged", "logged");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Subscription()));
        }
      }
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final snacks = SnackBar(
      content: const Text('NB: Virtual Cards are not supported for payments'),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 20),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          ctx: context,
          title: Text(
            'Subscription Plans'.toUpperCase(),
            style:
                TextStyle(color: Colors.red, fontFamily: 'Montserrat-Regular'),
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
            // Positioned(
            //   top: 100,
            //   bottom: 100,
            //   left: 50,
            //   right: 50,
            //   child: Visibility(
            //       maintainSize: true,
            //       maintainAnimation: true,
            //       maintainState: true,
                  // visible: isAuthenticating,
            //       child: Padding(
            //         padding: const EdgeInsets.fromLTRB(100, 100, 100, 0),
            //         child: Container(
            //           color: Colors.black,
            //           child: JumpingDotsProgressIndicator(
            //             numberOfDots: 3,
            //             color: Colors.red,
            //             fontSize: 100.0,
            //           ),
            //         ),
            //       )),
            // ),
            ListView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    'Final Step.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Montserrat'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    'Choose the Best plan that suits you.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child:
                      Text('NB: Virtual Cards are not supported for payments'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: InkWell(
                    onTap: () {
                      _chargeCard(2064, 'monthly');
                    },
                    child: Container(
                      height: 300,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                      _chargeCard(4168, 'quaterly');
                    },
                    child: Container(
                      height: 300,
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
                                      // Text(
                                      //   '(Recommended)',
                                      //   style: TextStyle(
                                      //       color: Colors.white,
                                      //       fontFamily: 'Montserrat',
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontStyle: FontStyle.italic),
                                      // ),
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: InkWell(
                    onTap: () {
                      _chargeCard(7700, 'yearly');
                    },
                    child: Container(
                      height: 300,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                      style:
                                          TextStyle(fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Divider(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Visibility(
                //     maintainSize: true,
                //     maintainAnimation: true,
                //     maintainState: true,
                //     visible: isAuthenticating,
                //     child: Padding(
                //       padding: const EdgeInsets.fromLTRB(100, 100, 100, 0),
                //       child: Row(
                //         children: [
                //           Text(
                //             'Payment is validating',
                //             style: TextStyle(
                //               fontStyle: FontStyle.italic,
                //             ),
                //           ),
                //           JumpingDotsProgressIndicator(
                //             numberOfDots: 5,
                //             color: Colors.red,
                //             fontSize: 30.0,
                //           )
                //         ],
                //       ),
                //     )),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                //   child: Material(
                //     elevation: 4,
                //     shadowColor: Colors.red[900],
                //     color: Colors.red,
                //     child: MaterialButton(
                //       onPressed: () {
                //         if (isAuthenticating == true) {
                //           setState(() {
                //             isAuthenticating = false;
                //           });
                //         } else {
                //           setState(() {
                //             isAuthenticating = true;
                //           });
                //         }
                //       },
                //       child: Text(
                //         'Continue',
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontFamily: 'Montserrat',
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // )
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
    );
  }
}
