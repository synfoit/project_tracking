import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_tracking/model/token.dart';
import 'package:project_tracking/screen/LoginScreen.dart';
import 'package:project_tracking/screen/dashborad.dart';

import '../database/userDatabase.dart';
import 'HomeScreen.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() {
    return SplashState();
  }
}

class SplashState extends State {
  int login = 101;
  late int loginData;

  Token? token;

  @override
  void initState() {
    super.initState();
    loginData = login;
    UserDatabase.instance.getEmployee().then((result) {
      setState(() {
        token = result;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      UserDatabase.instance.getUser().then((result) {
        setState(() {
          loginData = result;
          if (loginData == 0) {
            Timer(
                Duration(seconds: 1),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())));
          } else {
            Timer(Duration(seconds: 1), () {
              UserDatabase.instance.getEmployee().then((value) {
                token = value;
              });

              if (token!.ssoNumber.trim() == "Servilink") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashBoard(
                            ssoNumber: token!.ssoNumber, token: token!.token)));
              } else {
                //
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                            ssoNumber: token!.ssoNumber, token: token!.token)));
              }
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = AssetImage(
        'assets/images/logo.png'); //<- Creates an object that fetches an image.
    var image = Image(
      image: assetsImage,
      height: 400,
      width: 600,
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: image,
          ),
        ));
  }
}
