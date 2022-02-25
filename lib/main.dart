import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2())
        ],
        child: MaterialApp(
          theme: style.theme,
          home: MyApp(),
        ),
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
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = {'age' : 20};
    storage.setString('map', jsonEncode(map));

    var result = storage.getString('map');
    if (result != null) {
      print(jsonDecode(result));
    }
  }

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
    saveData();
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
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  print(image);
                  setState(() {
                    userImage = File(image.path);
                  });
                }

                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Upload(userImage: userImage, addData: addData))
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
                widget.contents[index]['image'].runtimeType != String ? Image.file(widget.contents[index]['image']): Image.network(widget.contents[index]['image']),
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
                      GestureDetector(
                        child:Text(widget.contents[index]['user']),
                        onTap: () {
                          Navigator.push(context, 
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => Profile(),
                              transitionsBuilder: (c, a1, a2, child) =>
                                FadeTransition(opacity: a1, child: child),
                              transitionDuration: Duration(milliseconds: 1500)
                            )
                          );
                        },
                      ),
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
  Upload({Key? key, this.userImage, this.addData}) : super(key: key);
  final userImage;
  final addData;

  var textData = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 30,
            onPressed: () {
              addData({
                "id" : "5",
                "image": userImage,
                "likes" : 10,
                "date": "Feb 24",
                "content" : textData.text,
                "liked": false,
                "user" : "einee214"
              });

              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userImage != null ? Image.file(userImage) : Text(""),
          Text('이미지 업로드화면'),
          TextField(controller: textData,),

        ],
      ),
    );
  }
}

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Store1 extends ChangeNotifier {

  var follower = 0;
  var clickedFollow = false;
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  follow() {
    if (clickedFollow == true) {
      follower--;
      clickedFollow = false;
    } else {
      follower++;
      clickedFollow = true;
    }




    notifyListeners();
  }

  unfollow() {
    follower--;
    clickedFollow = false;
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store2>().name),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
            ),
            Text('팔로워 ${context.watch<Store1>().follower}명'),
            ElevatedButton(onPressed: (){
              if (context.read<Store1>().clickedFollow == true) {
                context.read<Store1>().unfollow();
              } else {
                context.read<Store1>().follow();
              }

            }, child: Text('Follow'),
            )
          ],
        ),
      ),
    );
  }
}
