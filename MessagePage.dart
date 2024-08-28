import 'package:flutter/material.dart';
import 'package:try240721/HomePage.dart';
import 'package:try240721/HistoricalRecord.dart';
import 'package:try240721/PersonalInfo.dart';
import 'package:try240721/KnowledgePage.dart';
import 'package:mysql_client/mysql_client.dart';

class MessagePage extends StatefulWidget {
  final String email; // 接收來自上個頁面的 email

  MessagePage({required this.email});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // 連接資料庫並抓取資料
  }

  void _fetchData() async {
    print('connect');

    final conn = await MySQLConnection.createConnection(
      host: '203.64.84.154',
      port: 33061,
      userName: 'root',
      password: 'Topic@2024',
      databaseName: 'care',
    );
    await conn.connect();

    try {
      var result = await conn.execute('SELECT eName, eGender FROM Elder');
      print('Result: ${result.length} rows found.');

      if (result.rows.isEmpty) {
        print('No data found in users table.');
      } else {
        setState(() {
          _results = result.rows.map((row) => {
            'name': row.colAt(0),
            'gender': row.colAt(1),
          }).toList();
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('MySQL Data'), // 顯示標題
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
              child: Text('切換畫面',
                style: TextStyle(fontSize: 24, height: 5),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5), // 调整列表视图的 padding
              itemCount: _results.length, // 列表項目數量
              itemBuilder: (context, index) {
                final user = _results[index];
                return ListTile(
                  title: Text(user['name']), // 顯示名稱
                  subtitle: Text('gender: ${user['gender']}'), // 顯示性別
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
        currentIndex: 3, // 當前選中的索引
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(email: widget.email)),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoricalRecord(email: widget.email)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KnowledgePage(email: widget.email)),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagePage(email: widget.email)),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfo(email: widget.email)),
            );
          }
        },
      ),
    );
  }
}
