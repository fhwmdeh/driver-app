import 'dart:async';

import 'package:driver/allScreen/loginScreen.dart';
import 'package:driver/allScreen/mainScreen.dart';
import 'package:driver/global/global.dart';
import 'package:flutter/material.dart';


class mysplashscreen extends StatefulWidget {
  static const String idScreen = "splash";

  @override
  _mysplashscreenState createState() => _mysplashscreenState();
}

class _mysplashscreenState extends State<mysplashscreen> {

  startTimer(){
    Timer(Duration(seconds: 3 ), ()async{
      if(await fAuth.currentUser != null){

        currentFirebaseUser = fAuth.currentUser;

        Navigator.push(context, MaterialPageRoute(builder: ((context) => mainScreen())));

      }else{
        Navigator.push(context, MaterialPageRoute(builder: ((context) => signin())));
      }

    });
  }
  @override
  void initState(){

    super.initState();
    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/logo2.png"),
        ],)),

    );
  }
}