import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_app/screens/home_screen.dart';
import 'package:contacts_app/screens/license_screen.dart';
import 'package:cool_alert/cool_alert.dart';
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
  //
  static showInternetError(BuildContext context) {
    CoolAlert.show(
      width: 100,
      context: context,
      type: CoolAlertType.error,
      title: 'خطا',
      confirmBtnText: 'باشه',
      confirmBtnTextStyle: TextStyle(fontSize: 16, color: Colors.white),
      confirmBtnColor: Colors.redAccent,
      text: "!شما به اینترنت متصل نیستید",
    );
  }

  static bool isConnected = false;
  static Future<bool> checkInternet() async {
    Connectivity().onConnectivityChanged.listen((status) {
      print(status);
      if (status == ConnectivityResult.wifi ||
          status == ConnectivityResult.mobile) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    });
    return isConnected;
  }
  //

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    checkInternet();
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
