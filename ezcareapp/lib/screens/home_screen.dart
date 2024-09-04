import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _controller;

  int _selectedIndex = 0;
  bool isBottomNavi = true;
  // String webViewUri = 'https://z05.ezc.kr/page/test/main.html';
  List<String> webViewUriList = <String> [
    'https://z05.ezc.kr/page/test/main.html',
    'https://z05.ezc.kr/page/test/page01.html',
    'https://z05.ezc.kr/page/test/page02.html',
  ];

  @override
  void initState() {
    super.initState();
    
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes> {}
      );
    } else {
      params = PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'NativeBottomNavigation',
        onMessageReceived: (JavaScriptMessage msg) {
          print(msg.message);
          bool isShow = (msg.message == 'show') ? true : false;
          setState(() {
            isBottomNavi = isShow;
          });
        }
      )
      ..addJavaScriptChannel(
        'ToastMessage',
        onMessageReceived: (JavaScriptMessage msg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg.message),
              action: SnackBarAction(
                label: 'close',
                onPressed: () {}
              )
            )
          );
        }
      )
      ..loadRequest(Uri.parse(webViewUriList[0]));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('ezcare webview', style: TextStyle(color: CupertinoColors.white)),
          actions: [
            ReloadButton(controller: _controller),
          ],
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: (isBottomNavi == true) ? BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              label: '일정&명세서',
              icon: Icon(Icons.calendar_month)
            ),
            BottomNavigationBarItem(
              label: '알림',
              icon: Icon(Icons.notifications)
            ),
            BottomNavigationBarItem(
              label: '내정보',
              icon: Icon(Icons.settings)
            ),
            BottomNavigationBarItem(
              label: '라운지',
              icon: Icon(Icons.coffee)
            ),
            BottomNavigationBarItem(
              label: '더보기',
              icon: Icon(Icons.more_horiz_rounded)
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          currentIndex: _selectedIndex,
          selectedItemColor: CupertinoColors.white,
          unselectedItemColor: CupertinoColors.white.withOpacity(0.5),
          onTap: _onTapBottomNavi,
        ) : null,
        body: WebViewWidget(controller: _controller)
        // body: Text('hello'),
      ),
    );
  }

  void _onTapBottomNavi(value) {
    setState(() {
      _selectedIndex = value;
      _controller.loadRequest(Uri.parse(webViewUriList[_selectedIndex]));
    });
  }
}

class ReloadButton extends StatelessWidget {
  WebViewController controller;
  ReloadButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.replay), onPressed: () {controller.reload();},);
  }
}

