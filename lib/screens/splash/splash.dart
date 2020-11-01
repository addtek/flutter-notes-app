import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:QuickNotes/utils/route_names.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future getAppView() async {

    return Timer(Duration(seconds: 2), changeScreen);
  }

  changeScreen() async {
        Navigator.pushReplacementNamed(context, Routes.main);
  }

  @override
  void initState() {
    super.initState();
    getAppView();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context)
          .backgroundColor
          .withOpacity(0.8),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Theme.of(context).primaryColor,
    ));
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.note,size: 80,),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Powered By: AddTeknologies",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    )
                  ],
                ),
                bottom: 20,
                left: 0,
                right: 0,
              ),
            ])));
  }
}
