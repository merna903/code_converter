
import 'package:code_converter/blocObserver.dart';
import 'package:code_converter/modules/c++_layout_screen.dart';
import 'package:code_converter/styles/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThem,
      themeMode:ThemeMode.light,
      home: CppLayoutScreen(),
    );
  }
}
