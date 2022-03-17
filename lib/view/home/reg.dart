import 'dart:convert';
// import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:niiflicks/payments/payment_forms.dart';
// import 'package:niiflicks/view/subscription/subscription.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strengthpassword/strengthpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:niiflicks/view/subscription/subscription1.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate() {
    if (formKey.currentState.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: WebView(
          initialUrl: 'https://niiflicks.com/tandc.html',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.red,
      backgroundColor: Colors.black,
    );
  }

  var expirytrial;

  final emil = TextEditingController();
  final pass1 = TextEditingController();
  final password2 = TextEditingController();
  final lastName = TextEditingController();
  final fullName = TextEditingController();
  final referral = TextEditingController();
  bool visible = false;
  bool _isAuthenticating = true;
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  Future reg(BuildContext context) async {
    print('has been tapped');
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
    String emails = emil.text;
    String password = pass1.text;

    String lastname = lastName.text;
    String firstName = fullName.text;
    String Referal = referral.text;
    final prefs = await SharedPreferences.getInstance();
    var url = 'https://niiflicks.com/niiflicks/apis/user/register.php';
    var newUrl = Uri.parse(url);
    var data = {
      'email': emails,
      'password': password,
      'lastname': lastname,
      'firstname': firstName,
    };
    var response = await http.post(newUrl, body: data);
    var newresponse = jsonDecode(response.body)["error"];
    if (response.statusCode == 200) {
      print(response.body);
      if (newresponse == "false") {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            dialogBackgroundColor: Colors.white,
            title: 'Welcome to Niiflicks',
            desc: 'Enjoy sweet interesting movies',
            btnOkOnPress: () {
              prefs.setString('regemail', emil.text);
              prefs.setString("logged", "logged");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            })
          ..show();
      } else if (newresponse == "true") {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.INFO,
            dialogBackgroundColor: Colors.white,
            title: 'User Already exist',
            desc: 'try using another information',
            btnOkOnPress: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Register()));
            })
          ..show();
      }
    } else {
      print(response.body);
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO_REVERSED,
          dialogBackgroundColor: Colors.white,
          title: 'Server failure',
          desc: 'Kindly wait while we fix the server',
          btnOkOnPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()));
          })
        ..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _groupvalue = false;
    bool isChecked = true;
    void toggleCheckbox(bool value) {
      if (isChecked == false) {
        setState(() {
          isChecked = true;
        });
      } else {
        setState(() {
          isChecked = true;
        });
      }
    }

    final email = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: emil,
            style: style,
            obscureText: false,
            decoration: InputDecoration(
                enabled: true,
                contentPadding: EdgeInsets.all(20),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.red[900],
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.red),
                border: OutlineInputBorder()),
            validator: EmailValidator(errorText: 'Incorrect mail'),
          ),
        ));
    final fName = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: fullName,
          style: style,
          obscureText: false,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "First name",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));
    final phoneNumber = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          // controller: emil,
          style: style,
          obscureText: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Phone Number",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));
    final LName = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: lastName,
          style: style,
          obscureText: false,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.person_add,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Last name",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));

    final pass = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: pass1,
          style: style,
          obscureText: true,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
          validator: MinLengthValidator(8, errorText: 'Minimum of 8 Charaters'),
        ));
    final pass2 = Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: password2,
          style: style,
          obscureText: true,
          decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.red[900],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              hintText: "Confirm Password",
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder()),
        ));

    final logButton = Container(
        child: Material(
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              elevation: 7,
              hoverElevation: 12.0,
              height: 60,
              child: Text("submit".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Oswald',
                    fontSize: 20,
                  )),
              onPressed: () {
                _isAuthenticating = true;
                reg(context);
              },
            )));
    final signIn = FlatButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login())),
        child: Text(
          'Log in',
          style: TextStyle(
              color: Colors.red[700],
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ));
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
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Container(
                      height: 80,
                      child: Image.asset(
                        'assets/images/Niiflix.png',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: fName,
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: LName,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: email,
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                //   child: phoneNumber,
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: pass,
                ),

                //  Row(
                //    crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     ListTile(
                //       title: Radio(
                //         value: 1,
                //         groupValue: _groupvalue,
                //         onChanged: null,
                //         activeColor: Colors.red,
                //       ),
                //       leading: Text(
                //         'Pay 5.99 for a month',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //     ListTile(
                //       title: Radio(
                //         value: 1,
                //         groupValue: _groupvalue,
                //         onChanged: null,
                //         activeColor: Colors.red,
                //       ),
                //       leading: Text(
                //         'Pay 12 for a month',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     )
                //   ],
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(104, 30, 10, 0),
                  child: InkWell(
                    onTap: () {
                      _showDialog();
                    },
                    child: Row(
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
                          'Terms and condition'.toUpperCase(),
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
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
                        color: Colors.red,
                      )),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
                  child: logButton,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                  child: signIn,
                ),
                SizedBox(
                  height: 80,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
