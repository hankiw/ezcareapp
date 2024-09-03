import 'package:ezcareapp/screens/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String webViewUri = 'https://bapdish.com';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoTabScaffold(
        backgroundColor: CupertinoColors.white,
        tabBar: CupertinoTabBar(
          backgroundColor: CupertinoColors.systemBlue,
          activeColor: CupertinoColors.white,
          inactiveColor: CupertinoColors.white.withOpacity(0.5),
          onTap: (index) {
            print(index);
            setState(() {
              webViewUri = 'https://ezcare.easyms.co.kr';
            });
          },
          items: const [
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
          ]
        ),
        tabBuilder: (context, index) {
          return PageMain(webViewUri: webViewUri);
        },
      ),
    );
  }
}

