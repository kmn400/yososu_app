import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'model/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Data> _data = [];

  Future<void> fetch() async {
    var url = Uri.parse(
        'http://api.odcloud.kr/api/uws/v1/inventory?page=10&perPage=50&serviceKey=data-portal-test-key');
    var response = await http.get(url);

    final jsonResult = jsonDecode(response.body);
    final jsonData = jsonResult['data'];

    setState(() {
      _data.clear();
      jsonData.forEach((e) {
        _data.add(Data.fromJson(e));

        print('fetch completed');
      });
    });
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('요소수 주유소 현황'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.restart_alt_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                fetch();
              },
              child: Text('가져오기'),
            ),
          ),
          Expanded(
            child: ListView(
              children: _data.map(
                (e) {
                  return ListTile(
                    /*
                  한줄일 경우에는 람다식으로 '=>' 요 표현식인데,
                  중괄호로 바꿔서 할 수 있음.
                  */
                    title: Text(e.name ?? '이름없음'),
                    subtitle: Text(e.addr ?? '주소없음'),
                    trailing: Text(e.inventory ?? '재고없음'),
                    onTap: () {
                      launch('tel:+010 2899 5918');
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
