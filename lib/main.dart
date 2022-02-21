import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.blue
          ),
          appBarTheme: AppBarTheme( color: Colors.grey, actionsIconTheme: IconThemeData(
              color: Colors.blue
          )),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.red)
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
      appBar: AppBar(actions: [Icon(Icons.star)]),
      body: Text('Hi'),
    );
  }
}
