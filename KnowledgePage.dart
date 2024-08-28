import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:try240721/main.dart';
import 'package:try240721/HomePage.dart';
import 'package:try240721/HistoricalRecord.dart';
import 'package:try240721/PersonalInfo.dart';
import 'package:try240721/MessagePage.dart';
/*void main() {
  runApp(MaterialApp(
    home: KnowledgePage(),
  ));
}*/

class KnowledgePage extends StatelessWidget {
  final String email; // 接收來自上個頁面的 email
  KnowledgePage({required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
         title: Text('知識文章'),
         backgroundColor: Color(0xFFF5E3C3),
       ),*/
      body: Column(
        children: [
          Container(
            height: 100,
            color: Color(0xFFF5E3C3),
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                '知識補充',
                style: TextStyle(fontSize: 24, height: 5),
              ),
            ),
          ),
          Expanded(
              child:ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 5), // 调整列表视图的 padding
                itemCount: 3,
                itemBuilder: (context, idx) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(
                          email: email,
                        )),
                      );
                    },
                    child: Card(
                      //margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'lib/images/456.jpg',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              '文章標題 $idx',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              '這是文章的簡短描述...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: '跌倒紀錄'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: '知識補充'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_outlined), label: '切換畫面'),
          BottomNavigationBarItem(icon: Icon(Icons.person_sharp), label: '個人資料'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(
                email: email,
              )),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoricalRecord(
                email: email,
              )),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KnowledgePage(
                email: email,
              )),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagePage(
                email: email,
              )),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfo(
                email: email,
              )),
            );
          }
        },
      ),
    );
  }
}
