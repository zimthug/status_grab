import 'package:flutter/material.dart';
import 'package:status_grab/ui/splash_screen.dart';
import 'package:status_grab/utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Constants.primaryColor,
    100: Constants.primaryColor,
    200: Constants.primaryColor,
    300: Constants.primaryColor,
    400: Constants.primaryColor,
    500: Constants.primaryColor,
    600: Constants.primaryColor,
    700: Constants.primaryColor,
    800: Constants.primaryColor,
    900: Constants.primaryColor
  };

  MaterialColor primaryColor = MaterialColor(0xFF880E4F, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
