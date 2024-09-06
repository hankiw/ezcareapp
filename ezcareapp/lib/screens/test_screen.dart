import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Map<String, dynamic>> topGridItems = <Map<String, dynamic>> [
    {'text': '인지활동 게임', 'color': Colors.teal[200]},
    {'text': '구인구직은 이지', 'color': Colors.teal[300]},
    {'text': '60세 건강식단', 'color': Colors.teal[400]},
    {'text': '내 주변 기관검색', 'color': Colors.teal[500]},
    {'text': '추모공원 비교검색', 'color': Colors.teal[600]},
    {'text': 'MORE', 'color': Colors.teal[700]},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('실버빌리지 서비스 (native app)'),
          SizedBox(
            height: 200.0,
            child: GridView.builder(
              itemCount: topGridItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                crossAxisCount: 3,
                childAspectRatio: 1.5 / 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: topGridItems[index]['color'].withOpacity(0.8),
                  ),
                  child: Text(
                    topGridItems[index]['text'],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                );
              }
            ),
          ),
          Text('aaa'),
        ],
      ),
    );
  }
}