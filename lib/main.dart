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


  addData(a) {
    setState(() {
      contents.add(a);
      getHttpCount++;
    });
  }

  /// 과제하면서 해답과 다른점 - 그냥 일단 굴러가게만 만들었었음.
  /// 1. switch가 아니라 getMore에 대한 부분을 별도 구현했어야했고
  /// 2. 데이터에 추가하는 함수정도만 넘겨도 됐음.
  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      setState(() {
        var result2 = jsonDecode(result.body);
        contents = result2;
        getHttpCount++;
      });
    } else {
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
      body: [ListTab(contents: contents, addData: addData, getHttpCount: getHttpCount), Text('샵')][tab],
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
  const ListTab({Key? key, this.contents, this.addData, this.getHttpCount }) : super(key: key);
  final contents;
  final addData;
  final getHttpCount;

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  var scroll = ScrollController();

  getMore() async {
    if (widget.getHttpCount > 2) {
      Fluttertoast.showToast(
          msg: "마지막 게시물입니다.",
          timeInSecForIosWeb: 5
      );
    } else {
      var result = await http.get(Uri.parse(
          'https://codingapple1.github.io/app/more${widget
              .getHttpCount}.json'));
      var result2 = jsonDecode(result.body);
      widget.addData(result2);
    }
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
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
