import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            actionsIconTheme: IconThemeData(
              color: Colors.black,
              size: 30
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20
            )
          )
        ),
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            Icon(Icons.add_box_outlined)
          ]
      )
    );
  }
}
