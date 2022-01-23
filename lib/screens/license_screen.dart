// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:contacts_app/screens/home_screen.dart';
import 'package:contacts_app/widgets/MyButton.dart';
import 'package:contacts_app/widgets/MyTextField.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseScreen extends StatelessWidget {
  LicenseScreen({Key? key}) : super(key: key);

  TextEditingController systemController = TextEditingController();
  TextEditingController activeController = TextEditingController();

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void showSuccessDialog(BuildContext context) {
    CoolAlert.show(
      width: 100,
      context: context,
      type: CoolAlertType.success,
      title: 'موفق',
      confirmBtnText: 'باشه',
      confirmBtnTextStyle: TextStyle(fontSize: 16, color: Colors.white),
      confirmBtnColor: Colors.redAccent,
      text: "!کد سیستم با موفقیت کپی شد",
    );
  }

  @override
  Widget build(BuildContext context) {
    getId().then((value) {
      systemController.text = value ?? '';
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فعال سازی',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: Icon(Icons.lock),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: "${systemController.text}"),
                );
                showSuccessDialog(context);
              },
              child: MyTextField(
                controller: systemController,
                errorText: '',
                hintText: 'کد سیستم',
                isEnabled: false,
              ),
            ),
            SizedBox(height: 15),
            MyTextField(
              controller: activeController,
              errorText: '',
              hintText: 'کد فعال سازی',
            ),
            SizedBox(height: 15),
            MyButton(
              child: Text('فعال سازی'),
              width: double.infinity,
              onPressed: () async {
                var bytes1 = utf8.encode(systemController.text);
                var digest1 = sha512256.convert(bytes1);
                print(digest1);
                if (activeController.text == digest1.toString()) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isActive', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  );
                } else {
                  print('Invalid Active Code');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
