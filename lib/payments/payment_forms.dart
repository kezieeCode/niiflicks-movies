import 'package:flutter/material.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

WebViewController _webViewController;

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            )),
        backgroundColor: Colors.black,
        title: Text(
          'Help us'.toUpperCase(),
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: 'https://niiflicks.com/',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageFinished: (String url) {
          _webViewController.evaluateJavascript('https://niiflicks.com/');
        },
      ),
    );
  }
}
