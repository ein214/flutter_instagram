import 'package:flutter/material.dart';

/* 다른파일에서는 쓸 수 없는 변수 */
var _var1;

var theme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey
      )
    ),
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
);