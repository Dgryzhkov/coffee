import 'dart:async';
import 'package:coffee/screens/recipePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  var channel = MethodChannel("get_data_bases");

  getDataBase(){
    channel.invokeMethod("getDataBase");
  }

  @override
  Widget build(BuildContext context) {
    getDataBase();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RecipePage()));
    });
    return Scaffold(
      body: Center(
        child:Image.asset('assets/image/launch_image.png')
      ),
    );
  }
}