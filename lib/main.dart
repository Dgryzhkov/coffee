import 'package:coffee/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'МойЁ кофе',
      home: SplashScreen(),
    );
  }
}

// путь до базы в приложении
// /data/data/com.example.coffee/databases/coffee,db


