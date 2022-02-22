import 'package:flutter/material.dart';
import 'style.dart' as style;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            Icon(Icons.add_box_outlined)
          ]
      ),
      body: [ListTab(), Text('샵')][tab],
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
  const ListTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,

      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Image.asset("test.jpg", fit: BoxFit.fill),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("좋아요100", style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    Text("글쓴이"),
                    Text("글내용"),
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

