import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
import 'package:try240721/HomePage.dart';
void main() {
  runApp(TryPage());
}

class TryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MySQL Data'),
        ),
        body: MySqlData(),
      ),
    );
  }
}
class MySqlData extends StatefulWidget {
  @override
  _MySqlDataState createState() => _MySqlDataState();
}

class _MySqlDataState extends State<MySqlData> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {//初始化
    super.initState();
    _fetchData();//連資料庫
  }

  void  _fetchData() async {
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

      if (result.rows.isEmpty) {//null
        print('No data found in users table.');
      }
      else {
        setState(() {
          _results = result.rows.map((row) =>
              {
                'name': row.colAt(0),
                'gender': row.colAt(1)
              } //colat的參數是看select進來的參數
          ).toList();
        });
      }
    }
    catch (e) {
      print('Error: $e');
    }
    finally{
      await conn.close();
    }
  }

  //頁面
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final user = _results[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text('gender: ${user['gender']}'),
        );
      },
    );
  }
}


























//server=203.64.84.154;database=care;uid=root;password=Topic@2024;port = 33061";
/*
  // 创建数据库连接对象
  final conn = await Connection.connect(settings);

  // 执行SQL查询语句
  final result = await conn.query('SELECT * FROM users');

  // 处理查询结果
  for (final row in result) {
    print('${row[0]} - ${row[1]} - ${row[2]}');
  }

  // 执行SQL插入语句
  final insertResult = await conn.execute('INSERT INTO users (name, age) VALUES (?, ?)', ['John', 30]);

  // 处理插入结果
  print('Inserted rows: ${insertResult.affectedRows}');

  // 执行SQL更新语句
  final updateResult = await conn.execute('UPDATE users SET age = ? WHERE name = ?', [35, 'John']);

  // 处理更新结果
  print('Updated rows: ${updateResult.affectedRows}');

  // 执行SQL删除语句
  final deleteResult = await conn.execute('DELETE FROM users WHERE name = ?', ['John']);

  // 处理删除结果
  print('Deleted rows: ${deleteResult.affectedRows}');

  // 关闭数据库连接
  conn.close();
}*/