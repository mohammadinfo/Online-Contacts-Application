import 'package:contacts_app/screens/home_screen.dart';
import 'package:contacts_app/screens/license_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

Future<bool> isActive() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isActive') ?? false;
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دفترچه تلفن آنلاین',
      theme: ThemeData(fontFamily: 'iransans'),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: isActive(),
        builder: (future, snapshot) {
          if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return LicenseScreen();
          }
        },
      ),
    );
  }
}
