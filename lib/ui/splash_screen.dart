import 'dart:async';

import 'package:flutter/material.dart';
import 'package:status_grab/ui/main_screen.dart';
import 'package:status_grab/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    //Load app data here
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Constants.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Constants.appName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontStyle: FontStyle.italic,
                    fontFamily: "Lobster"),
              ),
              SizedBox(height: 30),
              Icon(Icons.beach_access, color: Colors.redAccent, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
