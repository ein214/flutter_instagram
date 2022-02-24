import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';

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
  var getHttpCount = 0;
  var url = "";
  var scroll = ScrollController();
  var showAppBar = true;


  getData() async {
    switch(getHttpCount) {
      case 0:
        url = 'https://codingapple1.github.io/app/data.json';
        break;
      case 1:
        url = 'https://codingapple1.github.io/app/more1.json';
        break;
      case 2:
        url = 'https://codingapple1.github.io/app/more2.json';
        break;
      default:
        url = "";
        break;
    }

    if (url.isEmpty) {
      Fluttertoast.showToast(
          msg: "마지막 게시물입니다.",
          timeInSecForIosWeb: 5
      );
    } else {
      var result = await http.get(Uri.parse(url));
      if (result.statusCode == 200) {
        setState(() {
          if (getHttpCount == 0) {
            var result2 = jsonDecode(result.body);
            print(result2);
            contents = result2;
          } else {
            contents.add(jsonDecode(result.body));
          }
          getHttpCount++;
        });
      } else {
        Fluttertoast.showToast(
            msg: "연결에러",
            timeInSecForIosWeb: 5
        );
      }
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
            IconButton(
              icon:Icon(Icons.add_box_outlined),
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Upload())
                );
              },
              iconSize: 30,
            )
          ]
      ),
      body: [ListTab(contents: contents, getData: getData), Text('샵')][tab],
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

class ListTab extends StatefulWidget {
  const ListTab({Key? key, this.contents, this.getData }) : super(key: key);
  final contents;
  final getData;

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  var scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      //print(scroll.position.maxScrollExtent);
      print(scroll.position.userScrollDirection);
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        widget.getData();
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.contents.isNotEmpty) {
      return ListView.builder(
          controller: scroll,
          itemCount: widget.contents.length,
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
            return Column(
              children: [
                Image.network(widget.contents[index]['image']),
                Container(
                  constraints: BoxConstraints(maxWidth: double.infinity),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("좋아요 ${widget.contents[index]['likes'].toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                      Text(widget.contents[index]['user']),
                      Text(widget.contents[index]['content']),
                    ],
                  ),
                )
              ],
            );
          }
      );
    } else {
      return Text('로딩중');
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이미지 업로드화면'),
          IconButton(
            icon:Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
