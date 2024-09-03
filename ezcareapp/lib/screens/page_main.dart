
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


// class PageMainTmp extends StatelessWidget {
//   String webViewUri;
//   WebViewController _controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(Colors.white)
//     ..loadRequest(Uri.parse('https://bapdish.com'));

//   PageMainTmp({super.key, required this.webViewUri});

//   @override
//   Widget build(BuildContext context) {
//     return WebViewWidget(controller: _controller);
//   }
// }

class PageMain extends StatefulWidget {
  String webViewUri;

  PageMain({
    super.key,
    required this.webViewUri,
  });


  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  late WebViewController webviewController;
  
  @override
  void initState() {
    super.initState();
    
    WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.webViewUri));

    webviewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: webviewController);
  }
}