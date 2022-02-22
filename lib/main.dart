import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var contents = [];

  getData() async {
    try {
      var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
      var result2 = jsonDecode(result.body);
      setState(() {
        contents = result2;
        print(result2);
      });

      print(result2.length);
    } catch(error) {
      Fluttertoast.showToast(
        msg: "연결에러",
        timeInSecForIosWeb: 5
      );
    }

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            Icon(Icons.add_box_outlined)
          ]
      ),
      body: [ListTab(contents: contents), Text('샵')][tab],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },  //onPressed랑 똑같
      ),

    );
  }
}

class ListTab extends StatelessWidget {
  const ListTab({Key? key, this.contents }) : super(key: key);
  final contents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contents.length,
      itemBuilder: (context, index) {
        /**
         * 과제 해답
         * return Column(
         *  children : [
         *    Image.network('이미지주소'),
         *    Container(
         *      constraints: BoxConstraints(maxWidth: 600),
         *      padding: EdgeInsets.all(20),
         *      width: double.infinity,
         *      child: Column(
         *        crossAxisAlignment: CrossAxisAlignment.start,
         *        children: [
         *          //동일
         *        ]
         *      )
         *    )
         *  ]
         * )
         *
         * - 나는 Container부터 짰는데 Column부터 짜서 이미지 일단 넣고 시작하는게 훨씬 깔끔해보이고
         * - 일단 이미지 가로폭을 늘리려고 했는데 BoxConstraints를 쓰면 최대 폭 자체를 지정할 수가 있었음.
         */
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Image.network(contents[index]['image']),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("좋아요 "+contents[index]['likes'].toString(), style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    Text(contents[index]['user']),
                    Text(contents[index]['content']),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

