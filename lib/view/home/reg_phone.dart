import 'dart:ui';
import 'dart:convert';

import 'package:niiflicks/view/home/reg.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:niiflicks/view/otp/otp_config.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PhoneReg extends StatefulWidget {
  PhoneReg({Key key}) : super(key: key);

  @override
  _PhoneRegState createState() => _PhoneRegState();
}

class _PhoneRegState extends State<PhoneReg> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //  String phoneNumber;
  // String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';

  //OTP AND MOBILE

  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  //  void onPhoneNumberChange(
  //     String number, String internationalizedPhoneNumber, String isoCode) {
  //   print(number);
  //   setState(() {
  //     phoneNumber = number;
  //     phoneIsoCode = isoCode;
  //   });
  // }

  //SAVE THE MOBILE DATA AND THE OTP TO BE SENT IN A TEMPORARY STORAGE
  addStringToSF(String mobile, String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', mobile);
    prefs.setString('otp', otp);
  }

  @override
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  Widget build(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget alright = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //CREATE RANDOM NUMBER
    int min = 10000; //min and max values act as your 6 digit range
    int max = 99999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    //ALERT DIALOG FOR  SUCCESS RESULT

    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content: Text("Otp sent Successfully"),
      actions: [
        okButton,
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

    final logButton = Container(
        child: Material(
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              elevation: 7,
              height: 60,
              child: Text("verify".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Oswald',
                    fontSize: 20,
                  )),
              onPressed: () {
                //SAVE THE DATA temporarily on a shared preference to be acessed from other page
                addStringToSF(mobileController.text, rNum.toString());

                sendMobileData() async {
                  //IF DATA IS SAVED TO temporARY STORAGE PROCEED
                  var url = Uri.parse(
                      'https://niiflicks.com/niiflicks/apis/user/otp.php');
                  var data = {
                    'mobile': mobileController.text,
                    'otp': rNum.toString()
                  };

                  var response = await http.post(url, body: data);
                  if (response.statusCode == 200) {
                    print(response.body);
                    var newresponse = jsonDecode(response.body);

                    //do something with the status of
                    //if the message sent successfully
                    if (newresponse['error'] == "false") {
                      var checkCountry = newresponse['country_code'];
                      //   Navigator.of(context).push(MaterialPageRoute(
                      // builder: (context) =>
                      //     //  PinPutTest()
                      //     PinPutTest()));
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return alert;
                      //     },
                      //   );
                      if (checkCountry == 'nigerian') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                //  PinPutTest()
                                PinPutTest()));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else if (checkCountry == 'non_nigerian') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      }
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

                //SEND OTP TO USER AFTER BUTTON IS PRESSED

                // _login(context);
              },
            )));
    final pNumber = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child:
            //  InternationalPhoneInput(
            //     decoration: InputDecoration.collapsed(hintText: '(416) 123-4567'),
            //     onPhoneNumberChange: onPhoneNumberChange,
            //     initialPhoneNumber: phoneNumber,
            //     initialSelection: phoneIsoCode,
            //     enabledCountries: ['+233', '+1'],
            //     showCountryCodes: true
            //  ),
            Form(
          key: formKey,
          child: TextFormField(
            controller: mobileController,
            style: style,
            keyboardType: TextInputType.number,
            // controller: emailController,
            obscureText: false,
            validator: MinLengthValidator(9,
                errorText: 'Input correct number with country code'),
            decoration: InputDecoration(
                enabled: true,
                contentPadding: EdgeInsets.all(20),
                // prefixIcon: CountryCodePicker(
                //   textStyle: TextStyle(color: Colors.red),
                //   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                //   initialSelection: 'US',
                //   favorite: ['+1', 'US'],
                //   // optional. Shows only country name and flag
                //   showCountryOnly: false,
                //   // optional. Shows only country name and flag when popup is closed.
                //   showOnlyCountryWhenClosed: false,
                //   // optional. aligns the flag and the Text left
                //   alignLeft: false,
                // ),
                // Icon(
                //   Icons.phone_android,
                //   color: Colors.red[900],
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                hintText: "234800000000",
                hintStyle: TextStyle(color: Colors.red),
                border: OutlineInputBorder()),
          ),
        ));
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
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
                child: pNumber,
              ),
              // SizedBox(
              //   height: 0,
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              //   child: pass,
              // ),
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
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
              //   child: isAuthenticating?CircularProgressIndicator():logButton,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
                child: logButton,
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  )),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(170, 30, 0, 0),
              //   child: InkWell(
              //     child: signIn,
              //     onTap: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => Login()));
              //     },
              //   ),
              // ),
            ])),
          ),
        ),
      ),
    );
  }
}
