import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGame extends StatefulWidget {
  final stream;
  WebGame({this.stream});
  @override
  _WebGameState createState() => _WebGameState();
}

class _WebGameState extends State<WebGame> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            )),
      ),
      body: Stack(
        // color: Colors.black,
        // width: double.infinity,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          // ),
          WebView(
            // isLoading = true;
            initialUrl: widget.stream,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              // _controller.complete(webViewController);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },

            onProgress: (int progress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },

            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(widget.stream)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.prevent;
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
