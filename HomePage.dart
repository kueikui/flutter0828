import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:try240721/main.dart';
import 'package:try240721/HistoricalRecord.dart';
import 'package:try240721/PersonalInfo.dart';
import 'package:try240721/KnowledgePage.dart';
import 'package:try240721/MessagePage.dart';
import 'package:try240721/TryPage.dart';
import 'package:video_player/video_player.dart';
//import 'package:try240721/LoginPage.dart';

/*void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}*/

class HomePage extends StatefulWidget {
  final String email;
  HomePage({required this.email});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/videos/test.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true); //影片循環撥放
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose(); //釋放資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        //title: Text('首頁'),
        //backgroundColor: Color(0xFFF5E3C3), // 设置AppBar背景颜色
      //),
      body: Center(
        child: Column(
          children: [
          Container(
          height: 100,//APPBar height
          color:Color(0xFFF5E3C3),
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child:Center(
            child: Text('全方位照護守護者',
              style: TextStyle(fontSize: 24,height: 5),
            ),
          ),
        ),
        Container(
              color: Color(0xFFFFF0E0),
              margin:  EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : Container(
                    height: 60,
                    width: 120,
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    '即時畫面',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
        ),

            Container(
              child:GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                children: [
                  _buildGridItem(Icons.history_edu, '跌倒紀錄', context),
                  _buildGridItem(Icons.lightbulb_outline, '知識補充', context),
                  //_buildGridItem(Icons.chat_outlined, '123', context),
                  _buildGridItem(Icons.monitor_outlined, '切換畫面', context),

                  _buildGridItem(Icons.person_sharp, '個人資料', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label,BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      child: InkWell(//點擊時水波效果
        onTap: () {
          if (label == '跌倒紀錄') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoricalRecord(
                email: widget.email,
              )),
            );
          }
          else if (label == '知識補充') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KnowledgePage(
                email: widget.email,
              )),
            );
          }
          else if (label == '123') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TryPage()),
            );
          }
          else if (label == '個人資料') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfo(
                email: widget.email,
              )),
            );
          }

        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.orange),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
