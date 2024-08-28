import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:try240721/HomePage.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:try240721/RegisterPage.dart';
void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {//ful會改變
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {//初始化
    super.initState();
    _fetchData();//連資料庫
  }

  void _fetchData() async {
    //MYSQL
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
  }

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled=false;
    return Scaffold(
      //appBar: AppBar(
        //title: Text('Demo'),
        //backgroundColor: Color(0xFF81D4FA),
      //),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40), // 添加間距
                    height: 100, // 設置logo高度
                    child: Icon(
                      Icons.account_circle,
                      size: 100, // 設置圖標大小
                      color: Color(0xFF4FC3F7), // 設置圖標颜色
                    ),
                  ),
                  Text(
                    '全方位照護守護者',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),//全方位照護守護者
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController, // 绑定電子信箱输入框的控制器
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),//https://www.fluttericon.cn/v
                      labelText: '電子信箱',
                    ),
                  ),//電子信箱
                  SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outlined),
                      labelText: '密碼',
                    ),
                    obscureText: true,
                  ),//密碼
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loginBtn,/*() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },*/
                    child: Text(' 登入'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4FC3F7),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),//登入
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('立即註冊'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent, // 無背景颜色
                      textStyle: TextStyle(fontSize: 18),
                      shadowColor: Colors.transparent, // 去除陰影
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(
                          email: _emailController.text,
                        )),
                      );
                    },
                    child: Text('忘記密碼'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent, // 無背景颜色
                      textStyle: TextStyle(fontSize: 18),
                      shadowColor: Colors.transparent, // 去除陰影
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void loginBtn() async {
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
      // 獲取用戶輸入的帳號和密碼
      String email = _emailController.text;
      String password = _ageController.text;

      print('输入的信箱: $email');
      print('输入的密碼: $password');

      // 查詢數據庫，检查是否有匹配的帳號
      var result = await conn.execute(
        'SELECT * FROM users WHERE email = :email AND password = :password',
        {'email': email, 'password': password},
      );

      print('查詢結果行數: ${result.rows.length}');

      if (result.rows.isNotEmpty) {
        _emailController.clear();
        _ageController.clear();
        // 如果找到匹配的帳號，登入成功，跳轉到主頁
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: email,
            ),
          ),
        );
      } else {
        // 没有找到匹配的帳號，提示登入失敗
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登入失敗：帳號或密碼錯誤')),
        );
      }
    } catch (e) {
      print('資料庫錯誤: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('登入失敗：系統錯誤')),
      );
    } finally {
      await conn.close();
    }
  }
}