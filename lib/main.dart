import 'package:flutter/material.dart';
import 'package:wallpaper_guru/views/screens/category.dart';
import 'package:wallpaper_guru/views/screens/home.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash Walls',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen(),
    );
  }
}

