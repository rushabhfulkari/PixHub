import 'package:flutter/material.dart';
import 'package:pixhub/views/home.dart';
import 'package:pixhub/widgets/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallpaperHub',
      theme: ThemeData(
        primaryColor: c1,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
