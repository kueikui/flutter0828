import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:try240721/main.dart';
import 'package:try240721/HomePage.dart';
import 'package:try240721/PersonalInfo.dart';
import 'package:try240721/KnowledgePage.dart';
import 'package:try240721/MessagePage.dart';
import 'package:mysql_client/mysql_client.dart';

class HistoricalRecord extends StatefulWidget {
  final String email; // 接收來自上個頁面的 email
  HistoricalRecord({required this.email});

  @override
  _HistoricalRecordState createState() => _HistoricalRecordState();
}

class _HistoricalRecordState extends State<HistoricalRecord> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // 連資料庫
  }

  void _fetchData() async {
    print('connect');

    final conn = await MySQLConnection.createConnection(
      //host: '203.64.84.154',
      host:'10.0.2.2',
      //127.0.0.1 10.0.2.2
      port: 3306,
      userName: 'root',
      //password: 'Topic@2024',
      password: '0000',
      //databaseName: 'care', //testdb
      databaseName: 'testdb',
    );
    await conn.connect();

    try {
      var result = await conn.execute('SELECT * FROM users');
      print('Result: ${result.length} rows found.');

      if (result.rows.isEmpty) {
        print('No data found in users table.');
      } else {
        setState(() {
          _results = result.rows.map((row) => {
            'id': row.colAt(0),
            'name': row.colAt(1),
            'age':row.colAt(2),
            'gender':row.colAt(3),
            'phone':row.colAt(4),
            'email':row.colAt(5),
            'password':row.colAt(2)
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
      body: Column(
        children: [
          Container(
            height: 100,
            color: Color(0xFFF5E3C3),
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                '跌倒紀錄',
                style: TextStyle(fontSize: 24, height: 5),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5), // 调整列表视图的 padding

              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]['name']),
                  subtitle: Text(
                    'age: ${_results[index]['age']}, '
                        'gender: ${_results[index]['gender']}, '
                        'phone: ${_results[index]['phone']}, '
                        'email: ${_results[index]['email']}',
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
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.orange),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                    email: widget.email,
                  )),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoricalRecord(
                    email: widget.email,
                  )),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KnowledgePage(
                    email: widget.email,
                  )),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessagePage(
                    email: widget.email,
                  )),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PersonalInfo(
                    email: widget.email,
                  )),
            );
          }
        },
      ),
    );
  }
}
