import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:try240721/main.dart';
import 'package:try240721/HomePage.dart';
import 'package:try240721/HistoricalRecord.dart';
import 'package:try240721/KnowledgePage.dart';
import 'package:try240721/MessagePage.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
/*void main() {
  runApp(MaterialApp(
    home: PersonalInfo(),
  ));
}*/

class PersonalInfo extends StatefulWidget {
  final String email; // 接收來自上個頁面的 email
  PersonalInfo({required this.email});
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String _name = '', _phone = '', _age = '',_gender = '',_email = '';
  bool _isEditing=false;//是否為編輯狀態
  final TextEditingController _emailController = TextEditingController();//email輸入text

  @override
  void initState() {//初始化
    super.initState();
    _fetchData();
  }

  void _fetchData() async {//MYSQL
    print('傳遞過來的 email: ${widget.email}'); // 打印 email 來確認它是否正確傳遞

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
      print('ok');
      var result = await conn.execute('SELECT name, phone, age, gender, email FROM users WHERE email = :email',
          {'email': widget.email},  // 傳入參數 email
      );
      if (result.rows.isNotEmpty) {//有資料
        var row = result.rows.first;
        setState(() {
          _name = row.colAt(0)??'';//如果沒有資料就是空直
          _phone = row.colAt(1)??'';
          _age = row.colAt(2)??'';
          _gender = row.colAt(3)??'';
          _email = row.colAt(4)??'';
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: '0000',
      databaseName: 'testdb',
    );

    await conn.connect();

    try {
      await conn.execute(
        'UPDATE users SET email = :email WHERE email = :old_email',
        {'email': _emailController.text, 'old_email': widget.email},
      );
      setState(() {
        _email = _emailController.text;
        _isEditing = false; // 退出編輯
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }


  //頁面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('個人資料'),
      //   backgroundColor: Color(0xFFF5E3C3),
      // ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: Color(0xFFF5E3C3),//背景底色
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                '個人資料',
                style: TextStyle(fontSize: 24, height: 5),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 5), // 调整列表视图的 padding

              children: [
                ListTile(
                  title: Text('姓名',style: TextStyle(fontSize: 20),),
                  subtitle: Text(_name),
                  //trailing: Icon(Icons.arrow_forward_ios),//>
                  onTap: () {//點了之後
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('手機'),
                  subtitle: Text(_phone),
                  //trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {

                  },
                ),
                Divider(),
                ListTile(
                  title: Text('生日'),
                  subtitle: Text(_age),
                  //trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {

                  },
                ),
                Divider(),
                ListTile(
                  title: Text('性別'),
                  subtitle: Text(_gender),
                  //trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {

                  },
                ),
                Divider(),
                ListTile(
                  title: Text('EMAIL'),
                  subtitle: //Text(_email),
                    _isEditing
                    ? TextField(
                    controller: _emailController,
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  )
                  : Text(_email),
                  //trailing: Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    _toggleEdit(); // 切換到編輯狀態
                  },
                ),
                Divider(),
                SizedBox(height: 20,width: 60,),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('修改資料'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF5E3C3), // 無背景颜色
                    textStyle: TextStyle(fontSize: 18),
                    shadowColor: Colors.transparent, // 去除陰影
                  ),
                ),
                SizedBox(height: 10,width: 60,),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('登出'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF5E3C3),
                    textStyle: TextStyle(fontSize: 18),
                    shadowColor: Colors.transparent,
                  ),
                ),
              ],
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
        currentIndex: 4,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(
                  email: _email,
                )),
              );
            }
            else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoricalRecord(
                  email: widget.email,
                )),
              );
            }
            else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KnowledgePage(
                  email: widget.email,
                )),
              );
            }
            else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagePage(
                  email: widget.email,
                )),
              );
            }
            else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonalInfo(
                  email: widget.email,
                )),
              );
            }
          },
      ),
    );
  }
}
