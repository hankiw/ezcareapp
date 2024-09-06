import 'package:ezcareapp/screens/test_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _controller;
  late String thisPlatform;

  
  int _selectedIndex = 0;
  bool isBottomNavi = true;
  double _webProgress = 0;

  // String webViewUri = 'https://z05.ezc.kr/page/test/main.html';
  List<String> webViewUriList = <String> [
    'https://z04.ezc.kr/page/apptest/test01.html',
    'https://z04.ezc.kr/page/apptest/page01.html',
    'https://z04.ezc.kr/page/apptest/page02.html',
    'https://z05.ezc.kr/?PGID=lounge-main',
    'https://z05.ezc.kr/?PGID=service-dsbd',
  ];

  void initialization() async {
    await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    initialization();

    // 접속 플랫폼 확인
    if (kIsWeb) {
      thisPlatform = 'Web';
    } else {
      thisPlatform = defaultTargetPlatform.toString();
    }
    
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes> {}
      );
    } else {
      params = PlatformWebViewControllerCreationParams();
    }

    // final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress: ${progress})');
            setState(() {
              _webProgress = progress.toDouble();
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loadgin: (${url})');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading : (${url})');
            controller.runJavaScript('setVarThisPlatform(\'${thisPlatform}\');');
          }
        )
      )
      ..addJavaScriptChannel(
        'NativeBottomNavigation',
        onMessageReceived: (JavaScriptMessage msg) {
          bool isShow = (msg.message == 'show') ? true : false;
          setState(() {
            isBottomNavi = isShow;
          });
        }
      )
      ..addJavaScriptChannel(
        'NativeBottomNavigationIndex',
        onMessageReceived: (JavaScriptMessage msg) {
          int idx = int.parse(msg.message);
          setState(() {
            _selectedIndex = idx;
          });
        }
      )
      ..addJavaScriptChannel(
        'SnackBarMessage',
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
        // appBar: AppBar(
        //   backgroundColor: CupertinoColors.systemBlue,
        //   title: Text('ezcare webview', style: TextStyle(color: CupertinoColors.white)),
        //   actions: [
        //     ReloadButton(controller: _controller),
        //   ],
        // ),
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
            BottomNavigationBarItem(
              label: '새로고침',
              icon: Icon(Icons.replay)
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          currentIndex: _selectedIndex,
          selectedItemColor: CupertinoColors.white,
          unselectedItemColor: CupertinoColors.white.withOpacity(0.7),
          onTap: _onTapBottomNavi,
        ) : null,
        // body: (_selectedIndex == 4) ? TestScreen() : WebViewWidget(controller: _controller)
        body: Column(
          children: [
            WebViewWidget(controller: _controller),
            
            // 아래는 progress indicator 추가 한 버전
            // Expanded(
            //   child: WebViewWidget(controller: _controller),
            // ),
            // (_webProgress < 100) ? _ProgressIndicator() : SizedBox(),
          ],
        )
      ),
    );
  }

  void _onTapBottomNavi(value) {
    setState(() {
      // 새로고침 버튼
      if (value == 5) {
        _controller.reload();
        return;
      }

      // 현재 화면을 다시 누르면 바로 return 함
      if (_selectedIndex == value) return;

      _selectedIndex = value;
      _controller.loadRequest(Uri.parse(webViewUriList[_selectedIndex]));
    });
  }

  Widget _ProgressIndicator() {
    return SizedBox(
      height: 5.0,
      child: LinearProgressIndicator(
        value: _webProgress,
        color: Colors.red,
        backgroundColor: Colors.black,
      ),
    );
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

