import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:async';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isButtonEnabled = true;
  int _seconds = 60;
  Timer? _timer;
  String _generatedCode = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final conn = await MySQLConnection.createConnection(
      host: '203.64.84.154',
      port: 33061,
      userName: 'root',
      password: 'Topic@2024',
      databaseName: 'care',
    );
    await conn.connect();
  }

  void _startTimer() {
    setState(() {
      _isButtonEnabled = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer?.cancel();
          _isButtonEnabled = true;
          _seconds = 60;
        }
      });
    });
  }

  String _generateVerificationCode() {
    final random = Random();
    const availableChars = '0123456789';
    return List.generate(6, (index) => availableChars[random.nextInt(availableChars.length)]).join();
  }

  Future<void> _sendEmail(String recipientEmail, String code) async {
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 587,
      username: 'kueikuei8011@gmail.com',
      password: 'yqns onwf tydq obzl',
      ssl: false,
      allowInsecure: false,
    );

    final message = Message()
      ..from = Address('kueikuei8011@gmail.com', 'Kuei')
      ..recipients.add(recipientEmail)
      ..subject = '您的驗證碼'
      ..text = '您的驗證碼是: $code';

    try {
      await send(message, smtpServer);
      print('驗證碼發送成功');
    } catch (e) {
      print('驗證碼發送失敗: $e');
    }
  }

  void _sendVerificationCode() {
    final email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('請輸入電子信箱地址')),
      );
      return;
    }

    _generatedCode = _generateVerificationCode();
    _sendEmail(email, _generatedCode);
    _startTimer();
  }

  void registerBtn() async {
    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: '0000',
      databaseName: 'testdb',
    );
    await conn.connect();

    try {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      var result = await conn.execute(
        'SELECT * FROM users WHERE email = :email AND password = :password',
        {'email': email, 'password': password},
      );

      if (result.rows.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登入失敗：帳號或密碼錯誤')),
        );
      } else {
        await conn.execute(
          'INSERT INTO users (name, email, password) VALUES (:name, :email, :password)',
          {'name': name, 'email': email, 'password': password},
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('註冊成功！')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPage(email: email),
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    height: 100,
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Color(0xFF4FC3F7),
                    ),
                  ),
                  Text(
                    '全方位照護守護者',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outlined),
                      labelText: '用戶姓名',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: '電子信箱',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outlined),
                      labelText: '密碼',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: '驗證碼',
                            hintText: '填寫驗證碼',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isButtonEnabled ? _sendVerificationCode : null,
                        child: _isButtonEnabled
                            ? Text('發送驗證碼')
                            : Text('重新發送(${_seconds})'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Color(0xFF4FC3F7) : Colors.grey,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: registerBtn,
                    child: Text('下一步'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4FC3F7),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('取消註冊'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(fontSize: 18),
                      shadowColor: Colors.transparent,
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
}

class VerifyPage extends StatelessWidget {
  final String email;

  VerifyPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Text('Email: $email'),
      ),
    );
  }
}
