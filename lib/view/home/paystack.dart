import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:niiflicks/classes/latest.dart';
import 'package:niiflicks/view/home/seeries_season.dart';
import 'package:niiflicks/view/home/success.dart';
import 'package:niiflicks/view/screens/paid_movies.dart';
import 'package:niiflicks/view/video/video_apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Paystack extends StatefulWidget {
  final String accessCode, ref;
  final id;

  const Paystack(
      {Key key, @required this.accessCode, this.id, @required this.ref})
      : super(key: key);

  @override
  _PaystackState createState() => _PaystackState();
}

class _PaystackState extends State<Paystack> {
  Future<Response> sendDB() async {
    var uri = 'https://niiflicks.com/niiflicks/apis/movies/cinema_paystat.php';
    var slug = widget.id;
    var data = {"movslg": slug, "email": _email};
    var response = await http.post(Uri.parse(uri), body: data);
    if (response.statusCode == 200) {
      var message = convert.jsonDecode(response.body)["error"];
      if (message == false) {
        throw Exception("moved ko DB");
      } else if (message == true) {
        throw Exception("Payment not complete");
      }
    } else {
      throw Exception("No established connection");
    }
  }

  bool _available = false;
  Future<Map<String, dynamic>> _value;
  List<LatestReleases> latestReleases = [];
  Future<Map<String, dynamic>> movieDetails() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    var vid_id = widget.id;
    var data = {'slug': vid_id};
    print(data);
    var url = Uri.parse('https://universal-studios1.p.rapidapi.com/movie.php');
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    print('response:${response.statusCode}');
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Text('error data ',
          style: TextStyle(
            color: Colors.white,
          ));
    }
  }

  var authorization_url = "https://checkout.paystack.com/owffh9245qendmh";
  var access_code = "owffh9245qendmh";
  var reference = "uzhkoahpmp";
  var _email;
  String _accessCode;
  String _ref;

  var payUrl = 'api.paystack.co';
  var initPay = '/transaction/initialize';
  var verifyPay = '/transaction/verify/';
  var _secretKey = 'sk_test_7aca697b06ea8bf4a00899c66287f9da8caa1158';
  // var _secretKey = 'sk_test_385e3dd2984a449ecfab21fb340f74d1626fcf05';
  Future<Response> verify(String reference) async {
    var url = Uri.https(payUrl, verifyPay + reference);
    final response = await get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${_secretKey}",
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Fail to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.red, Colors.redAccent]),
                  border: Border(
                    bottom: BorderSide(width: 2, color: Colors.blueAccent),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                        Spacer(
                          flex: 5,
                        ),
                        Container(
                            child: Text(
                          'Make Payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              fontFamily: "lato",
                              color: Colors.blue),
                        )),
                        Spacer(
                          flex: 7,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
        body: WebView(
            initialUrl: "https://checkout.paystack.com/${widget.accessCode}",
            javascriptMode: JavascriptMode.unrestricted,
            userAgent: 'Flutter;Webview',
            navigationDelegate: (navigation) async {
              //Listen for callback URL

              // if (navigation.url == "https://hello.pstk.xyz/callback") {
              await verify('${widget.ref}').then((value) async {
                // var result = convert.jsonDecode(value.body);
                // print('this ' + result);
                print(value.statusCode);
                print('heloo' + value.body);
                if (value.statusCode == 200 || value.statusCode == 201) {
                  print('${widget.ref}');
                  sendDB();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return FutureBuilder(
                        future: movieDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return VideoPlayerScreenApi(
                                movie_stream: _available
                                    ? 'N/A'
                                    : '${snapshot.data['data']['stream_link']}');
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Container();
                          }
                        });
                  }), (Route<dynamic> route) => false);
                } else if (value.statusCode == 400) {
                  print(value.statusCode);
                }
              });
              // }
              return NavigationDecision.navigate;
            }),
      ),
    );
  }
}
// WebView(
//             initialUrl: "https://checkout.paystack.com/${widget.accessCode}",
//             javascriptMode: JavascriptMode.unrestricted,
//             userAgent: 'Flutter;Webview',
//             navigationDelegate: (navigation) async {
//               await verify('${widget.ref}').then((value) async {
//                 var result = convert.jsonDecode(value.body);
//                 print(result);
//                 if (value.statusCode == 200 ||
//                     value.statusCode == 201 && result["status"] == true) {
//                   Navigator.pushAndRemoveUntil(context,
//                       MaterialPageRoute(builder: (context) {
//                     return VideoPlayerScreenApi(
//                                                         movie_stream: _available
//                                                             ? 'N/A'
//                                                             : '${snapshot.data['data']['stream_link']}')

//                   }), (Route<dynamic> route) => false);
//                   print(result);
//                 } else if (value.statusCode == 400 && result["status"] == false) {
//                   print(result);
//                 }
//               });
//               return NavigationDecision.navigate;
//             },
//           ),
