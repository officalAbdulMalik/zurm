import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SwapPayScreen extends StatefulWidget {
  final String url;
  const SwapPayScreen({super.key, required this.url});

  @override
  State<SwapPayScreen> createState() => _SwapPayScreenState();
}

class _SwapPayScreenState extends State<SwapPayScreen> {


  late final WebViewController webcontroller;
  bool loading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      webcontroller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {

            },
            onPageFinished: (String url) {
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {

            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } else if (Platform.isIOS) {
      webcontroller = WebViewController()
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {

            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(controller: webcontroller),
      ),
    );
  }
}
